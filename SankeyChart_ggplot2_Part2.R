library(ggsankey)
library(ggplot2)
library(dplyr)



# install.packages('ggplot2')

# ---- If above is not installed then install below 
# First, install remotes if you haven't already
# install.packages("remotes")

# Then, install the ggsankey package from its GitHub repository

# remotes::install_github("davidsjoberg/ggsankey")


#Create data which can be used for Sankey
set.seed(111)

# Simple

t1 <- sample(x = c("Hosp A", "Hosp B", "Hosp C","Hosp D") , size = 100, replace=TRUE)
t2 <- sample(x = c("Male", "Female")   , size = 100, replace=TRUE)
t3 <- sample(x = c("Survived", "Died") , size = 100, replace=TRUE)

d <- data.frame(cbind(t1,t2,t3))
names(d) <- c('Hospital', 'Gender',  'Outcome')

head(d)


# Transform the data to make it ready for the sankey chart creation

df <- d %>%
  make_long(Hospital, Gender, Outcome)

df

# Create the first sankey chart

# Chart 1

pl <- ggplot(df, aes(x = x
                     , next_x = next_x
                     , node = node
                     , next_node = next_node
                     , fill = factor(node)
                     , label = node)
)
pl <- pl +geom_sankey(flow.alpha = 0.5
                      , node.color = "black"
                      ,show.legend = FALSE)
pl <- pl +geom_sankey_label(size = 3, color = "black", fill= "white", hjust = -0.5)
pl <- pl +  theme_bw()
pl <- pl + theme(legend.position = "none")
pl <- pl +  theme(axis.title = element_blank()
                  , axis.text.y = element_blank()
                  , axis.ticks = element_blank()  
                  , panel.grid = element_blank())
pl <- pl + scale_fill_viridis_d(option = "inferno")
pl <- pl + labs(title = "Sankey diagram using ggplot")
pl <- pl + labs(subtitle = "using  David Sjoberg's ggsankey package")
pl <- pl + labs(caption = "@techanswers88")
pl <- pl + labs(fill = 'Nodes')
pl



# ====== Chart 2 

# How to show the data labels with the values (count) of each node.


#Create data which can be used for Sankey
set.seed(111)

# Simple

t1 <- sample(x = c("Hosp A", "Hosp B", "Hosp C","Hosp D") , size = 100, replace=TRUE)
t2 <- sample(x = c("Male", "Female")   , size = 100, replace=TRUE)
t3 <- sample(x = c("Survived", "Died") , size = 100, replace=TRUE)

d <- data.frame(cbind(t1,t2,t3))
names(d) <- c('Hospital', 'Gender',  'Outcome')


# Step 1
df <- d %>%
  make_long(Hospital, Gender, Outcome)

# Step 2
dagg <- df%>%
  dplyr::group_by(node)%>%
  tally()


# Step 3
df2 <- merge(df, dagg, by.x = 'node', by.y = 'node', all.x = TRUE)

# Chart 2
pl <- ggplot(df2, aes(x = x
                      , next_x = next_x
                      , node = node
                      , next_node = next_node
                      , fill = factor(node)
                      
                      , label = paste0(node,"   n=", n)
)
) 
pl <- pl +geom_sankey(flow.alpha = 0.5,  color = "gray40", show.legend = TRUE)
pl <- pl +geom_sankey_label(size = 3, color = "white", fill= "gray40", hjust = -0.2)

pl <- pl +  theme_bw()
pl <- pl + theme(legend.position = "none")
pl <- pl +  theme(axis.title = element_blank()
                  , axis.text.y = element_blank()
                  , axis.ticks = element_blank()  
                  , panel.grid = element_blank())
pl <- pl + scale_fill_viridis_d(option = "inferno")
pl <- pl + labs(title = "Sankey diagram using ggplot")
pl <- pl + labs(subtitle = "using  David Sjoberg's ggsankey package")
pl <- pl + labs(caption = "@techanswers88")
pl <- pl + labs(fill = 'Nodes')


pl



# ============ Chart - 3 

# -----How to show percentage in the data labels

t1 <- sample(x = c("Hosp A", "Hosp B", "Hosp C","Hosp D") , size = 100, replace=TRUE)
t2 <- sample(x = c("Male", "Female")   , size = 100, replace=TRUE)
t3 <- sample(x = c("Survived", "Died") , size = 100, replace=TRUE)

d <- data.frame(cbind(t1,t2,t3))
names(d) <- c('Hospital', 'Gender',  'Outcome')

TotalCount = nrow(d)
# Step 1
df <- d %>%
  make_long(Hospital, Gender, Outcome)

# Step 2
dagg <- df%>%
  dplyr::group_by(node)%>%
  tally()

dagg <- dagg%>%
  dplyr::group_by(node)%>%
  dplyr::mutate(pct = n/TotalCount)


# Step 3
df2 <- merge(df, dagg, by.x = 'node', by.y = 'node', all.x = TRUE)

pl <- ggplot(df2, aes(x = x
                      , next_x = next_x
                      , node = node
                      , next_node = next_node
                      , fill = factor(node)
                      
                      , label = paste0(node," n=", n, '(',  round(pct* 100,1), '%)' ))
)

pl <- pl +geom_sankey(flow.alpha = 0.5,  color = "gray40", show.legend = TRUE)
pl <- pl +geom_sankey_label(size = 2, color = "black", fill= "white", hjust = -0.1)

pl <- pl +  theme_bw()
pl <- pl + theme(legend.position = "none")
pl <- pl +  theme(axis.title = element_blank()
                  , axis.text.y = element_blank()
                  , axis.ticks = element_blank()  
                  , panel.grid = element_blank())
pl <- pl + scale_fill_viridis_d(option = "inferno")
pl <- pl + labs(title = "Sankey diagram using ggplot")
pl <- pl + labs(subtitle = "Created by B G Manjunath Prasad")
pl <- pl + labs(caption = "datascientist_@outlook.com")
pl <- pl + labs(fill = 'Nodes')
pl <- pl + scale_fill_viridis_d(option = "inferno")
pl


# ---------- Chart 3.1

# ======== How to control the colours of each node manually
# You can create a colour for each node manually using the scale_fill_manual 
# If you do not provide a colour 
# for a node then it will be shown by default in grey colour.



pl <- pl + scale_fill_manual(values = c('Died'    = "black"
                                        ,'Female'  ="red"
                                        ,'Hosp A'  = "green"
                                        ,'Hosp B'  = "blue"
                                        ,'Hosp C'  = "orange"
                                        ,'Hosp D'  = "yellow"
                                        
                                        ,'Survived'=  "green"
) )

pl


# -------------- Chart 3.2

# How to highlight a node manually
# Sometimes you would want to highlight a particular node. 
# In this case we have provide the colour in scale_fill_manual for 
# only those nodes which we want to highlight, all remaining nodes appear 
# in grey colour by default.

pl <- pl + scale_fill_manual(values = c('Died'    = "red"
                                        ,'Female'  ="red"
                                        ,'Hosp A'  = "red"
                                        
) )

pl



# ===== Chart 3.3

# Node and Node Connection colours can also be controlled independently

t1 <- sample(x = c("Hosp A", "Hosp B", "Hosp C","Hosp D") , size = 100, replace=TRUE)
t2 <- sample(x = c("Male", "Female")   , size = 100, replace=TRUE)
t3 <- sample(x = c("Survived", "Died") , size = 100, replace=TRUE)

d <- data.frame(cbind(t1,t2,t3))
names(d) <- c('Hospital', 'Gender',  'Outcome')

TotalCount = nrow(d)
# Step 1
df <- d %>%
  make_long(Hospital, Gender, Outcome)

# Step 2
dagg <- df%>%
  dplyr::group_by(node)%>%
  tally()

dagg <- dagg%>%
  dplyr::group_by(node)%>%
  dplyr::mutate(pct = n/TotalCount)


# Step 3
df2 <- merge(df, dagg, by.x = 'node', by.y = 'node', all.x = TRUE)

pl <- ggplot(df2, aes(x = x
                      , next_x = next_x
                      , node = node
                      , next_node = next_node
                      , fill = factor(node)
                      
                      , label = paste0(node," n=", n, '(',  round(pct* 100,1), '%)' ))
)

pl <- pl +geom_sankey(flow.alpha = 0.5, node.color = "blue",show.legend = TRUE, node.fill = "lightblue")
pl <- pl +geom_sankey_label(size = 2, color = "black", fill= "white", hjust = -0.1)

pl <- pl +  theme_bw()
pl <- pl + theme(legend.position = "none")
pl <- pl +  theme(axis.title = element_blank()
                  , axis.text.y = element_blank()
                  , axis.ticks = element_blank()  
                  , panel.grid = element_blank())

pl <- pl + labs(title = "Sankey diagram using ggplot")
pl <- pl + labs(subtitle = "Created by BG Manjunath Prasad ")
pl <- pl + labs(caption = "datascientist_@outlook.com")




pl


# ============= Chart - Last part 

# ========== Complicated 

# Sankey with bit more complicated data
# See how it performs when our data is bit more complicated. Now we have 26 
# different hospitals. We also have the age of the patients and we would create different 
# age-groups for the patients. We also have a discarge facility to where the patients will 
# go after they get discharged from their hospital. 
# In this example we will use the geom_sankey_text to create our label instead of the 
# geom_sankey_label option.


t1 <- sample(paste("Hosp", letters), size = 100, replace=TRUE)
t2 <- sample(x = c("Male", "Female")   , size = 100, replace=TRUE)
t3 <- floor(runif(100, min = 0, max = 110))
t4 <- sample(x = c("Survived", "Died") , size = 100, replace=TRUE)
t5  <- sample(paste("Facility ", letters), size = 100, replace=TRUE)

d <- data.frame(cbind(t1,t2,t3,t4, t5))
names(d) <- c('Hospital', 'Gender', 'AgeYears', 'Outcome', 'Dischargeto')

d$AgeYears <- as.integer(d$AgeYears)
d$AgeGroup <- cut(d$AgeYears, 
                  breaks = c(-Inf
                             ,5 ,10 ,15,20,25,30,35,40,45,50,55,60 ,65,70,75,80,85
                             , Inf), 
                  
                  labels = c("0-4 years"
                             ,"5-9 years","10-14 years","15-19 years","20-24 years"
                             ,"25-29 years","30-34 years","35-39 years","40-44 years"
                             ,"45-49 years","50-54 years","55-59 years","60-64 years"
                             ,"65-69 years","70-74 years","75-79 years","80-84 years"
                             ,"85+ years"),
                  right = FALSE)




# Step 1
df <- d %>%
  make_long(Hospital, Gender,AgeGroup, Outcome,Dischargeto)

# Step 2
dagg <- df%>%
  dplyr::group_by(node)%>%
  tally()


# Step 3
df2 <- merge(df, dagg, by.x = 'node', by.y = 'node', all.x = TRUE)


# Chart
pl <- ggplot(df2, aes(x = x
                      , next_x = next_x
                      , node = node
                      , next_node = next_node
                      , fill = factor(node)
                      , label = paste0(node," n=", n)
)
) 
pl <- pl +geom_sankey(flow.alpha = 0.5, node.color = "black",show.legend = TRUE)
# pl <- pl +geom_sankey_text(size = 2, color = "blue", hjust = -0.5)
pl <- pl +geom_sankey_label(size = 2, color = "black", fill= "white", hjust = -0.1)
pl <- pl +  theme_bw()
pl <- pl + theme_sankey(base_size = 16) 
pl <- pl + theme(legend.position = "none")
pl <- pl + labs(title = "Sankey diagram using ggplot")
pl <- pl + labs(subtitle = "Created by B G Manjunath Prasad")
pl <- pl + labs(caption = "datascientist_@outlook.com")
pl <- pl + labs(fill = 'Nodes')

pl <- pl +  theme(axis.title = element_blank()
                  , axis.text.y = element_blank()
                  , axis.ticks = element_blank()  
                  , panel.grid = element_blank())

pl <- pl + scale_fill_viridis_d(option = "inferno")
pl






