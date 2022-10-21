#R code for ggplot2 based graphs

#use library ggplot2, super powerfull for plots
library(ggplot2)

#inveting some variables to costruct the dataframe
virus <- c(10, 30, 40, 50, 60, 80) # array of values: c
death <- c(100, 240, 310, 470, 580, 690)

#create a dataframe combining the two variables
d <- data.frame(virus, death)  #it creates a tables

#as before, we can use summary also for thta dataframe
summary(d)
ggplot(d, aes(x = virus, y = death)) + geom_point()  # first: data, than specify what I want on the axes = aes: aesthetic of the graph 
                                                     # geom_point = make dots, here we can specify some features like color, size, etc, 
                                                     # it's a function specifying the geometry for the plot, simply adding to ggplot
#more featured plot
ggplot(d, aes(x = virus, y = death)) + geom_point(col = "blue", size = 5)

#lines plot
ggplot(d, aes(x = virus, y = death)) + geom_line() 

#points & lines
ggplot(d, aes(x = virus, y = death)) + geom_point(col = "blue", size = 5, pch = 17) + geom_line() 

#polygons
ggplot(d, aes(x = virus, y = death)) + geom_polygon()

#################################################COVID DATA PLOTS######################################################################
#setting the folder to get the data from that
setwd("~/Scrivania/Magistrale/monitoring_ecosystem/lab/")

#read the table, with the header
covid <- read.table("covid_agg.csv", header=TRUE)  

head(covid) #header = country, cases, lat, lon
summary(covid)

#and now let's do some plot
ggplot(covid, aes(x = lat, y = lon, size = cases)) + geom_point() #size regulates the size of the points according to their values (bigger values bugger dots)
