

library(ggplot2)
library(dplyr)


# --------- Get more details about geom_bar()
?geom_bar()


head(ggplot2::mpg)

p = ggplot(data=mpg,aes(x=manufacturer))
p = p +geom_bar(stat="count")
p

# -------- Fill 

p = ggplot(data=mpg,aes(x=manufacturer,fill=class))
p = p +geom_bar(stat="count")
p


# -------- Position

p = ggplot(data=mpg,aes(x=manufacturer,fill=class))
p = p +geom_bar(stat="count",position = "fill")
p

# -------- Percentage of Y axis 

library(scales)
library(ggthemes)

p = ggplot(data=mpg,aes(x=manufacturer,fill=class))
p = p +geom_bar(stat="count",position = "fill")
p = p + scale_y_continuous(labels = scales::percent)+
    ggthemes::theme_economist_white()+
  labs(title = "Barchart", subtitle = "Percentage Y axis, Position is FILL",
       x= "Manufacture",y=" Percentage")+
  theme(axis.text.x = element_text(angle=90,hjust = 0))+
  coord_flip()
p




# --------- Using tally to find the percentage 

dt = mpg %>% 
  group_by(.,manufacturer,class)%>%
  dplyr::tally()%>%
  dplyr::mutate(.,Percentage = n/sum(n))

# ----------- Position Stack -----


p = ggplot(data=dt,aes(x=manufacturer,y=n,fill=class))+
  geom_bar(stat="identity")+
  # ----- using label and position_stack to display the percentage on graph
  geom_text(aes(label = paste0(sprintf("%1.1f",Percentage*100),"%")),
            position=position_stack(vjust = 0.5),colour="white")+
  labs(title = "Barchart", 
       subtitle = "Position_Stack",
       x= "Manufacture",y=" TotalNumber")+
  theme_bw()+
  coord_flip()+
  theme_classic()


p

# --------------- Position_fill


p = ggplot(data=dt,aes(x=manufacturer,y=n,fill=class))+
    geom_bar(stat="identity",position = "fill")+
# ----- using label and position_stack to display the percentage on graph
   geom_text(aes(label = paste0(sprintf("%1.1f",Percentage*100),"%")),
                  position=position_fill(vjust = 0.5),colour="white")+
  labs(title = "Barchart", 
       subtitle = "Position Fill ",
       x= "Manufacture",y=" Percentage")+
  coord_flip()
  
  
p


#----- Above code was created following the instruction from youtube link below , all the credit goes to them 
# https://www.youtube.com/watch?v=RPwJ6ExwPbg


