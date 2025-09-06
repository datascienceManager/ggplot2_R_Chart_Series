library(highcharter)

#Create data which can be used for Sankey

set.seed(111)

t1 <- sample(x = c("Hosp A", "Hosp B", "Hosp C") , size = 100, replace=TRUE)
t2 <- sample(x = c("Male", "Female")   , size = 100, replace=TRUE)
t3 <- sample(x = c("Survived", "Died") , size = 100, replace=TRUE)

d <- data.frame(cbind(t1,t2,t3))

names(d) <- c('Hospital', 'Gender', 'Outcome')

# First Sankey diagram
hchart(data_to_sankey(d), "sankey", name = "Hospital and Gender based Outcomes")


# Second Sankey diagram

dataForSankey <- d%>%dplyr::select(Hospital, Outcome)
hchart(data_to_sankey(dataForSankey), "sankey", name = "Hospital based Outcomes")


# Third Sankey Diagram

dataForSankey <- d%>%dplyr::select(Gender, Outcome)
hchart(data_to_sankey(dataForSankey), "sankey", name = "Gender based Outcomes")


pl <- hchart(data_to_sankey(d), "sankey", name = "Patient Outcomes")
pl


# ---- With title 

pl%>%
  hc_title(text= "Sankey Diagram") %>%
  hc_subtitle(text= "Hospital and Gender based outcomes")  %>%
  hc_caption(text = "<b>Created by B G Manjunath Prasad <b>")%>%
  hc_add_theme(hc_theme_economist())


## save to html
library(htmlwidgets)
#htmlwidgets::saveWidget(widget = pl, file = "D:\\tmp\\map.html")
## save html to png

#webshot::webshot(url = "D:\\tmp\\map.html",
#                 file = "D:\\tmp\\map.png" )
#png('D:\\tmp\\hc.png', width = 800,height = 400)
#print(pl)
#dev.off()


# ----How to add value labels and percentages to the Sankey

# Create a data frame with data
set.seed(111)

t1 <- sample(x = c("Hosp A", "Hosp B", "Hosp C") , size = 100, replace=TRUE)
t2 <- sample(x = c("Male", "Female")   , size = 100, replace=TRUE)
t3 <- sample(x = c("Survived", "Died") , size = 100, replace=TRUE)

d <- data.frame(cbind(t1,t2,t3))

names(d) <- c('Hospital', 'Gender', 'Outcome')
head(d)



d1 <- d%>%
  dplyr::group_by(Hospital)%>%
  dplyr::tally()%>%
  dplyr::mutate(perc = n/sum(n))%>%
  dplyr::mutate(HospitalNew = paste(Hospital, n, '(', round(perc* 100,1) , '%)'))%>%
  dplyr::select(-n, - perc)
d1


dMain <- merge (d, d1, by  = 'Hospital')


# Get the count of the Gender and create a new column which
# has the Gender as well as the count in it.
d2 <- d%>%
  dplyr::group_by(Gender)%>%
  dplyr::tally()%>%
  dplyr::mutate(perc = n/sum(n))%>%
  dplyr::mutate(GenderNew = paste(Gender, n, '(', round(perc* 100,1) , '%)'))%>%
  dplyr::select(-n, - perc)


dMain <- merge (dMain, d2, by  = 'Gender')

# Get the count of the Outcome  and create a new column which
# has the Outcome  as well as the count in it.

d3 <- d%>%
  dplyr::group_by(Outcome)%>%
  dplyr::tally()%>%
  dplyr::mutate(perc = n/sum(n))%>%
  dplyr::mutate(OutcomeNew = paste(Outcome, n, '(', round(perc* 100,1) , '%)'))%>%
  dplyr::select(-n, - perc)

dMain <- merge (dMain, d3, by  = 'Outcome')

dFinal <- dMain%>%
  dplyr::select(HospitalNew,GenderNew,OutcomeNew  )

dFinal

hchart(data_to_sankey(dFinal), "sankey", name = "Patient Outcomes")%>%
  hc_title(text= "Sankey Diagram with value labels") %>%
  hc_subtitle(text= "Hospital and Gender based outcomes")



# ============== More control on labelling 

hchart(data_to_sankey(dFinal), "sankey", name = "Patient Outcomes")%>%
  hc_title(text= "Sankey Diagram with value labels with size reduced to 5px ") %>%
  hc_subtitle(text= "Hospital and Gender based outcomes")%>%
  hc_plotOptions(series = list(dataLabels = list( style = list(fontSize = "5px"))))%>%
  hc_plotOptions(series = list(dataLabels = list( style = list(fontSize = "12px" , color = "red")
                                                  , backgroundColor = "white"
                                                  , borderRadius = 10
                                                  , borderWidth = 1
                                                  , borderColor = 'orange'
                                                  , padding = 5
                                                  , shadow = FALSE)))

