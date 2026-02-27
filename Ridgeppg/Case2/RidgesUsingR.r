

# ====== Basic ridgeline plot =====

# 
# install.packages("ggplot2")
# install.packages("ggridges")
# install.packages("dplyr")

library(ggplot2)
library(ggridges)
library(dplyr)


set.seed(123)

data <- data.frame(
  product = rep(c("Basic", "Standard", "Premium"), each = 500),
  tenure_months = c(
    rnorm(500, mean = 6, sd = 2),
    rnorm(500, mean = 12, sd = 3),
    rnorm(500, mean = 18, sd = 4)
  )
)



# 

# Basic Ridgeline

ggplot(data, aes(x = tenure_months, y = product)) +
  geom_density_ridges()


# Improve Visual Quality (Intermediate)

ggplot(data, aes(x = tenure_months, y = product, fill = product)) +
  geom_density_ridges(alpha = 0.7, color = "white") +
  theme_minimal() +
  labs(
    title = "Customer Tenure Distribution by Plan",
    x = "Tenure (Months)",
    y = "Subscription Plan"
  ) +
  theme(legend.position = "none")


# Control Overlap (scale parameter)

ggplot(data, aes(x = tenure_months, y = product, fill = product)) +
  geom_density_ridges(scale=0.7,alpha = 0.7, color = "white") +
  theme_minimal() +
  labs(
    title = "Customer Tenure Distribution by Plan",
    x = "Tenure (Months)",
    y = "Subscription Plan"
  ) +
  theme(legend.position = "none")


# Add Quantile Lines (Advanced Insight)

ggplot(data, aes(x = tenure_months, y = product, fill = product)) +
  geom_density_ridges(
    quantile_lines = TRUE,
    quantiles = 2,
    alpha = 0.7
  ) +
  theme_minimal()








ggplot(data, aes(x = tenure_months, y = product, fill = stat(x))) +
  geom_density_ridges_gradient(scale = 1.2) +
  scale_fill_viridis_c() +
  theme_minimal()


plot_ridgeline <- function(data, x_var, y_var,fillR,ALPHA,scale, title = "") {
  ggplot(data, aes_string(x = x_var, y = y_var, fill = fillR)) +
    geom_density_ridges(alpha = ALPHA, scale = scale) +
    theme_minimal() +
    labs(title = title) +
    theme(legend.position = "none")
}


plot_ridgeline(data,"tenure_months", "product","product",0.4,1.5, title = "Sample Example")














