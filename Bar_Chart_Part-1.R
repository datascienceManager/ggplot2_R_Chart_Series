

library(tidyverse)
library(ggplot2)
library(dplyr)
df = data.frame(group11=rep(x=LETTERS[1:3],times=c(5,3,7)))


# ========= Basic Bar chart =========

ggplot(df,mapping=aes(x=group11))+geom_bar()

df %>% group_by(.,group11)%>%summarise(.,CNT = n())

# -------- 

species = rep(x=c("san","pao","banan","triticum"),each=3)

cond = rep(x=c("normal","strees","Nitrogen"),time=4)

value=abs(rnorm(n=12,mean=0,sd=15))

yearP = c(rep(2020,4),rep(2021,4),rep(2023,4))


data = data.frame(species,cond,value,yearP)

# ---------- bar chart grouped ------

data %>% ggplot(.,aes(x=species,y=value,fill=cond))+
  geom_bar(stat="identity",position="dodge")


# ------ Stack bar chart ------

data %>% ggplot(.,aes(x=species,y=value,fill=cond))+
  geom_bar(stat="identity",position="stack")



# ------ Percentage Stack bar chart ------

library(scales)


data %>% ggplot(.,aes(x=species,y=value,fill=cond))+
  geom_bar(stat="identity",position="fill",alpha=0.7)+
  scale_y_continuous(labels = percent)+
  facet_wrap(~yearP)+ 
  coord_flip()+
  theme_bw()+
  labs(title="Stack Bar Chart")+
  theme_classic()+
  # theme_dark()+
  # theme_light()+
  labs(
    title = "Fuel economy declines as weight increases",
    subtitle = "(2020-23)",
    caption = "Data from the 2020 Motor Trend US magazine.",
    tag = "Figure 1",
    x = "Weight (1000 lbs)",
    y = "Fuel economy (mpg)",
    colour = "Gears"
  )







