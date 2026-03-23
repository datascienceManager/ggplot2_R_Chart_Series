

# =============== Bar Chart - Column Chart with Arrange baesd on columns 


data_mtcars = mtcars

data_mtcars$model = rownames(mtcars)


# ------- Simple barchart 
p = data_mtcars %>% 
    ggplot(.,aes(mpg,model))+
    geom_col()

p    

# -------- Arranging the Factor Variable 

library(dplyr)

# ------ Descending 
data_mtcars %>% 
  dplyr::arrange(mpg) %>%
   # ----- So we are arranging the based on the character vector 
  dplyr::mutate(model = factor(model,levels = model))%>%
  ggplot(.,aes(x=mpg,y=model))+
  geom_col()

# ------ Ascending  
data_mtcars %>% 
  # dplyr::arrange(-mpg) %>%
  dplyr::arrange(desc(mpg))%>%
  # ----- So we are arranging the based on the character vector 
  dplyr::mutate(model = factor(model,levels = model))%>%
  ggplot(.,aes(x=mpg,y=model))+
  geom_col()
  



# ========= Multiple Variable Factor =======

# ----- Desceding 
data_mtcars %>% 
  dplyr::arrange(am,mpg)%>%
  
  # ----- So we are arranging the based on the character vector 
  dplyr::mutate(model = factor(model,levels = model))%>%
  
#   ----- Fill based on Factor like "am"
  ggplot(.,aes(x=mpg,y=model,fill=factor(am)))+
  geom_col()

# ----- Desceding based
data_mtcars %>% 
  dplyr::arrange(desc(am),mpg)%>%
  
  # ----- So we are arranging the based on the character vector 
  dplyr::mutate(model = factor(model,levels = model))%>%
  
  #   ----- Fill based on Factor like "am"
  ggplot(.,aes(x=mpg,y=model,fill=factor(am)))+
  geom_col(alpha=0.5)+

# ==== Label for "fill" to rename as below 
 labs(fill="Automatic\n manual\n ngear shift")+
  theme_classic()



# ===================================================================
# ============ Different Bar Chart for the Category Variable =====
# ===================================================================


library(tidyverse)


# -------- Using Gather to get the Long dataset 
data_mtcars_long = tidyr::gather(data_mtcars,key="Category_var",value="Values",-model)



#------ Pivot Long to get same impact 


data_mtcars_long2 = pivot_longer(data_mtcars,names_to = "category", values_to = "value",cols=!model)


# ------- Now working on the dataset

data_mtcars_long %>% 
  filter(.,Category_var %in% c("mpg","wt","hp","disp"))%>%
  group_by(.,Category_var)%>%
  dplyr::top_n(10)%>%
  ungroup()%>%
  mutate(.,Category_var = as.factor(Category_var))%>%
  ggplot(.,aes(model,Values,fill = Category_var))+
  geom_col(show.legend = FALSE)+
  facet_wrap(~Category_var,scales="free")+
  coord_flip()+
  theme_classic()+
  scale_y_continuous(expand = c(0,0))+
  labs(y = NULL,x = NULL , title = " TOP 10 Model Based on Features ", subtitle = "CarDataset")


#============ Reorder Within Function =======



library(tidytext)

data_mtcars_long %>% 
  filter(.,Category_var %in% c("mpg","wt","hp","disp"))%>%
  group_by(.,Category_var)%>%
  dplyr::top_n(10)%>%
  ungroup()%>%
  
#------ This helps in arraning the factor variable
  
  mutate(.,Category_var = as.factor(Category_var),
         model= reorder_within(x=model,by=Values, within=Category_var))%>%
  
  ggplot(.,aes(model,Values,fill = Category_var))+
  geom_col(show.legend = FALSE)+
  facet_wrap(~Category_var,scales="free")+
  coord_flip()+
  
#------ this removes the unwanted names in Model in X axis
  scale_x_reordered()+
  theme_classic()+
  scale_y_continuous(expand = c(0,0))+
  labs(y = NULL,x = NULL , title = " TOP 10 Model Based on Features using 'reorder_within' ", subtitle = "CarDataset")


#=================== Adding the values at the end of the bar using "geom_label" ===

# ------- Now working on the dataset

library(tidytext)

data_mtcars_long %>% 
  filter(.,Category_var %in% c("mpg","wt","hp","disp"))%>%
  group_by(.,Category_var)%>%
  dplyr::top_n(10)%>%
  ungroup()%>%
  
#------ This helps in arraning the factor variable
  
  mutate(.,Category_var = as.factor(Category_var),
         model= reorder_within(x=model,by=Values, within=Category_var))%>%
  
  ggplot(.,aes(model,Values,fill = Category_var))+
  geom_col(show.legend = FALSE,alpha=0.5)+
  geom_label(aes(model,Values,label = Values),hjust=1.25,alpha=0.5)+
  facet_wrap(~Category_var,scales="free")+
  coord_flip()+
  
#------ this removes the unwanted names in Model in X axis
  scale_x_reordered()+
  theme_classic()+
  scale_y_continuous(expand = c(0,0))+
  labs(y = NULL,x = NULL , title = " TOP 10 Model Based on Features using 'reorder_within' ", subtitle = "CarDataset")








