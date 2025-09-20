

# Data 
set.seed(6)
df <- data.frame(group = LETTERS[1:20],
                 value = rnorm(20))


# install.packages("ggplot2")
library(ggplot2)

# ---Default diverging bar chart in ggplot2

ggplot(df, aes(x = group, y = value)) +
  geom_bar(stat = "identity",
           show.legend = FALSE) + # Remove the legend
  xlab("Group") +
  ylab("Value") 


# ---Reorder the values

# Note that for better visualization it is recommended to reorder the bars based on the 
# value they represent. For that purpose you can use the reorder function as shown below.

ggplot(df, aes(x = reorder(group,value), y = value)) +
  geom_bar(stat = "identity",
           show.legend = FALSE) + # Remove the legend
  xlab("Group") +
  ylab("Value") +
  coord_flip()



# Adding text for each bar (vertical text)
ggplot(df, aes(x = reorder(group, value), y = value)) +
  geom_bar(stat = "identity",
           show.legend = FALSE) +
  geom_text(aes(label = round(value, 1),
                angle = 90,
                hjust = ifelse(value < 0, 1.25, -0.25),
                vjust = 0.5),
            size = 3) +
  xlab("Group") +
  ylab("Value") + 
  scale_y_continuous(limits = c(min(df$value) - 0.2,
                                max(df$value) + 0.2))+
  theme_bw()+
theme_classic()+
  theme_alluvial()


# ========================== Withou flipping keeping the basic bar chart 

library(ggplot2)


ggplot(df, aes(x = reorder(group, value), y = value)) +
  geom_bar(stat = "identity",fill=4,
           show.legend = FALSE) +
  geom_text(aes(label = round(value, 1),
                hjust =   0.5,
            vjust = ifelse(value < 0, 1.5, -1)), 
            size = 2.5) +
  xlab("Group") +
  ylab("Value") +
  scale_y_continuous(limits = c(min(df$value) - 0.2,
                                max(df$value) + 0.2)) +
  theme_bw()+
  theme_classic()+
  theme_alluvial()+
  theme(axis.text.x = element_text(angle = 90,#---- x axis i.e. group value rotate to 90 degree
                                   hjust = 1,
                                   vjust = 0.5))


# ============================ After flipping to adjust the value on the bar 

# install.packages("ggplot2")
library(ggplot2)

ggplot(df, aes(x = reorder(group, value), y = value)) +
  geom_bar(stat = "identity",fill=4,
           show.legend = FALSE) +
  geom_text(aes(label = round(value, 1),
                hjust =   ifelse(value < 0, 1.5, -1)),
                vjust = 0.5, 
            size = 2.5) +
  xlab("Group") +
  ylab("Value") +
  scale_y_continuous(limits = c(min(df$value) - 0.2,
                                max(df$value) + 0.2)) +
  coord_flip()+
  theme_bw()+
  theme_classic()+
  theme_alluvial()+
  theme(axis.text.x = element_text(angle = 90,#---- x axis i.e. group value rotate to 90 degree
                                   hjust = 1,
                                   vjust = 0.5))


# 

# ============================  Color based on value

# install.packages("ggplot2")
library(ggplot2)


# Color based on value
color <- ifelse(df$value < 0, "pink", "lightblue")


ggplot(df, aes(x = reorder(group, value), y = value)) +
  geom_bar(stat = "identity",fill= color,
           show.legend = FALSE) +
  geom_text(aes(label = round(value, 1),
                hjust =   ifelse(value < 0, 1.5, -1)),
            vjust = 0.5, 
            size = 2.5) +
  xlab("Group") +
  ylab("Value") +
  scale_y_continuous(limits = c(min(df$value) - 0.2,
                                max(df$value) + 0.2)) +
  coord_flip()+
  theme_bw()+
  theme_classic()+
  theme_alluvial()+
  theme(axis.text.x = element_text(angle = 90,#---- x axis i.e. group value rotate to 90 degree
                                   hjust = 1,
                                   vjust = 0.5))

# ============================  Color based on value is name of the bar or catagory name 

# install.packages("ggplot2")
library(ggplot2)


# Color based on value
color <- ifelse(df$value < 0, "pink", "lightblue")


ggplot(df, aes(x = reorder(group, value), y = value)) +
  geom_bar(stat = "identity",fill= color,
           show.legend = FALSE) +
  geom_text(aes(label = group, # Text with groups
                hjust = ifelse(value < 0, 1.5, -1),
                vjust = 0.5), size = 2.5) +

  xlab("Group") +
  ylab("Value") +
  scale_y_continuous(limits = c(min(df$value) - 0.2,
                                max(df$value) + 0.2)) +
  coord_flip()+
  theme_bw()+
  theme_classic()+
  theme_alluvial()+
  theme(axis.text.x = element_text(angle = 90,#---- x axis i.e. group value rotate to 90 degree
                                   hjust = 1,
                                   vjust = 0.5))




# ============================  Color based on value is name of the bar or catagory name 
# =============== adding title and sub titles 

# install.packages("ggplot2")
library(ggplot2)


# Color based on value
color <- ifelse(df$value < 0, "pink", "lightblue")


ggplot(df, aes(x = reorder(group, value), y = value)) +
  geom_bar(stat = "identity",fill= color,
           show.legend = FALSE) +
  geom_text(aes(label = group, # Text with groups
                hjust = ifelse(value < 0, 1.5, -1),
                vjust = 0.5), size = 2.5) +

  xlab("Group") +
  ylab("Value") +
  scale_y_continuous(limits = c(min(df$value) - 0.2,
                                max(df$value) + 0.2)) +
  coord_flip()+
  theme_bw()+
  theme_classic()+
  theme_alluvial()+
  theme(axis.text.x = element_text(angle = 90,#---- x axis i.e. group value rotate to 90 degree
                                   hjust = 1,
                                   vjust = 0.5))+
  labs(
    title = "Bar or Tornoardo Chart",
    subtitle = "(2020-23)",
    caption = "datascientist_@outlook.com",
    # tag = "Figure 1",
    x = "Group",
    y = "Value"
  )
