# load library
library(ggplot2)

# Create test data.
data <- data.frame(
  category=c("A", "B", "C"),
  count=c(10, 60, 30)
)



# Compute percentages
data$fraction = data$count / sum(data$count)

# Compute the cumulative percentages (top of each rectangle)
data$ymax = cumsum(data$fraction)

# Compute the bottom of each rectangle
data$ymin = c(0, head(data$ymax, n=-1))

# Compute label position
data$labelPosition <- (data$ymax + data$ymin) / 2

# Compute a good label
data$label <- paste0(data$category, "\nvalue:", data$count)

# Make the plot
ggplot(data, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=category)) +
  geom_rect() +
  geom_label( x=3.5, aes(y=labelPosition, label=label), size=6) +
  scale_fill_brewer(palette=4) +
  coord_polar(theta="y") +
  xlim(c(2, 4)) +
  theme_void() +
  theme(legend.position = "none") # ---- withoug legend 


# ----- Chart - 2 
# Donut thickness


# Make the plot
ggplot(data, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=category)) +
  geom_rect() +
  geom_text( x=2, aes(y=labelPosition, label=label, color=category), size=6) + # x here controls label position (inner / outer)
  scale_fill_brewer(palette=3) +
  scale_color_brewer(palette=3) +
  coord_polar(theta="y") +
  xlim(c(-1, 4)) +
  theme_void() +
  theme(legend.position = "none")

# ---- Practise - chart - 2
data2 = data %>% 
  dplyr::mutate(.,fraction2 = count/sum(count),
                ymax = cumsum(fraction2),
                ymin=(ymax-fraction2),
                labelPosition=(ymax+ymin)/2,
                label=paste0(category,"\nvalue: ",count))

ggplot(data2,aes(ymax=ymax,ymin=ymin,xmax=4,xmin=3,fill = category))+
  geom_rect()+
  geom_text(x=2,aes(y=labelPosition,label=label,color=category),size=6)+
  scale_fill_brewer(palette=3)+
  scale_color_brewer(palette=3)+
  coord_polar(theta="y")+
  xlim(c(-1, 4)) +
  theme_void()+
  theme(legend.position = "none")



# ========================================================================================
# ========== using package = library(lessR)
#=========================================================================================
# install.packages('lessR')

library(lessR)
# Sample data of the package
data <- rd("Employee")

# Donut chart
PieChart(Dept, data = data,
         main = NULL)


# The function also provides an argument named rows, 
# which allows you to make a subset of your data. 
# In this example we are selecting only females with a salary higher than 45000.


# Donut chart
PieChart(Dept, data = data,hole=0.7,
         rows = (Gender == "W" & Salary > 45000),
         main = NULL)


# Color palette
cols <- hcl.colors(length(unique(data$Dept)), "Zissou 1")

# Donut chart
PieChart(Dept, data = data,hole=0.7,fill=cols,
         rows = (Gender == "W" & Salary > 45000),
         main = NULL)



# Donut chart -- Fill color 
PieChart(Dept, data = data,fill='blues',#--heat,blues,viridis
         main = NULL)
