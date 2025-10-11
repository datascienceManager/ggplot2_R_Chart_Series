library(ggplot2)
library(data.table)
library(dplyr)

ls("package:ggplot2")

grep(pattern="^geom",x=ls("package:ggplot2"),value='TRUE')



# ---------- geom point -------

# ----- a --------

theme_set(new=theme_light())

ggplot(data=iris,
       mapping=aes(x=Petal.Width,y=Petal.Length)
       )+
  geom_point()

# ----- b --------

iris %>% 
  ggplot(aes(x=Petal.Width,y=Petal.Length,
           colour = Species  )
         )+
  geom_point()

#------- c -----

iris %>% 
  ggplot(aes(x=Petal.Width,y=Petal.Length,
             colour = Species  )
  )+
  geom_point(size=3,alpha=0.4)


# ======== geom_jitter

iris %>% 
  ggplot(aes(x=Petal.Width,y=Petal.Length,
             colour = Species  )
  )+
  geom_jitter(size=3,alpha=0.4)


# ===== Categorical Variable on X axis ======



iris %>%
  ggplot(aes(x=Species, y =Petal.Length,colour = Species))+
  geom_point()

# ======== Box plot for categorica variable ======

# ---- adding geom point on top of geom boxplot
iris %>%
  ggplot(aes(x=Species,y=Petal.Length,colour = Species))+
  geom_boxplot()+
  geom_point()

# ----- adding geom jitter on top of geom boxplot

# ---- place or arrangement of boxplot over jitter or jitter over box plot
# ***** boxplot and later jitter *******
iris %>%
  ggplot(aes(x=Species,y=Petal.Length,colour = Species))+
  geom_boxplot()+
  geom_jitter()
  

# ***** jitter and later boxplot *******

iris %>%
  ggplot(aes(x=Species,y=Petal.Length,colour = Species))+
  geom_jitter()+
  geom_boxplot(size=.5,alpha=.5,outlier.shape = NA)

# ----- violin 

iris %>%
  ggplot(aes(x=Species,y=Petal.Length,colour = Species,fill = Species))+
  geom_violin(alpha=0.5)+
  geom_jitter(size=3,alpha=0.6)


#============== Having Two chart in one using patchwork=========

library(patchwork)

p1 = iris %>%
  ggplot(aes(x=Species,y=Petal.Length,colour = Species))+
  geom_jitter()+
  geom_boxplot(size=.5,alpha=.5,outlier.shape = NA)+
  theme_bw()+
  theme_classic()

p2 =iris %>%
  ggplot(aes(x=Species,y=Petal.Length,colour = Species,fill = Species))+
  geom_violin(alpha=0.5)+
  geom_jitter(size=3,alpha=0.6)+
  theme_bw()+
  theme_classic()

p1/p2


# ========== dotplot ======

p3= iris %>% 
  ggplot(aes(x=Species,y=Petal.Length,fill=Species))+
  geom_dotplot(binaxis = "y",stackdir = "center",dotsize=0.5)


(p1+p2)/p3

# ========== geom col ======

mpg %>%
  count(class)%>%
  ggplot(aes(x=class,y=n,fill=class))+
  geom_col()


# ======== histogram =======

diamonds %>%
  ggplot(aes(x=price))+
  geom_histogram(bins=50)


#************ using color and fill to show the separate bar 
diamonds %>%
  ggplot(aes(x=price))+
  geom_histogram(bins=50,color='black',fill='grey')

# **********show the different catagory within bar 

diamonds %>%
  ggplot(aes(x=price,fill=cut))+
  geom_histogram(bins=50,color='black')+
  xlim(c(0,8000))

# ********** showing side by side of the cut catagory by using dodge

diamonds %>%
  ggplot(aes(x=price,fill=cut))+
  geom_histogram(bins=50,color='black',position = 'dodge')+
  xlim(c(0,8000))

# ********** creating separate graph for cut using 'facet_wrap'

diamonds %>%
  ggplot(aes(x=price,fill=cut))+
  geom_histogram(bins=50,color='black',position = 'dodge')+
  xlim(c(0,8000))+
  facet_wrap(~cut,nrow=5)

# ********** in the above scale is same for all , inorder to keep y axis scale based on the individual
# value then need to use 'free_y'

diamonds %>%
  ggplot(aes(x=price,fill=cut))+
  geom_histogram(bins=50,color='black',position = 'dodge')+
  xlim(c(0,8000))+
  facet_wrap(~cut,nrow=5,scale='free_y')+
  theme_linedraw()+
  # theme_bw()+
  theme_classic()


# ******** combing two different chart type and 
p1 = iris %>% ggplot(aes(x=Petal.Length,fill=Species))+
  geom_histogram(alpha=0.5,position = 'dodge')+
  facet_wrap(~Species,scale='free_y')

p2 = iris %>% ggplot(aes(x=Sepal.Width,fill=Species))+
  geom_histogram(alpha=0.5,position = 'dodge')+
  facet_wrap(~Species,scale='free_y')

p1/p2

# ============ geom_freqpoly()
diamonds %>%
  ggplot(aes(x=price,fill=cut))+
  geom_histogram(bins=50,color='black',position = 'dodge')+
  xlim(c(0,8000))+
  facet_wrap(~cut,nrow=5,scale='free_y')+
  theme_linedraw()+
  # theme_bw()+
  theme_classic()


# ============ geom_freqpoly

diamonds %>%
  ggplot(aes(x=price,colour = cut))+
  geom_freqpoly(binwidth=200,size=1.5)+
  xlim(c(0,8000))


# ============ geom_density

diamonds %>%
  ggplot(aes(x=price,colour = cut))+
  geom_density(size=1.5)+
  xlim(c(0,8000))

# ********** geom_density for catagory **********


p1 = iris %>% ggplot(aes(x=Petal.Length,fill=Species))+
  geom_density(alpha=0.5)

p2 = iris %>% ggplot(aes(x=Sepal.Width,fill=Species))+
  geom_density(alpha=0.5)

p1/p2



# ============== geom_text and geom_label========

mtcars$model = row.names(mtcars)


mtcars %>% 
  ggplot(aes(wt,mpg,colour = as.factor(cyl),label=model))+
  geom_point()+
  geom_text()


# *********** vertical and horizontal adjustment of the label value 
mtcars %>% 
  ggplot(aes(wt,mpg,colour = as.factor(cyl),label=model))+
  geom_point()+
  geom_text(hjust=-0.1,vjust=0.1)


# *********** using geom_label to have label value or text inside the box 
mtcars %>% 
  ggplot(aes(wt,mpg,colour = as.factor(cyl),label=model))+
  geom_point()+
  # geom_text(hjust=-0.1,vjust=0.1)+
  geom_label()


# ********** having additional library 'ggrepel'

library(ggrepel)

mtcars %>% 
  ggplot(aes(wt,mpg,colour = as.factor(cyl),label=model))+
  geom_point()+
  ggrepel::geom_label_repel()


# ********* size to have label for all the points 

mtcars %>% 
  ggplot(aes(wt,mpg,colour = as.factor(cyl),label=model))+
  geom_point()+
  ggrepel::geom_label_repel(size=3)

# ********* different graph based on the cycl factor variable 

mtcars %>% 
  ggplot(aes(wt,mpg,colour = as.factor(cyl),label=model))+
  geom_point()+
  ggrepel::geom_label_repel(size=3)+
  facet_wrap(~as.factor(cyl),scale='free_y')





