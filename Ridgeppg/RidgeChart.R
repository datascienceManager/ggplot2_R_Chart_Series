

library(tidyverse)
library(ggridges)


# This is a ridgeline + quantile-interval + median dot chart.
# In ggplot2, it’s built by combining:
#   ggridges::geom_density_ridges() → grey distribution
# quantile bars (50%, 80%, 95%) → horizontal segments
# median point
# global median vertical line
# Below is a faithful ggplot2 reconstruction you can adapt to your data.



# Example data structure (matches chart logic)
# You need rent prices per adjective, not aggregated values.


set.seed(123)

df <- tibble(
  adjective = rep(c(
    "CLEAN","NICE","SPECIAL","SUNNY","CLOSE","BRIGHT","PRIVATE",
    "SPACIOUS","LOVELY","HUGE","BEAUTIFUL","VICTORIAN","SINGLE",
    "GORGEOUS","FURNISHED"
  ), each = 400),
  rent = rlnorm(6000, meanlog = 8, sdlog = 0.35)
)


# Compute summary statistics (quantiles + median)


stats <- df %>%
  group_by(adjective) %>%
  summarise(
    q05 = quantile(rent, 0.05),
    q10 = quantile(rent, 0.10),
    q25 = quantile(rent, 0.25),
    q50 = median(rent),
    q75 = quantile(rent, 0.75),
    q90 = quantile(rent, 0.90),
    q95 = quantile(rent, 0.95)
  )


# Global median (vertical dashed line)
global_median <- median(df$rent)




ggplot(df, aes(x = rent, y = fct_rev(adjective))) +
  
  # Distribution (grey ridgeline)
  geom_density_ridges(
    fill = "grey80",
    color = NA,
    alpha = 0.8,
    scale = 1.2
  ) +
  
  # 95% interval
  geom_segment(
    data = stats,
    aes(x = q05, xend = q95, y = adjective, yend = adjective),
    inherit.aes = FALSE,
    size = 6,
    color = "#ECEBD2"
  ) +
  
  # 80% interval
  geom_segment(
    data = stats,
    aes(x = q10, xend = q90, y = adjective, yend = adjective),
    inherit.aes = FALSE,
    size = 6,
    color = "#C7DDB0"
  ) +
  
  # 50% interval
  geom_segment(
    data = stats,
    aes(x = q25, xend = q75, y = adjective, yend = adjective),
    inherit.aes = FALSE,
    size = 6,
    color = "#9BC17C"
  ) +
  
  # Median point
  geom_point(
    data = stats,
    aes(x = q50, y = adjective),
    inherit.aes = FALSE,
    size = 2.5,
    color = "black"
  ) +
  
  # Global median line
  geom_vline(
    xintercept = global_median,
    linetype = "dashed",
    color = "grey30"
  ) +
  
  labs(
    title = "NICE AND CLEAN – RELATIVELY LOW RENT?",
    subtitle = "Adjectives used in Craigslist rental listings and their relation to rent",
    x = NULL,
    y = NULL
  ) +
  
  theme_minimal(base_size = 13) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_blank(),
    axis.ticks = element_blank()
  )

# 
# | Chart element   | ggplot layer              |
#   | --------------- | ------------------------- |
#   | Grey shape      | `geom_density_ridges()`   |
#   | 95% price range | `geom_segment(q05 → q95)` |
#   | 80% price range | `geom_segment(q10 → q90)` |
#   | 50% price range | `geom_segment(q25 → q75)` |
#   | Median dot      | `geom_point(q50)`         |
#   | Vertical median | `geom_vline()`            |
#   


# 
# Notes for production-quality match
# Use real rent values (not simulated)
# Adjust scale in geom_density_ridges() for spacing
# Use log-scale rents if long right tail:

# scale_x_log10()



# ----- Second method 


p=ggplot(df, aes(x = rent, y = fct_rev(adjective))) +
  
  # Grey rent distribution
  geom_density_ridges(
    fill = "grey85",
    color = NA,
    alpha = 0.9,
    scale = 1.15
  ) +
  
  # 95% range
  geom_segment(
    data = stats,
    aes(x = q05, xend = q95, y = adjective, yend = adjective),
    inherit.aes = FALSE,
    linewidth = 6,
    color = "#ECEBD2"
  ) +
  
  # 80% range
  geom_segment(
    data = stats,
    aes(x = q10, xend = q90, y = adjective, yend = adjective),
    inherit.aes = FALSE,
    linewidth = 6,
    color = "#C7DDB0"
  ) +
  
  # 50% range
  geom_segment(
    data = stats,
    aes(x = q25, xend = q75, y = adjective, yend = adjective),
    inherit.aes = FALSE,
    linewidth = 6,
    color = "#9BC17C"
  ) +
  
  # Median point
  geom_point(
    data = stats,
    aes(x = q50, y = adjective),
    inherit.aes = FALSE,
    size = 2.6,
    color = "black"
  ) +
  
  # Global median
  geom_vline(
    xintercept = global_median,
    linetype = "dashed",
    linewidth = 0.8,
    color = "grey30"
  ) +
  
  # Log scale (important for long tail)
  scale_x_log10(
    breaks = c(1000, 2500, 5000, 7500, 10000),
    labels = scales::comma
  ) +
  
  labs(
    title = "NICE AND CLEAN – RELATIVELY LOW RENT?",
    subtitle = "Adjectives in Craigslist rental titles and their relationship to rent",
    x = "Rent in USD",
    y = NULL
  ) +
  
  theme_minimal(base_size = 13) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.y = element_text(face = "bold"),
    axis.ticks = element_blank()
  )






# ============================= 3 with median legends display ========



ggplot(df, aes(x = rent, y = fct_rev(adjective))) +
  
  # Grey rent distribution
  geom_density_ridges(
    fill = "grey85",
    color = NA,
    alpha = 0.9,
    scale = 1.15
  ) +
  
  # 95% range
  geom_segment(
    data = stats,
    aes(x = q05, xend = q95, y = adjective, yend = adjective),
    inherit.aes = FALSE,
    linewidth = 6,
    color = "#ECEBD2"
  ) +
  
  # 80% range
  geom_segment(
    data = stats,
    aes(x = q10, xend = q90, y = adjective, yend = adjective),
    inherit.aes = FALSE,
    linewidth = 6,
    color = "#C7DDB0"
  ) +
  
  # 50% range
  geom_segment(
    data = stats,
    aes(x = q25, xend = q75, y = adjective, yend = adjective),
    inherit.aes = FALSE,
    linewidth = 6,
    color = "#9BC17C"
  ) +
  
  # Median point
  geom_point(
    data = stats,
    aes(x = q50, y = adjective),
    inherit.aes = FALSE,
    size = 2.6,
    color = "black"
  ) +
  
  # Median value label per adjective
  geom_text(
    data = stats,
    aes(
      x = q50 * 1.07,                 # push label slightly right (log-scale safe)
      y = adjective,
      label = scales::comma(round(q50))
    ),
    inherit.aes = FALSE,
    size = 3,
    color = "grey30",
    hjust = 0
  )+
  # Global median
  geom_vline(
    xintercept = global_median,
    linetype = "dashed",
    linewidth = 0.8,
    color = "grey30"
  ) +
  
  # Log scale (important for long tail)
  scale_x_log10(
    breaks = c(1000, 2500, 5000, 7500, 10000),
    labels = scales::comma
  ) +
  
  labs(
    title = "NICE AND CLEAN – RELATIVELY LOW RENT?",
    subtitle = "Adjectives in Craigslist rental titles and their relationship to rent",
    x = "Rent in USD",
    y = NULL
  ) +
  
  theme_minimal(base_size = 13) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.y = element_text(face = "bold"),
    axis.ticks = element_blank()
  )





# ================== 3.1rd method ============== patch work


bedrooms <- tibble(
  adjective = c(
    "CLEAN","NICE","SPECIAL","SUNNY","CLOSE","BRIGHT","PRIVATE",
    "SPACIOUS","LOVELY","HUGE","BEAUTIFUL","VICTORIAN","SINGLE",
    "GORGEOUS","FURNISHED"
  ),
  avg_bedrooms = c(1.9, 2.2, 1.7, 1.7, 2.0, 1.8, 1.8,
                   2.0, 2.2, 2.1, 2.3, 2.2, 3.0, 2.3, 1.8)
)


stats <- left_join(stats, bedrooms, by = "adjective")



# Step 2: Draw bedroom labels (left of plot)
geom_text(
  data = stats,
  aes(
    x = min(df$rent) * 0.75,
    y = adjective,
    label = paste0("(", avg_bedrooms, ")")
  ),
  inherit.aes = FALSE,
  size = 3.2,
  color = "grey30"
)



library(cowplot)


legend_plot <- ggplot() +
  
  # Distribution
  geom_density(
    aes(x = df$rent),
    fill = "grey85",
    color = NA
  ) +
  
  # Ranges
  geom_segment(aes(x = 2000, xend = 8000, y = 0, yend = 0),
               linewidth = 6, color = "#ECEBD2") +
  geom_segment(aes(x = 3000, xend = 7000, y = 0, yend = 0),
               linewidth = 6, color = "#C7DDB0") +
  geom_segment(aes(x = 4000, xend = 6000, y = 0, yend = 0),
               linewidth = 6, color = "#9BC17C") +
  
  # Median
  geom_point(aes(x = 5000, y = 0), size = 2.5) +
  
  annotate("text", x = 5000, y = 0.06, label = "Median", size = 3) +
  annotate("text", x = 3000, y = -0.08, label = "50%", size = 3) +
  annotate("text", x = 6000, y = -0.08, label = "80%", size = 3) +
  annotate("text", x = 7800, y = -0.08, label = "95%", size = 3) +
  
  scale_x_log10() +
  theme_void() +
  labs(title = "Legend")




final_plot <- ggdraw(p) +
  draw_plot(
    legend_plot,
    x = 0.62, y = 0.55,
    width = 0.33, height = 0.35
  )

final_plot










