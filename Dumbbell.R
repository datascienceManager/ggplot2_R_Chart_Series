
# ====== Dumbble ======= #

# Seed
set.seed(1)

# Data
customers <- sample(50:150, 10)
potential_customers <- sample(150:500, 10)
company <- LETTERS[1:10]

# Data frame
df <- data.frame(company = company,
                 x = customers,
                 y = potential_customers)


# Long data frame
# The melt function from reshape allows converting a wide data frame into long format. 
# This format displays the variables as subgroups of the main groups, so each group will have as many
# rows as variables and the numerical values will all be in the same column instead of splited into different columns.

# install.packages('reshape')

library(reshape)

# Seed
set.seed(1)

# Data
customers <- sample(50:150, 10)
potential_customers <- sample(150:500, 10)
company <- LETTERS[1:10]

# Data frame
df2 <- data.frame(company = company,
                  customers = customers,
                  potential_customers = potential_customers)

# Long, ordered data frame
df2 <- melt(df2, id.vars = "company")
df2 <- df2[order(df2$company), ]



# Depending on your data frame you will need a different approach to create a dumbbell plot in ggplot2.
# 
# Option 1: wide data frame
# 
# If you are working with a wide data frame you can create a dumbbell chart by adding the straight
# lines with geom_segment, specifying the start and end for both axis. Then, you will need to use the 
# geom_point function twice to add the points. Note that you won’t be able to add a legend in a 
# straightforward way using this format.


# install.packages("ggplot2")
library(ggplot2)

ggplot(df) +
  geom_segment(aes(x = customers, xend = potential_customers,
                   y = company, yend = company)) +
  geom_point(aes(x = customers, y = company), size = 3) +
  geom_point(aes(x = potential_customers, y = company), size = 3)


# 
# 
# Option 2: long data frame
# 
# The long data frame format is the most recommended to create this type of visualization. 
# You just need to input the names of the columns that represents values and groups to x and y 
# inside aes and use the geom_line and geom_point functions. If you want to display a legend for 
# the points you just need to input the name of the column representing subgroups to color inside aes. 
# Recall that you can customize the legend position with legend.position.


# install.packages("ggplot2")
library(ggplot2)

ggplot(df2, aes(x = value, y = company)) +
  geom_line() +
  geom_point(aes(color = variable), size = 3) +
  theme(legend.position = "bottom") 


# 
# Customizing the color of the points
# 
# When working with a long data frame you can override the default colors of the points with a scale color 
# function, such as scale_color_manual or scale_color_brewer.


# install.packages("ggplot2")
library(ggplot2)

ggplot(df2, aes(x = value, y = company)) +
  geom_line() +
  geom_point(aes(color = variable), size = 3) +
  scale_color_brewer(palette = "Set1", direction = -1) +
  theme(legend.position = "bottom") 


# 
# 
# Correct Dumbbell Chart Method (Recommended)
# Use geom_segment() instead of geom_line().
# Example Dataset (With Negative Values)

library(ggplot2)
library(dplyr)

df2 <- data.frame(
  company = rep(c("A","B","C"),2),
  variable = rep(c("Before","After"), each = 3),
  value = c(-20, -10, 5,   # Before values
            30, 15, -5)    # After values
)


# Proper Dumbbell Chart With Negative Values


df_wide <- df2 %>%
  tidyr::pivot_wider(names_from = variable,
                     values_from = value)

ggplot(df_wide,
       aes(y = company)) +
  
  geom_segment(
    aes(x = Before,
        xend = After,
        yend = company),
    size = 1.5
  ) +
  
  geom_point(
    aes(x = Before),
    color = "blue",
    size = 4
  ) +
  
  geom_point(
    aes(x = After),
    color = "red",
    size = 4
  ) +
  
  theme_minimal()







ggplot(df_wide,
       aes(y = company)) +
  
  geom_segment(
    aes(x = Before,
        xend = After,
        yend = company),
    size = 2,
    color = "grey60"
  ) +
  
  geom_point(aes(x = Before),
             size = 6,
             color = "black") +
  
  geom_point(aes(x = After),
             size = 6,
             color = "darkred") +
  
  theme_minimal() +
  labs(
    title = "Performance Change Analysis",
    x = "Value Change"
  )








# ========= how to handle Negative Changes ========


library(dplyr)
library(tidyr)
library(ggplot2)

df <- data.frame(
  company = c("A","B","C"),
  before = c(100, 80, 60),
  after = c(120, 60, 90)
)


df <- df %>%
  mutate(
    pct_change = ((after - before) / before) * 100
  )




df_long <- df %>%
  pivot_longer(
    cols = c(before, after),
    names_to = "period",
    values_to = "value"
  )



df_wide <- df %>%
  select(company, before, after)

ggplot(df_wide, aes(y = company)) +
  
  geom_segment(
    aes(x = before,
        xend = after,
        yend = company),
    size = 2,
    color = "grey60"
  ) +
  
  geom_point(aes(x = before),
             size = 5,
             color = "blue") +
  
  geom_point(aes(x = after),
             size = 5,
             color = "red") +
  
  geom_text(
    aes(
      x = after,
      label = paste0(round(((after-before)/before)*100,1), "%")
    ),
    hjust = -0.2,
    size = 4,
    fontface = "bold"
  ) +
  
  theme_minimal() +
  labs(
    title = "Percentage Change Analysis",
    x = "Value"
  )




# --------- Executinve Dashboard Presentation 


ggplot(df_wide, aes(y = company)) +
  
  geom_segment(
    aes(x = before,
        xend = after,
        yend = company),
    size = 2,
    color = "grey60"
  ) +
  
  geom_point(aes(x = before),
             size = 4,
             color = "blue") +
  
  geom_point(aes(x = after),
             size = 4,
             color = "red") +
  
  geom_text(
    aes(
      x = after,
      label = paste0(
        "Change: ",
        round(((after-before)/before)*100,1),
        "%"
      )
    ),
    hjust = 0.2
  )+
  
  theme_minimal() +
  labs(
    title = "Percentage Change Analysis",
    x = "Value"
  )
