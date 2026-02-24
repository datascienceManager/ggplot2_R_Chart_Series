# =============================================================================
# VOLUNTARY CHURN ANALYSIS - ggplot2 Visualizations
# Tables: Inactive + Behaviour
# =============================================================================

# --- 1. LIBRARIES -------------------------------------------------------------
library(dplyr)
library(ggplot2)
library(tidyr)
library(lubridate)
library(scales)
library(patchwork)   # combine plots
library(ggtext)      # rich text in titles

# --- 2. LOAD DATA -------------------------------------------------------------
# Replace these paths with your actual data sources
# e.g. read.csv(), dbGetQuery(), read_parquet(), etc.

Inactivesubs <- read.csv("Inactivesubs.csv")   # <-- update path
BehaviourView <- read.csv("BehaviourView.csv")   # <-- update path

# --- 3. PREPARE: Inactivesubs -----------------------------------------------
# Keep only voluntary churners (Subscription_churn_type == "voluntary churn")
# and relevant active subscribers for churn rate denominators.

churn_df <- Inactivesubs %>%
  mutate(
    # Parse dates (stored as integer days since 1970-01-01 in sample data)
    Subscription_start_date  = as.Date(Subscription_start_date, origin = "1970-01-01"),
    Expiry_date              = as.Date(Expiry_date,              origin = "1970-01-01"),
    Cancellation_date        = as.Date(Cancellation_date,        origin = "1970-01-01"),

    # Flag voluntary churners
    is_voluntary_churn = (Subscription_churn_type == "voluntary churn"),

    # Subscription duration in days
    subscription_days = as.numeric(Expiry_date - Subscription_start_date)
  )

# --- 4. JOIN VIEWERSHIP -------------------------------------------------------
# Assumes BehaviourView has: Customer_ID, total_watch_hours,
# content_category (most watched), last_active_date
# Adjust column names to match your actual schema.

viewership_df <- BehaviourView %>%
  mutate(
    last_active_date = as.Date(last_active_date, origin = "1970-01-01"),
    # Days since last active (recency) — relative to today or a snapshot date
    recency_days = as.numeric(Sys.Date() - last_active_date)
  )

combined_df <- churn_df %>%
  left_join(viewership_df, by = "Customer_ID")

# Voluntary-only subset
voluntary_df <- combined_df %>%
  filter(is_voluntary_churn == TRUE)

# =============================================================================
# THEME & COLOR PALETTE
# =============================================================================

tod_palette <- c(
  "#E63946",  # red    — churn / warning
  "#457B9D",  # blue   — product A
  "#1D3557",  # navy   — product B
  "#A8DADC",  # teal   — product C
  "#F4A261",  # orange — product D
  "#2A9D8F",  # green  — active
  "#E9C46A"   # yellow — highlight
)

base_theme <- theme_minimal(base_size = 13) +
  theme(
    plot.title    = element_markdown(face = "bold", size = 15, margin = margin(b = 6)),
    plot.subtitle = element_text(color = "grey45", size = 11, margin = margin(b = 12)),
    plot.caption  = element_text(color = "grey60", size = 9,  hjust = 0),
    axis.title    = element_text(size = 11, color = "grey30"),
    axis.text     = element_text(size = 10),
    legend.position = "bottom",
    legend.title  = element_text(size = 10, face = "bold"),
    panel.grid.minor = element_blank(),
    strip.text    = element_text(face = "bold", size = 11),
    plot.margin   = margin(16, 16, 16, 16)
  )

theme_set(base_theme)

# =============================================================================
# PLOT 1 — Voluntary Churn Rate by Product/Offer (Bar Chart)
# =============================================================================

churn_by_product <- churn_df %>%
  group_by(Product_name) %>%
  summarise(
    total        = n(),
    vol_churned  = sum(is_voluntary_churn, na.rm = TRUE),
    churn_rate   = vol_churned / total * 100
  ) %>%
  arrange(desc(churn_rate))

p1 <- ggplot(churn_by_product,
             aes(x = reorder(Product_name, churn_rate),
                 y = churn_rate,
                 fill = Product_name)) +
  geom_col(width = 0.65, show.legend = FALSE) +
  geom_text(aes(label = sprintf("%.1f%%", churn_rate)),
            hjust = -0.15, size = 3.8, color = "grey25") +
  scale_fill_manual(values = tod_palette) +
  scale_y_continuous(labels = label_percent(scale = 1),
                     expand = expansion(mult = c(0, 0.15))) +
  coord_flip() +
  labs(
    title    = "**Voluntary Churn Rate** by Product",
    subtitle = "% of subscribers per product who voluntarily churned",
    x        = NULL,
    y        = "Voluntary Churn Rate (%)",
    caption  = "Source: Inactivesubs table"
  )

# =============================================================================
# PLOT 2 — Voluntary Churn Rate by Payment Method (Lollipop Chart)
# =============================================================================

churn_by_payment <- churn_df %>%
  group_by(Payment_method) %>%
  summarise(
    total       = n(),
    vol_churned = sum(is_voluntary_churn, na.rm = TRUE),
    churn_rate  = vol_churned / total * 100
  ) %>%
  arrange(desc(churn_rate))

p2 <- ggplot(churn_by_payment,
             aes(x = reorder(Payment_method, churn_rate),
                 y = churn_rate)) +
  geom_segment(aes(xend = reorder(Payment_method, churn_rate), yend = 0),
               color = "grey75", linewidth = 1) +
  geom_point(aes(color = Payment_method), size = 6, show.legend = FALSE) +
  geom_text(aes(label = sprintf("%.1f%%", churn_rate)),
            hjust = -0.5, size = 3.8, color = "grey25") +
  scale_color_manual(values = tod_palette) +
  scale_y_continuous(labels = label_percent(scale = 1),
                     expand = expansion(mult = c(0, 0.2))) +
  coord_flip() +
  labs(
    title    = "**Voluntary Churn Rate** by Payment Method",
    subtitle = "Higher churn in certain payment channels may indicate friction or preference",
    x        = NULL,
    y        = "Voluntary Churn Rate (%)",
    caption  = "Source: Inactivesubs table"
  )

# =============================================================================
# PLOT 3 — Product × Payment Method Heatmap (Churn Rate)
# =============================================================================

churn_heatmap <- churn_df %>%
  group_by(Product_name, Payment_method) %>%
  summarise(
    total       = n(),
    vol_churned = sum(is_voluntary_churn, na.rm = TRUE),
    churn_rate  = vol_churned / total * 100,
    .groups     = "drop"
  )

p3 <- ggplot(churn_heatmap,
             aes(x = Payment_method, y = Product_name, fill = churn_rate)) +
  geom_tile(color = "white", linewidth = 0.8) +
  geom_text(aes(label = sprintf("%.1f%%", churn_rate)),
            size = 3.5, color = "white", fontface = "bold") +
  scale_fill_gradient(low = "#A8DADC", high = "#E63946",
                      labels = label_percent(scale = 1),
                      name   = "Churn Rate (%)") +
  labs(
    title    = "**Voluntary Churn Rate** — Product × Payment Method",
    subtitle = "Darker red = higher churn risk combinations",
    x        = "Payment Method",
    y        = "Product",
    caption  = "Source: Inactivesubs table"
  ) +
  theme(axis.text.x = element_text(angle = 30, hjust = 1),
        legend.key.width = unit(1.5, "cm"))

# =============================================================================
# PLOT 4 — Watch Hours: Churned vs Active (Boxplot + Jitter)
# =============================================================================

p4 <- ggplot(combined_df %>% filter(!is.na(total_watch_hours)),
             aes(x = Subscription_status,
                 y = total_watch_hours,
                 fill = Subscription_status)) +
  geom_boxplot(alpha = 0.7, outlier.shape = NA, width = 0.5) +
  geom_jitter(aes(color = Subscription_status),
              width = 0.15, alpha = 0.4, size = 1.5, show.legend = FALSE) +
  scale_fill_manual(values  = c("active" = "#2A9D8F", "churned" = "#E63946"),
                    name    = "Status") +
  scale_color_manual(values = c("active" = "#2A9D8F", "churned" = "#E63946")) +
  scale_y_continuous(labels = comma) +
  facet_wrap(~Product_name, scales = "free_y") +
  labs(
    title    = "**Watch Hours Distribution** — Active vs Voluntarily Churned",
    subtitle = "Lower engagement hours may be an early churn signal",
    x        = NULL,
    y        = "Total Watch Hours",
    caption  = "Source: Inactivesubs + BehaviourView tables"
  )

# =============================================================================
# PLOT 5 — Content Category Distribution: Voluntary Churners vs Active
# =============================================================================

category_df <- combined_df %>%
  filter(!is.na(content_category)) %>%
  group_by(Subscription_status, content_category) %>%
  summarise(n = n(), .groups = "drop") %>%
  group_by(Subscription_status) %>%
  mutate(pct = n / sum(n) * 100)

p5 <- ggplot(category_df,
             aes(x = reorder(content_category, pct),
                 y = pct,
                 fill = Subscription_status)) +
  geom_col(position = "dodge", width = 0.7) +
  scale_fill_manual(values = c("active" = "#457B9D", "churned" = "#E63946"),
                    name   = "Subscription Status") +
  scale_y_continuous(labels = label_percent(scale = 1)) +
  coord_flip() +
  labs(
    title    = "**Content Category Preferences** — Active vs Voluntarily Churned",
    subtitle = "Identifies content types more/less associated with churn",
    x        = NULL,
    y        = "Share of Subscribers (%)",
    caption  = "Source: BehaviourView table"
  )

# =============================================================================
# PLOT 6 — Recency (Days Since Last Active) by Churn Status
# =============================================================================

p6 <- ggplot(combined_df %>% filter(!is.na(recency_days)),
             aes(x = recency_days, fill = Subscription_status)) +
  geom_histogram(binwidth = 15, alpha = 0.75, position = "identity", color = "white") +
  scale_fill_manual(values = c("active" = "#2A9D8F", "churned" = "#E63946"),
                    name   = "Status") +
  scale_x_continuous(labels = comma) +
  scale_y_continuous(labels = comma) +
  facet_wrap(~Subscription_status, scales = "free_y", ncol = 1) +
  labs(
    title    = "**Days Since Last Active** — Active vs Voluntarily Churned",
    subtitle = "Churned subscribers tend to have higher recency (inactive longer before leaving)",
    x        = "Days Since Last Active",
    y        = "Number of Subscribers",
    caption  = "Source: BehaviourView table"
  ) +
  theme(legend.position = "none")

# =============================================================================
# PLOT 7 — Voluntary Churn Rate by Offer Period (Monthly Trend Proxy)
# =============================================================================

churn_offer_period <- churn_df %>%
  group_by(Offer_period, Product_name) %>%
  summarise(
    total       = n(),
    vol_churned = sum(is_voluntary_churn, na.rm = TRUE),
    churn_rate  = vol_churned / total * 100,
    .groups     = "drop"
  )

p7 <- ggplot(churn_offer_period,
             aes(x = Offer_period, y = churn_rate,
                 color = Product_name, group = Product_name)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 3.5) +
  scale_color_manual(values = tod_palette, name = "Product") +
  scale_y_continuous(labels = label_percent(scale = 1)) +
  scale_x_discrete(limits = c("daily", "monthly", "6-months", "custom")) +
  labs(
    title    = "**Voluntary Churn Rate** by Offer Period & Product",
    subtitle = "Shorter commitment periods may correlate with higher voluntary churn",
    x        = "Offer Period",
    y        = "Voluntary Churn Rate (%)",
    caption  = "Source: Inactivesubs table"
  )

# =============================================================================
# PLOT 8 — Avg Watch Hours vs Churn Rate by Product (Scatter Insight)
# =============================================================================

product_summary <- combined_df %>%
  group_by(Product_name) %>%
  summarise(
    avg_watch_hours = mean(total_watch_hours, na.rm = TRUE),
    churn_rate      = mean(is_voluntary_churn, na.rm = TRUE) * 100,
    n               = n(),
    .groups         = "drop"
  )

p8 <- ggplot(product_summary,
             aes(x = avg_watch_hours, y = churn_rate,
                 size = n, color = Product_name, label = Product_name)) +
  geom_point(alpha = 0.8) +
  geom_text(vjust = -1.2, size = 3.5, fontface = "bold", show.legend = FALSE) +
  scale_size_continuous(range = c(5, 15), name = "Subscriber Count", labels = comma) +
  scale_color_manual(values = tod_palette, guide = "none") +
  scale_y_continuous(labels = label_percent(scale = 1)) +
  scale_x_continuous(labels = comma) +
  labs(
    title    = "**Avg Watch Hours vs Voluntary Churn Rate** by Product",
    subtitle = "Low engagement + high churn products are the most at-risk",
    x        = "Average Watch Hours per Subscriber",
    y        = "Voluntary Churn Rate (%)",
    caption  = "Source: Inactivesubs + BehaviourView tables"
  )

# =============================================================================
# SAVE ALL PLOTS
# =============================================================================

# Individual files
ggsave("plot1_churn_by_product.png",       p1, width = 9, height = 5,  dpi = 180)
ggsave("plot2_churn_by_payment.png",       p2, width = 9, height = 5,  dpi = 180)
ggsave("plot3_product_payment_heatmap.png",p3, width = 10, height = 6, dpi = 180)
ggsave("plot4_watch_hours_boxplot.png",    p4, width = 12, height = 7, dpi = 180)
ggsave("plot5_content_category.png",      p5, width = 10, height = 6, dpi = 180)
ggsave("plot6_recency_histogram.png",     p6, width = 9,  height = 7, dpi = 180)
ggsave("plot7_churn_by_offer_period.png", p7, width = 10, height = 6, dpi = 180)
ggsave("plot8_engagement_vs_churn.png",   p8, width = 9,  height = 6, dpi = 180)

# Combined dashboard (2×2 key plots)
dashboard <- (p1 | p2) / (p3 | p7)
ggsave("churn_dashboard.png", dashboard, width = 18, height = 12, dpi = 180)

message("✅ All plots saved successfully.")

# =============================================================================
# QUICK SUMMARY PRINTOUT
# =============================================================================

cat("\n====== VOLUNTARY CHURN SUMMARY ======\n")

cat("\n-- Churn Rate by Product --\n")
print(churn_by_product %>% select(Product_name, total, vol_churned, churn_rate) %>%
        arrange(desc(churn_rate)))

cat("\n-- Churn Rate by Payment Method --\n")
print(churn_by_payment %>% select(Payment_method, total, vol_churned, churn_rate) %>%
        arrange(desc(churn_rate)))

cat("\n-- Avg Watch Hours: Active vs Churned --\n")
combined_df %>%
  group_by(Subscription_status) %>%
  summarise(
    avg_watch_hours = mean(total_watch_hours, na.rm = TRUE),
    median_recency  = median(recency_days, na.rm = TRUE)
  ) %>%
  print()
