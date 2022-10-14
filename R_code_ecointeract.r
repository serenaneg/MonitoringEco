# This is a code for investigating relatioships among ecological variables

#packages
library(sp)  # sp usefull for dealing with spatial data, library: function to load packages; similar to require()

#For data we're using meuse dataset, we'll use the function data() recall the dataset
data(meuse)  

#See the dataset, just typing the name
meuse  #table of data = dataframe  
#x,y, cadmium,copper, lead, zinc, elevation, distance (from a river) om, freq, soil, lime, landuse, dist in meters

#not very easy to see the data in this way, better use function View() (CAPS LOCK!!!)
#[problem with graphics use dev.off(): close a plotting device]

#to view just the head (first 6 lines) of the table, use:
head(meuse)

#to show only the columns names:
names(meuse)

#to calculate datatset statistics, for each column
summary(meuse)

#let's do some PLOT
plot(meuse$cadmium, meuse$zinc) #$ selects obj into the table, column precisely

#easily
cad <- meuse$cadmium
zin <- meuse$zinc

#or we can also use attach() to the table, then we can use directly the name into the dataframe
attach(meuse)
# to reverse: detach()

#to display relationships among all the variables use:
pairs(meuse)  #scatterplot matrices => all the plots of combinations
