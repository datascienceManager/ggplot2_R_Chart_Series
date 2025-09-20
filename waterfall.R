library(ggalluvial)
library(waterfalls)

group <- c('OpeningStock','Adds','Churn')
value <- c(2000, 4000,
           -1500)
df <- data.frame(x = group, y = value) 


# 
# df1 = data.frame(x=c('ClosingStock'),y=sum(df$y))
# 
# final_Df = dplyr::bind_rows(df,df1)




# =========== Chart - 1 
waterfall(df)

# Equivalent to:
waterfall(values = value, labels = group)





# ============= Chart - 2 
# Calculate the total

# Setting the argument calc_total to TRUE the final pool will be calculated and a new 
# rectangle will be added to the chart containing the result. You can change the axis name of 
# this rectangle with total_axis_text.


# install.packages("waterfalls")
library(waterfalls)

waterfall(df, calc_total = TRUE)+

  # theme_dark()+
  theme_classic()+
  # theme_light()+
  labs(
    title = "Fuel economy declines as weight increases",
    subtitle = "(2020-23)",
    caption = "Sample generated using data.frame.",
    # tag = "Figure 1",
    y = "Stock (in Tons)",
    x = "Type of Category",
    # colour = "Gears"
  )



#======== Rectangles width

# Note that the rect_width argument controls the width of the rectangles. The default value 
# is 0.7.

waterfall(df, calc_total = TRUE,total_axis_text = "Closing Stock", draw_lines = TRUE, rect_width = 0.4)+
  
  # theme_dark()+
  theme_classic()+
  # theme_light()+
  labs(
    title = "Fuel economy declines as weight increases",
    subtitle = "(2020-23)",
    caption = "Sample generated using data.frame.",
    # tag = "Figure 1",
    y = "Stock (in Tons)",
    x = "Type of Category",
    # colour = "Gears"
  )


# ======= Excluding the horizontal line 

# Note that the rect_width argument controls the width of the rectangles. The default value 
# is 0.7.

waterfall(df, calc_total = TRUE, draw_lines = FALSE, rect_width = 0.4)+
  
  # theme_dark()+
  theme_classic()+
  # theme_light()+
  labs(
    title = "Fuel economy declines as weight increases",
    subtitle = "(2020-23)",
    caption = "Sample generated using data.frame.",
    # tag = "Figure 1",
    y = "Stock (in Tons)",
    x = "Type of Category",
    # colour = "Gears"
  )




waterfall(df, calc_total = TRUE, draw_lines = TRUE, rect_width = 0.4,
          total_axis_text = "Closing Stock") +
  theme_classic() +
  labs(
    title = "Fuel economy declines as weight increases",
    subtitle = "(2020-23)",
    caption = "Sample generated using data.frame.",
    y = "Stock (in Tons)",
    x = "Type of Category"
  )











