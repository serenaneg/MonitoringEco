#R code for SPATIAL DISTRIBUTION MODELLING THOROUGH SDM LIBRARY

library(sdm)
library(rgdal)
library(raster)

#use system.file function to catch the file directly from smd packages

file <- system.file("external/species.shp", package = "sdm")  #.shp = shapefile
                                                              #looking insede the system R file external
species <- shapefile(file)  #put the file outside, into R
species
#class       : SpatialPointsDataFrame 
#features    : 200 
#extent      : 110112, 606053, 4013700, 4275600  (xmin, xmax, ymin, ymax)
#crs         : +proj=utm +zone=30 +datum=WGS84 +units=m +no_defs 
#variables   : 1
#names       : Occurrence 
#min values  :          0 
#max values  :          1 

#see only the Occurence column oh the dataset
species$Occurrence
plot(species)   #area = Spain, we see all the indivisuals that with have in the area

#plot only the subset of the occurrence true
#create the subset: specity the set, that take the column that we want with $ anche the condition we want
presences <- species[species$Occurrence == 1,]  !!comma at the end to select all the elemnts in the column

absences <- species[species$Occurrence == 0,]

 #plot precences and absences with different colors
 plot(presences, col = "darkgreen", pch = 19)
 #add absences
 points(absences, col = "red", pch = 19)

#look at predictors = environmental variables that we can use to predict the spread of the species
path <- system.file("external", package="sdm")  #path that bring to predictors's file

#list of the predictors
lst <- list.files(path=path, pattern='asc$',full.names = T) 
#we get elevation, precipitation, temperature, vegetation

#stack all the file in lst list into one file => stack()
preds <- stack(lst)

#plot one of the predictors and put on the top the precences
plot(preds$elevation)
points(presences, pch = 19)   #species only in moinr elevation = it hates colds

#same iwth temperature
plot(preds$temperature)
points(presences, pch = 19)  #species live in midium to high temp

#plot vegetation
plot(preds$vegetation)
points(presences, pch = 19) #and it needs to live covered by vegetation

#plot precipitation
plot(preds$precipitation)  #love area with high precipitation rates
points(presences, pch = 19)

#now we want to create the model to link all the variables: presences vs predictors (all together)
#that's the space that we hacìve seen in multivarite analysis
#use the function sdm() but first we have to specify the data to the model 1) points 2) environmental varibales
#to select the data = sdmData() train arguments = training datatset
datasdm <- sdmData(train=species, predictors=preds)  #train = object in which we've sotred the species data

#we want to modelle the occurences vs environmental varibales 
model <- sdm(Occurrence ~ elevation + precipitation + temperature + vegetation, data = datasdm, methods = "glm")
#glm = generalised linear model = linear model in several dimensions
#DIFFRENT MODEL AVAILBLES => WHICH IS THE BEST? make comparison

#create the map  of the model using predict()
p1 <- predict(model, newdata=preds)  #making a map based on the model and on the data that are the predictors

#final stack predictors and p1
s1 <- stack(preds, p1)
plot(s1) #predictions (possibility of occurrences) + predictors (environmental conditions)

#it allow us to predirre dove si trova una specie quando non abbiamo abbastanza dati sperimentali
