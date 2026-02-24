# =============================================================================
# DEEP-DIVE: ACTIVE vs VOLUNTARY CHURNERS
# Dimensions: Tenure | Recency | Frequency | Viewership Depth
# Granularity: Faceted by Product & Country
# Chart Styles: Density | Violin/Box | Survival | Cohort Bar
# =============================================================================

# --- 1. LIBRARIES ------------------------------------------------------------
library(dplyr)
library(ggplot2)
library(tidyr)
library(lubridate)
library(scales)
library(patchwork)
library(ggtext)
library(survival)    # Kaplan-Meier survival curves
library(survminer)   # ggplot2-based survival plots (ggsurvplot)
library(forcats)     # fct_reorder

# Install if missing:
# install.packages(c("survival", "survminer", "ggtext", "patchwork", "forcats"))

# --- 2. LOAD DATA ------------------------------------------------------------
VoluntaryChurn <- read.csv("VoluntaryChurn.csv")   # <-- update path
ViewershipInfo <- read.csv("ViewershipInfo.csv")   # <-- update path

# ViewershipInfo expected columns (adjust names to match your schema):
#   Customer_ID, total_watch_hours, session_count, avg_session_duration_mins,
#   completion_rate, binge_sessions, last_active_date, content_category

# --- 3. DATA PREPARATION -----------------------------------------------------

churn_df <- VoluntaryChurn %>%
  mutate(
    Subscription_start_date = as.Date(Subscription_start_date, origin = "1970-01-01"),
    Expiry_date             = as.Date(Expiry_date,             origin = "1970-01-01"),
    Cancellation_date       = as.Date(Cancellation_date,       origin = "1970-01-01"),

    # Group label: Active vs Voluntary Churner
    subscriber_group = case_when(
      Subscription_churn_type == "voluntary churn" ~ "Voluntary Churner",
      Subscription_status == "active"              ~ "Active",
      TRUE                                         ~ NA_character_
    ),

    # TENURE: days from start to expiry (or cancellation if churned)
    tenure_days = as.numeric(
      coalesce(Cancellation_date, Expiry_date) - Subscription_start_date
    ),

    # TENURE BAND: lifecycle stage buckets
    tenure_band = case_when(
      tenure_days <= 30  ~ "0–30d",
      tenure_days <= 90  ~ "31–90d",
      tenure_days <= 180 ~ "91–180d",
      tenure_days <= 365 ~ "181–365d",
      TRUE               ~ "365d+"
    ),
    tenure_band = factor(tenure_band,
                         levels = c("0–30d","31–90d","91–180d","181–365d","365d+"))
  ) %>%
  filter(!is.na(subscriber_group))

viewership_df <- ViewershipInfo %>%
  mutate(
    last_active_date         = as.Date(last_active_date, origin = "1970-01-01"),
    recency_days             = as.numeric(Sys.Date() - last_active_date),
    # Binge flag: sessions where user watched 3+ episodes / long duration
    is_binge_session         = binge_sessions > 0
  )

# Master joined table
df <- churn_df %>%
  inner_join(viewership_df, by = "Customer_ID") %>%
  filter(!is.na(Product_name), !is.na(Country))

# Shorten long country names for facet labels if needed
df <- df %>%
  mutate(Country = recode(Country,
    "United Arab Emirates" = "UAE"
  ))

# =============================================================================
# THEME & PALETTE
# =============================================================================

clr_active  <- "#2A9D8F"   # teal  — Active
clr_churn   <- "#E63946"   # red   — Voluntary Churner
grp_palette <- c("Active" = clr_active, "Voluntary Churner" = clr_churn)

base_theme <- theme_minimal(base_size = 12) +
  theme(
    plot.title       = element_markdown(face = "bold", size = 14, margin = margin(b = 4)),
    plot.subtitle    = element_text(color = "grey45", size = 10.5, margin = margin(b = 10)),
    plot.caption     = element_text(color = "grey60", size = 8.5, hjust = 0),
    axis.title       = element_text(size = 10, color = "grey30"),
    axis.text        = element_text(size = 9),
    legend.position  = "bottom",
    legend.title     = element_blank(),
    legend.key.size  = unit(0.5, "cm"),
    panel.grid.minor = element_blank(),
    strip.background = element_rect(fill = "#F0F4F8", color = NA),
    strip.text       = element_text(face = "bold", size = 9.5),
    plot.margin      = margin(14, 14, 14, 14)
  )

theme_set(base_theme)

# Helper: facet wrap by Product & Country
facet_prod_country <- facet_wrap(~ Product_name + Country,
                                  scales = "free_y", ncol = 4)

# =============================================================================
# SECTION A — TENURE ANALYSIS
# =============================================================================

# ── A1: Density Plot — Tenure Distribution ───────────────────────────────────
pA1 <- ggplot(df %>% filter(!is.na(tenure_days)),
              aes(x = tenure_days, fill = subscriber_group, color = subscriber_group)) +
  geom_density(alpha = 0.35, linewidth = 0.8) +
  geom_vline(data = df %>%
               filter(!is.na(tenure_days)) %>%
               group_by(subscriber_group) %>%
               summarise(med = median(tenure_days)),
             aes(xintercept = med, color = subscriber_group),
             linetype = "dashed", linewidth = 0.9) +
  scale_fill_manual(values  = grp_palette) +
  scale_color_manual(values = grp_palette) +
  scale_x_continuous(labels = comma) +
  facet_prod_country +
  labs(
    title    = "**A1 | Tenure Distribution** — Active vs Voluntary Churners",
    subtitle = "Dashed lines = group medians. Churners tend to exit earlier in the subscription lifecycle.",
    x        = "Tenure (Days)",
    y        = "Density",
    caption  = "Source: VoluntaryChurn table"
  )

# ── A2: Cohort Bar — Tenure Band (Lifecycle Stage) ───────────────────────────
tenure_cohort <- df %>%
  filter(!is.na(tenure_band)) %>%
  group_by(Product_name, Country, subscriber_group, tenure_band) %>%
  summarise(n = n(), .groups = "drop") %>%
  group_by(Product_name, Country, subscriber_group) %>%
  mutate(pct = n / sum(n) * 100)

pA2 <- ggplot(tenure_cohort,
              aes(x = tenure_band, y = pct, fill = subscriber_group)) +
  geom_col(position = "dodge", width = 0.7, alpha = 0.9) +
  scale_fill_manual(values = grp_palette) +
  scale_y_continuous(labels = label_percent(scale = 1)) +
  facet_prod_country +
  labs(
    title    = "**A2 | Lifecycle Stage Mix** — Active vs Voluntary Churners",
    subtitle = "Voluntary churners skew toward early lifecycle stages (0–90 days).",
    x        = "Tenure Band",
    y        = "Share of Group (%)",
    caption  = "Source: VoluntaryChurn table"
  ) +
  theme(axis.text.x = element_text(angle = 35, hjust = 1))

# ── A3: Survival Curve — Kaplan-Meier by Product ─────────────────────────────
# Event = voluntary churn (1), censored = still active (0)
surv_df <- df %>%
  filter(!is.na(tenure_days), tenure_days >= 0) %>%
  mutate(event = if_else(subscriber_group == "Voluntary Churner", 1L, 0L))

surv_obj <- Surv(time = surv_df$tenure_days, event = surv_df$event)
surv_fit <- survfit(surv_obj ~ Product_name, data = surv_df)

pA3 <- ggsurvplot(
  surv_fit,
  data          = surv_df,
  palette       = c("#E63946","#457B9D","#2A9D8F","#F4A261"),
  conf.int      = TRUE,
  conf.int.alpha= 0.12,
  risk.table    = TRUE,
  risk.table.height = 0.28,
  xlab          = "Days since Subscription Start",
  ylab          = "Retention Probability",
  title         = "A3 | Kaplan-Meier Survival Curve — Retention by Product",
  legend.title  = "Product",
  ggtheme       = base_theme
)

# =============================================================================
# SECTION B — RECENCY ANALYSIS
# =============================================================================

# ── B1: Violin + Box — Recency by Group ──────────────────────────────────────
pB1 <- ggplot(df %>% filter(!is.na(recency_days)),
              aes(x = subscriber_group, y = recency_days, fill = subscriber_group)) +
  geom_violin(alpha = 0.45, trim = TRUE, linewidth = 0.5) +
  geom_boxplot(width = 0.18, alpha = 0.85, outlier.shape = NA,
               color = "grey25", linewidth = 0.5) +
  stat_summary(fun = median, geom = "point",
               shape = 18, size = 3, color = "white") +
  scale_fill_manual(values = grp_palette) +
  scale_y_continuous(labels = comma) +
  coord_flip() +
  facet_prod_country +
  labs(
    title    = "**B1 | Recency (Days Since Last Active)** — Active vs Voluntary Churners",
    subtitle = "Wider violins and higher medians for churners indicate disengagement before exit.",
    x        = NULL,
    y        = "Days Since Last Active",
    caption  = "Source: ViewershipInfo table"
  ) +
  theme(legend.position = "none")

# ── B2: Density — Recency Distribution ───────────────────────────────────────
pB2 <- ggplot(df %>% filter(!is.na(recency_days)),
              aes(x = recency_days, fill = subscriber_group, color = subscriber_group)) +
  geom_density(alpha = 0.35, linewidth = 0.8) +
  scale_fill_manual(values  = grp_palette) +
  scale_color_manual(values = grp_palette) +
  scale_x_continuous(labels = comma) +
  facet_prod_country +
  labs(
    title    = "**B2 | Recency Density** — Active vs Voluntary Churners",
    subtitle = "Active subscribers cluster at low recency (recently active); churners spread right.",
    x        = "Days Since Last Active",
    y        = "Density",
    caption  = "Source: ViewershipInfo table"
  )

# ── B3: Cohort Bar — Recency Buckets ─────────────────────────────────────────
recency_cohort <- df %>%
  filter(!is.na(recency_days)) %>%
  mutate(
    recency_band = case_when(
      recency_days <= 7   ~ "≤7d",
      recency_days <= 30  ~ "8–30d",
      recency_days <= 90  ~ "31–90d",
      recency_days <= 180 ~ "91–180d",
      TRUE                ~ "180d+"
    ),
    recency_band = factor(recency_band,
                          levels = c("≤7d","8–30d","31–90d","91–180d","180d+"))
  ) %>%
  group_by(Product_name, Country, subscriber_group, recency_band) %>%
  summarise(n = n(), .groups = "drop") %>%
  group_by(Product_name, Country, subscriber_group) %>%
  mutate(pct = n / sum(n) * 100)

pB3 <- ggplot(recency_cohort,
              aes(x = recency_band, y = pct, fill = subscriber_group)) +
  geom_col(position = "dodge", width = 0.7, alpha = 0.9) +
  scale_fill_manual(values = grp_palette) +
  scale_y_continuous(labels = label_percent(scale = 1)) +
  facet_prod_country +
  labs(
    title    = "**B3 | Recency Band Mix** — Active vs Voluntary Churners",
    subtitle = "Churners concentrated in 31–180d+ recency; active users dominate ≤7d bucket.",
    x        = "Days Since Last Active",
    y        = "Share of Group (%)",
    caption  = "Source: ViewershipInfo table"
  ) +
  theme(axis.text.x = element_text(angle = 35, hjust = 1))

# =============================================================================
# SECTION C — FREQUENCY ANALYSIS
# =============================================================================

# ── C1: Violin — Session Frequency ───────────────────────────────────────────
pC1 <- ggplot(df %>% filter(!is.na(session_count)),
              aes(x = subscriber_group, y = session_count, fill = subscriber_group)) +
  geom_violin(alpha = 0.45, trim = TRUE, linewidth = 0.5) +
  geom_boxplot(width = 0.18, alpha = 0.85, outlier.shape = NA,
               color = "grey25", linewidth = 0.5) +
  stat_summary(fun = median, geom = "point",
               shape = 18, size = 3, color = "white") +
  scale_fill_manual(values = grp_palette) +
  scale_y_continuous(labels = comma) +
  coord_flip() +
  facet_prod_country +
  labs(
    title    = "**C1 | Session Frequency** — Active vs Voluntary Churners",
    subtitle = "Lower session counts among churners reflect declining engagement before cancellation.",
    x        = NULL,
    y        = "Total Sessions / Logins",
    caption  = "Source: ViewershipInfo table"
  ) +
  theme(legend.position = "none")

# ── C2: Density — Session Count Distribution ─────────────────────────────────
pC2 <- ggplot(df %>% filter(!is.na(session_count)),
              aes(x = session_count, fill = subscriber_group, color = subscriber_group)) +
  geom_density(alpha = 0.35, linewidth = 0.8) +
  scale_fill_manual(values  = grp_palette) +
  scale_color_manual(values = grp_palette) +
  scale_x_continuous(labels = comma) +
  facet_prod_country +
  labs(
    title    = "**C2 | Session Count Density** — Active vs Voluntary Churners",
    subtitle = "Active subscribers show a heavier right tail — more frequent users.",
    x        = "Total Sessions",
    y        = "Density",
    caption  = "Source: ViewershipInfo table"
  )

# ── C3: Cohort Bar — Frequency Segments ──────────────────────────────────────
freq_cohort <- df %>%
  filter(!is.na(session_count)) %>%
  mutate(
    freq_segment = case_when(
      session_count <= 2  ~ "Low (1–2)",
      session_count <= 10 ~ "Med (3–10)",
      session_count <= 30 ~ "High (11–30)",
      TRUE                ~ "Power (30+)"
    ),
    freq_segment = factor(freq_segment,
                          levels = c("Low (1–2)","Med (3–10)","High (11–30)","Power (30+)"))
  ) %>%
  group_by(Product_name, Country, subscriber_group, freq_segment) %>%
  summarise(n = n(), .groups = "drop") %>%
  group_by(Product_name, Country, subscriber_group) %>%
  mutate(pct = n / sum(n) * 100)

pC3 <- ggplot(freq_cohort,
              aes(x = freq_segment, y = pct, fill = subscriber_group)) +
  geom_col(position = "dodge", width = 0.7, alpha = 0.9) +
  scale_fill_manual(values = grp_palette) +
  scale_y_continuous(labels = label_percent(scale = 1)) +
  facet_prod_country +
  labs(
    title    = "**C3 | Frequency Segment Mix** — Active vs Voluntary Churners",
    subtitle = "Churners over-index on Low/Med frequency; Active users lead in High/Power segments.",
    x        = "Frequency Segment",
    y        = "Share of Group (%)",
    caption  = "Source: ViewershipInfo table"
  ) +
  theme(axis.text.x = element_text(angle = 25, hjust = 1))

# =============================================================================
# SECTION D — VIEWERSHIP DEPTH ANALYSIS
# =============================================================================

# ── D1: Violin — Watch Hours ──────────────────────────────────────────────────
pD1 <- ggplot(df %>% filter(!is.na(total_watch_hours)),
              aes(x = subscriber_group, y = total_watch_hours, fill = subscriber_group)) +
  geom_violin(alpha = 0.45, trim = TRUE, linewidth = 0.5) +
  geom_boxplot(width = 0.18, alpha = 0.85, outlier.shape = NA,
               color = "grey25", linewidth = 0.5) +
  stat_summary(fun = median, geom = "point",
               shape = 18, size = 3, color = "white") +
  scale_fill_manual(values = grp_palette) +
  scale_y_continuous(labels = comma) +
  coord_flip() +
  facet_prod_country +
  labs(
    title    = "**D1 | Total Watch Hours** — Active vs Voluntary Churners",
    subtitle = "Voluntary churners log substantially fewer hours, signalling shallow product investment.",
    x        = NULL,
    y        = "Total Watch Hours",
    caption  = "Source: ViewershipInfo table"
  ) +
  theme(legend.position = "none")

# ── D2: Density — Completion Rate ────────────────────────────────────────────
pD2 <- ggplot(df %>% filter(!is.na(completion_rate)),
              aes(x = completion_rate, fill = subscriber_group, color = subscriber_group)) +
  geom_density(alpha = 0.35, linewidth = 0.8) +
  geom_vline(data = df %>%
               filter(!is.na(completion_rate)) %>%
               group_by(subscriber_group) %>%
               summarise(med = median(completion_rate)),
             aes(xintercept = med, color = subscriber_group),
             linetype = "dashed", linewidth = 0.9) +
  scale_fill_manual(values  = grp_palette) +
  scale_color_manual(values = grp_palette) +
  scale_x_continuous(labels = label_percent(scale = 1), limits = c(0, 100)) +
  facet_prod_country +
  labs(
    title    = "**D2 | Content Completion Rate** — Active vs Voluntary Churners",
    subtitle = "Dashed = group medians. Lower completion = less committed viewing behavior.",
    x        = "Completion Rate (%)",
    y        = "Density",
    caption  = "Source: ViewershipInfo table"
  )

# ── D3: Cohort Bar — Binge Behavior ──────────────────────────────────────────
binge_cohort <- df %>%
  filter(!is.na(binge_sessions)) %>%
  mutate(
    binge_segment = case_when(
      binge_sessions == 0 ~ "Non-Binger",
      binge_sessions <= 3 ~ "Occasional (1–3)",
      binge_sessions <= 10~ "Regular (4–10)",
      TRUE                ~ "Heavy (10+)"
    ),
    binge_segment = factor(binge_segment,
                           levels = c("Non-Binger","Occasional (1–3)",
                                      "Regular (4–10)","Heavy (10+)"))
  ) %>%
  group_by(Product_name, Country, subscriber_group, binge_segment) %>%
  summarise(n = n(), .groups = "drop") %>%
  group_by(Product_name, Country, subscriber_group) %>%
  mutate(pct = n / sum(n) * 100)

pD3 <- ggplot(binge_cohort,
              aes(x = binge_segment, y = pct, fill = subscriber_group)) +
  geom_col(position = "dodge", width = 0.7, alpha = 0.9) +
  scale_fill_manual(values = grp_palette) +
  scale_y_continuous(labels = label_percent(scale = 1)) +
  facet_prod_country +
  labs(
    title    = "**D3 | Binge Behavior Mix** — Active vs Voluntary Churners",
    subtitle = "Churners skew toward Non-Binger/Occasional; Active subscribers binge more regularly.",
    x        = "Binge Segment",
    y        = "Share of Group (%)",
    caption  = "Source: ViewershipInfo table"
  ) +
  theme(axis.text.x = element_text(angle = 25, hjust = 1))

# ── D4: Violin — Avg Session Duration ────────────────────────────────────────
pD4 <- ggplot(df %>% filter(!is.na(avg_session_duration_mins)),
              aes(x = subscriber_group, y = avg_session_duration_mins,
                  fill = subscriber_group)) +
  geom_violin(alpha = 0.45, trim = TRUE, linewidth = 0.5) +
  geom_boxplot(width = 0.18, alpha = 0.85, outlier.shape = NA,
               color = "grey25", linewidth = 0.5) +
  stat_summary(fun = median, geom = "point",
               shape = 18, size = 3, color = "white") +
  scale_fill_manual(values = grp_palette) +
  scale_y_continuous(labels = comma) +
  coord_flip() +
  facet_prod_country +
  labs(
    title    = "**D4 | Avg Session Duration (mins)** — Active vs Voluntary Churners",
    subtitle = "Churners show shorter per-session engagement — browsing but not committing to content.",
    x        = NULL,
    y        = "Avg Session Duration (minutes)",
    caption  = "Source: ViewershipInfo table"
  ) +
  theme(legend.position = "none")

# =============================================================================
# SECTION E — COMBINED SUMMARY DASHBOARD
# =============================================================================

# Key metrics summary table → diverging bar chart
summary_metrics <- df %>%
  group_by(subscriber_group) %>%
  summarise(
    `Median Tenure (days)`      = median(tenure_days,              na.rm = TRUE),
    `Median Recency (days)`     = median(recency_days,             na.rm = TRUE),
    `Median Sessions`           = median(session_count,            na.rm = TRUE),
    `Median Watch Hours`        = median(total_watch_hours,        na.rm = TRUE),
    `Median Completion Rate`    = median(completion_rate,          na.rm = TRUE),
    `Median Session Dur (mins)` = median(avg_session_duration_mins,na.rm = TRUE),
    .groups = "drop"
  ) %>%
  pivot_longer(-subscriber_group, names_to = "metric", values_to = "value") %>%
  group_by(metric) %>%
  mutate(
    active_val = value[subscriber_group == "Active"],
    diff_pct   = (value - active_val) / active_val * 100
  ) %>%
  filter(subscriber_group == "Voluntary Churner")

pE1 <- ggplot(summary_metrics,
              aes(x = reorder(metric, diff_pct), y = diff_pct,
                  fill = diff_pct > 0)) +
  geom_col(width = 0.65, alpha = 0.9, show.legend = FALSE) +
  geom_hline(yintercept = 0, color = "grey30", linewidth = 0.6) +
  geom_text(aes(label = sprintf("%+.0f%%", diff_pct),
                hjust = if_else(diff_pct >= 0, -0.15, 1.1)),
            size = 3.6, color = "grey20") +
  scale_fill_manual(values = c("TRUE" = clr_churn, "FALSE" = clr_active)) +
  scale_y_continuous(labels = label_percent(scale = 1),
                     expand = expansion(mult = c(0.15, 0.2))) +
  coord_flip() +
  labs(
    title    = "**E1 | Voluntary Churners vs Active — % Difference on Key Metrics**",
    subtitle = "Red bars = churners are worse; teal = churners score higher (e.g. recency = bad if higher).",
    x        = NULL,
    y        = "% Difference vs Active Subscribers",
    caption  = "All metrics at group medians. Source: VoluntaryChurn + ViewershipInfo tables"
  )

# =============================================================================
# SAVE ALL PLOTS
# =============================================================================

plots_list <- list(
  "A1_tenure_density.png"         = pA1,
  "A2_tenure_cohort_bar.png"      = pA2,
  "B1_recency_violin.png"         = pB1,
  "B2_recency_density.png"        = pB2,
  "B3_recency_cohort_bar.png"     = pB3,
  "C1_frequency_violin.png"       = pC1,
  "C2_frequency_density.png"      = pC2,
  "C3_frequency_cohort_bar.png"   = pC3,
  "D1_watch_hours_violin.png"     = pD1,
  "D2_completion_rate_density.png"= pD2,
  "D3_binge_behavior_bar.png"     = pD3,
  "D4_session_duration_violin.png"= pD4,
  "E1_summary_diverging_bar.png"  = pE1
)

for (fname in names(plots_list)) {
  ggsave(fname, plots_list[[fname]], width = 16, height = 10, dpi = 180)
  cat("Saved:", fname, "\n")
}

# Survival curve needs special saving via survminer
ggsave("A3_survival_curve_by_product.png",
       print(pA3),
       width = 12, height = 8, dpi = 180)

# ── Combined Section Dashboards ───────────────────────────────────────────────
tenure_dashboard  <- (pA1 | pA2) + plot_annotation(title = "SECTION A — TENURE")
recency_dashboard <- (pB1 | pB2) / pB3 + plot_annotation(title = "SECTION B — RECENCY")
freq_dashboard    <- (pC1 | pC2) / pC3 + plot_annotation(title = "SECTION C — FREQUENCY")
depth_dashboard   <- (pD1 | pD2) / (pD3 | pD4) + plot_annotation(title = "SECTION D — VIEWERSHIP DEPTH")

ggsave("DASHBOARD_A_tenure.png",          tenure_dashboard,  width = 20, height = 11, dpi = 180)
ggsave("DASHBOARD_B_recency.png",         recency_dashboard, width = 20, height = 15, dpi = 180)
ggsave("DASHBOARD_C_frequency.png",       freq_dashboard,    width = 20, height = 15, dpi = 180)
ggsave("DASHBOARD_D_viewership_depth.png",depth_dashboard,   width = 20, height = 15, dpi = 180)

message("\n✅ All plots saved. Check your working directory.\n")

# =============================================================================
# CONSOLE SUMMARY TABLE
# =============================================================================

cat("\n", strrep("=", 65), "\n")
cat("   MEDIAN METRIC COMPARISON: Active vs Voluntary Churners\n")
cat(strrep("=", 65), "\n")

df %>%
  group_by(subscriber_group) %>%
  summarise(
    Tenure_days      = median(tenure_days,               na.rm = TRUE),
    Recency_days     = median(recency_days,              na.rm = TRUE),
    Sessions         = median(session_count,             na.rm = TRUE),
    Watch_hours      = median(total_watch_hours,         na.rm = TRUE),
    Completion_pct   = median(completion_rate,           na.rm = TRUE),
    Session_dur_mins = median(avg_session_duration_mins, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  print(width = Inf)

cat("\n")

cat("   CHURN RATE BY PRODUCT + COUNTRY\n")
cat(strrep("-", 65), "\n")
df %>%
  group_by(Product_name, Country) %>%
  summarise(
    Total        = n(),
    Vol_Churners = sum(subscriber_group == "Voluntary Churner"),
    Churn_Rate   = paste0(round(Vol_Churners / Total * 100, 1), "%"),
    .groups = "drop"
  ) %>%
  arrange(desc(Vol_Churners)) %>%
  print(n = Inf)
