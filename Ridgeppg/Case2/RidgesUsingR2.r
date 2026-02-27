

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



# ====== scale to bring the plot closer and filling with scale_fill_viridis_c =======

ggplot(data, aes(x = tenure_months, y = product, fill = stat(x))) +
  geom_density_ridges_gradient(scale = 1.2) +
  scale_fill_viridis_c() +
  theme_minimal()



# === Function =======
plot_ridgeline <- function(data, x_var, y_var,fillR,ALPHA,scale, title = "") {
  ggplot(data, aes_string(x = x_var, y = y_var, fill = fillR)) +
    geom_density_ridges(alpha = ALPHA, scale = scale) +
    theme_minimal() +
    labs(title = title) +
    theme(legend.position = "none")+
    theme_classic()
}


plot_ridgeline(data,"tenure_months", "product","product",0.4,0.9, title = "Sample Example")




# Density ridgeline plots
# 
# The geom geom_density_ridges calculates density estimates from the provided data and then plots those, using the ridgeline visualization. The height aesthetic does not need to be specified in this case.

ggplot(iris, aes(x = Sepal.Length, y = Species)) + geom_density_ridges()




# There is also geom_density_ridges2, which is identical to geom_density_ridges except it uses closed polygons instead of ridgelines for drawing.

ggplot(iris, aes(x = Sepal.Length, y = Species)) + geom_density_ridges2()



# The scaling is calculated separately per panel, so if we facet-wrap by species each density curve exactly touches the next higher baseline. (This can be disabled by setting panel_scaling = FALSE.)

ggplot(iris, aes(x = Sepal.Length, y = Species)) + 
  geom_density_ridges(scale = 1) + facet_wrap(~Species)






# And here is an example using geom_density_ridges_gradient. Note that we need to map the 
# calculated x value (stat(x)) onto the fill aesthetic, not the original temperature variable. 
# This is the case because geom_density_ridges_gradient calls stat_density_ridges (described in the next section) 
# which calculates new x values as part of its density calculation.

ggplot(lincoln_weather, aes(x = `Mean Temperature [F]`, y = Month, fill = stat(x))) +
  geom_density_ridges_gradient(scale = 3, rel_min_height = 0.01) +
  scale_fill_viridis_c(name = "Temp. [F]", option = "C") +
  labs(title = 'Temperatures in Lincoln NE in 2016')

