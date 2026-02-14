


# “Gainers vs Losers by sector” visual in ggplot2 using a diverging horizontal bar chart (stacked bars with gains on left and losses on right).
# Below is a clean, reusable ggplot2 solution that closely matches your image.

library(tidyverse)
library(ggplot2)

df <- tribble(
  ~sector,                          ~gainers, ~losers, ~price_change,
  "Education",                         8,        20,      3.90,
  "IT Education",                      4,         7,      1.84,
  "Apparel",                           8,        11,      0.63,
  "Infra Investment Trusts",           5,         4,      0.08,
  "Leather",                           7,        13,     -0.08,
  "Consumer Durables",                24,        50,     -0.24,
  "Castings & Forgings",              21,        30,     -0.50,
  "Edible Oil",                        5,        16,     -0.55,
  "Infra Developers & Operators",     44,       100,     -0.62,
  "Textiles",                         96,       130,     -0.65
)


# Prepare Data for Diverging Bars
# We convert gainers to positive and losers to negative so they split left/right.

df_long <- df %>%
  pivot_longer(
    cols = c(gainers, losers),
    names_to = "type",
    values_to = "count"
  ) %>%
  mutate(
    value = if_else(type == "gainers", count, -count)
  )



# ggplot2 Chart (Core Plot)


ggplot(df_long, aes(x = value, y = fct_rev(sector), fill = type)) +
  geom_col(height = 0.10,alpha=.6) +
  scale_fill_manual(
    values = c("gainers" = "#12B886", "losers" = "#FA5252")
  ) +
  labs(
    title = "Trending sectors",
    x = NULL,
    y = NULL
  ) +
  theme_minimal(base_size = 13) +
  theme(
    legend.position = "none",
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank()
  ) +
  scale_x_continuous(labels = abs)+
  theme_linedraw()+
  theme_classic()



# Add Gainers / Losers Count Labels (Like Image)


ggplot(df_long, aes(x = value, y = fct_rev(sector), fill = type)) +
  geom_col(height = 0.25) +
  geom_text(
    aes(label = count),
    hjust = ifelse(df_long$type == "gainers", 1.1, -0.1),
    color = "grey30",
    size = 3
  ) +
  scale_fill_manual(
    values = c("gainers" = "#12B886", "losers" = "#FA5252")
  ) +
  scale_x_continuous(labels = abs) +
  labs(title = "Trending sectors") +
  theme_minimal(base_size = 13) +
  theme(
    legend.position = "none",
    panel.grid.major.y = element_blank()
  )


# (Optional) Add Price Change Column (Right-Aligned)
# If you want the % change on the right like the UI:


ggplot(df_long, aes(x = value, y = fct_rev(sector), fill = type)) +
  geom_col(height = 0.25,alpha=.5) +
  geom_text(
    data = df,
    aes(x = max(df$losers) * 1.15, 
        y = fct_rev(sector), 
        label = sprintf("%+.2f%%", price_change)),
    inherit.aes = FALSE,
    color = ifelse(df$price_change > 0, "#12B886", "#FA5252"),
    size = 3.5
  ) +
  scale_fill_manual(
    values = c("gainers" = "#12B886", "losers" = "#FA5252")
  ) +
  scale_x_continuous(labels = abs) +
  coord_cartesian(clip = "off") +
  theme_minimal() +
  theme(
    legend.position = "none",
    panel.grid.major.y = element_blank(),
    plot.margin = margin(5.5, 40, 5.5, 5.5)
  )+
  theme_classic()




# Key ggplot2 Concepts Used
# geom_col() → horizontal bars
# negative values → losers side
# fct_rev() → top-to-bottom ordering
# coord_cartesian(clip="off") → allow right-side labels
# manual color scale → UI-style green/red







