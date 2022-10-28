#Point pattern analysis for population ecology
library(spatstat)  #spatial statistics
library(rgdal)

#get dta from the correct directory
setwd("~/lab/")
# to check the working directory getwd()

#read the table
covid <- read.table("covid_agg.csv", header=TRUE)
covid #to see the data (table)

#to use the header names as array
attach(covid)

#use spatstat function density to perform a density map = plannar point pattern
#p => assing from simple points to the density of these points (interpolation)
# we shold explain to spatstat the coordinate that we would like to use in planar space, 
# => use the ppp() function: create a point pattern = data + coordinates
covid_planar <- ppp(lon, lat, c(-180,180), c(-90,90))  #cooridnates + ranges for that

#WITHOUT ATTACHING: covid_planar <- ppp(covid$lon, covid$lat, c(-180,180), c(-90,90)) 

#create the density map 
desnity_map <- density(covid_planar)
plot(density_map)
#add points !!LEAVE THE GRAPH WINDOW OPEN
points(covid_planar, pch=19)

#change the density color ma, using colorRampPalette
cl <- colorRampPalette(c("cyan", "coral", "chartreuse"))(100)   #define the color we want into a vector
                                                                #(100) how many level of smoothing we want
plot(density_map, col = cl)
points(covid_planar, pch=19, col="darkblue", cex=.5) 

#if density decrease => population is dying

#change colors
cl1 <- colorRampPalette(c('blue','yellow','orange','red','magenta'))(100)
plot(density_map, col = cl1)
points(covid_planar, pch=19, cex=.5) 

#MODEL THE ABBOUNDANCE of the number of people affected by the virus = abboundance of the virus
#let's add the coast lines
coastlines <- readOGR("ne_10m_coastline.shp")
plot(coastlines, add=T)

###########INTERPOLATION TO FIND THE ABOUNDANCE#################
marks(covid_planar) <- cases                 #marks = points with a label, to select the value we take the variable "cases" into the dataframe
cases_map <- Smooth(covid_planar)           #Smooth function to use to do the interrpolation. The argument is the variable that we would like to interpolate
plot(cases_map)
#we see now that the cloud with the maximum values is moved to the right, around asia => less point but higher values
plot(coastlines, add=T)
points(covid_planar, pch=19, cex=.5, col="green")
