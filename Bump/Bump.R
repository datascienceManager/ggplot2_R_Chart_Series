# Bump Chart 


library(dplyr)
library(ggplot2)

df <- data.frame(
  month = rep(c("Jan", "Feb", "Mar", "Apr"), each = 4),
  plan  = rep(c("Cricket", "Football", "Combo", "Premium"), 4),
  revenue = c(50,40,60,30,
              55,45,58,35,
              48,50,65,38,
              60,52,70,42)
)



# ===== Rank Column 

df_rank <- df %>%
  group_by(month) %>%
  mutate(rank = rank(-revenue, ties.method = "first")) %>% # "-" indicates in descending order ranking 
  ungroup()

# === Basic

ggplot(df_rank,
       aes(x = month,
           y = rank,
           group = plan,
           color = plan)) +
  geom_line(size = 1.2) +
  geom_point(size = 3) +
  scale_y_reverse(breaks = 1:4) +
  labs(
    title = "Plan Ranking Movement Over Time",
    y = "Rank (1 = Highest Revenue)"
  ) +
  theme_minimal()


# install.packages("ggbump")
# 
# 
# install.packages("remotes")
# remotes::install_github("davidsjoberg/ggbump")

# install.packages("ggplot")

library(ggbump)
library(ggplot2)

ggplot(df_rank,
       aes(x = month,
           y = rank,
           color = plan)) +
  geom_bump(size = 1.5) +
  geom_point(size = 3) +
  scale_y_reverse(breaks = 1:4) +
  theme_minimal() +
  labs(title = "Smooth Bump Chart")




# ============== 


# Library
#install.packages("ggbump")
library(ggbump)
library(tidyverse)

# Create data
year <- rep(2019:2021, 3)
products_sold <- c(
  500, 600, 700,
  550, 650, 600,
  600, 400, 500
)
store <- c(
  "Store A", "Store A", "Store A",
  "Store B", "Store B", "Store B",
  "Store C", "Store C", "Store C"
)

# Create the new dataframe
df <- data.frame(
  year = year,
  products_sold = products_sold,
  store = store
)




# Simple bump plot
# Thanks to the geom_bump() function, we can easily build a ggbump chart.

ggplot(df, aes(x = year, y = products_sold, color = store)) +
  geom_bump(size = 2) +
  geom_point(size = 6)





ggplot(df, aes(x = year, y = products_sold, color = store)) +
  geom_bump(size = 2) +
  geom_point(size = 6) +
  scale_color_brewer(palette = "Paired") +
  theme_minimal()+
  theme_bw()+
  theme_classic()





ggplot(df, aes(x = year, y = products_sold, color = store)) +
  geom_bump(size = 2) +
  geom_point(size = 6) +
  geom_text(aes(label = store), nudge_y = 20, fontface = "bold", size=3) +
  scale_color_brewer(palette = "Paired") +
  theme_minimal() +
  labs(
    title = "Products sold per store",
    x = "Year",
    y = "Products sold"
  )+
  theme_classic()


# ======= Example : 3

library(dplyr)
library(ggplot2)
library(ggrepel)

df <- data.frame(
  month = rep(c("Jan","Feb","Mar","Apr"), each = 4),
  plan  = rep(c("Cricket","Football","Combo","Premium"), 4),
  revenue = c(50,40,60,30,
              55,45,58,35,
              48,50,65,38,
              60,52,70,42)
)

df_rank <- df %>%
  group_by(month) %>%
  mutate(rank = rank(-revenue)) %>%
  ungroup()

df_rank$month <- factor(df_rank$month,
                        levels = c("Jan","Feb","Mar","Apr"))

ggplot(df_rank,
       aes(x = month,
           y = rank,
           group = plan,
           color = plan)) +
  geom_line(size = 1.5, lineend = "round") +
  geom_point(size = 4) +
  geom_text_repel(
    data = subset(df_rank, month == "Apr"),
    aes(label = plan),
    nudge_x = 0.3,
    direction = "y"
  ) +
  scale_y_reverse(breaks = 1:4) +
  labs(title = "Plan Ranking Movement",
       y = "Rank (1 = Highest)") +
  theme_minimal() +
  theme(legend.position = "none")



# ======== Example : 4 

library(dplyr)
library(ggplot2)
library(ggrepel)

df <- data.frame(
  year = rep(2019:2022, 3),
  
  store = rep(c("Plan A","Plan B","Plan C"), each = 4),
  
  revenue = c(500,600,700,800,
              450,550,500,480,
              650,640,660,700),
  
  churn_rate = c(0.12,0.10,0.09,0.08,
                 0.18,0.20,0.17,0.16,
                 0.07,0.06,0.05,0.04)
)




df_rank <- df %>%
  group_by(year) %>%
  mutate(
    revenue_rank = rank(-revenue),
    churn_rank = rank(churn_rate)
  ) %>%
  ungroup()



df_long <- df_rank %>%
  select(year, store, revenue_rank, churn_rank) %>%
  pivot_longer(
    cols = c(revenue_rank, churn_rank),
    names_to = "metric",
    values_to = "rank"
  )



ggplot(df_long,
       aes(x = year,
           y = rank,
           group = interaction(store, metric),
           color = metric)) +
  
  geom_bump(size = 1.2) +
  geom_point(size = 3) +
  
  scale_y_reverse() +
  
  facet_wrap(~metric, scales = "free_y") +
  
  theme_minimal() +
  
  labs(
    title = "Revenue vs Churn Ranking Movement",
    subtitle = "Enterprise performance tracking"
  )



# 

ggplot(df_long,
       aes(x = year,
           y = rank,
           group = interaction(store, metric),
           color = store)) +
  
  geom_line(size = 1.3) +
  geom_point(size = 3) +
  
  geom_text_repel(
    data = subset(df_long, year == max(year)),
    aes(label = store),
    nudge_x = 0.3
  ) +
  
  scale_y_reverse() +
  theme_minimal() +
  facet_wrap(~metric)
