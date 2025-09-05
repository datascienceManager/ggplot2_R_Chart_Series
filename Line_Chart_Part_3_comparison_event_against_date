# ================== Line 3 chart 
library(tidyverse)
library(ggplot2)
library(gghighlight)
library(ggtext)
library(showtext)
library(remotes)
# remotes::install_github("nsgrantham/ggbraid")

font_add_google("Source Sans Pro", "source_sans_pro")
font_add_google("Merriweather", "merriweather")
showtext_auto()


ggplot(economics, aes(date, unemploy)) + 
  geom_line()


presidential <- subset(presidential, start > economics$date[1])

ggplot(economics) + 
  geom_rect(
    aes(xmin = start, xmax = end, fill = party), 
    ymin = -Inf, ymax = Inf, alpha = 0.2, 
    data = presidential
  ) + 
  geom_vline(
    aes(xintercept = as.numeric(start)), 
    data = presidential,
    colour = "grey50", alpha = 0.5
  ) + 
  geom_text(
    aes(x = start, y = 2500, label = name), 
    data = presidential, 
    size = 3, vjust = 0, hjust = 0, nudge_x = 50
  ) + 
  geom_line(aes(date, unemploy)) + 
  scale_fill_manual(values = c("blue", "red")) +
  xlab("date") + 
  ylab("unemployment")+
  theme(legend.position = "none")



