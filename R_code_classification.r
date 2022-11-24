#CODE TO CLASSIFY VEGETATION PIXELS = THRESHOLD FOR TREES

#download library
library(RStoolbox) #allow us to classify the data

library(rgdal)
library(RStoolbox)
library(rasterdiv)

#upload the data into R
setwd("/home/serena/Scrivania/Magistrale/monitoring_ecosystem/lab")

#landast data from 1992, already processed
l1992 <- brick("defor1.png")

#import the second image
l2006 <- brick("defor2.png")
plotRGB(l2006, r=1, g=2, b=3, stretch="lin")

#multiframe
par(mfrow=c(2,1))
plotRGB(l1992, r=1, g=2, b=3, stretch="lin")
plotRGB(l2006, r=1, g=2, b=3, stretch="lin")

#DVI INDEX = NIR - R bands of the image
#lower value => increase the red, so diminish the vegetation (image more yellow)
par(mfrow=c(1,2))
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100) 
dvi1992 = l1992[[1]] - l1992[[2]] 
dvi2006 = l2006[[1]] - l2006[[2]] 
plot(dvi1992, col=cl)
plot(dvi2006, col=cl) #more yellow = higher decrease of vegetation

#CLASSIFICAATION better with original image that div
#use USUPERVISED function = kmean clustering, the software'll do the classification
l1992_class <- unsuperClass(l1992, nClasses=2) #we have to give the number of classes that we want
#it return a MAP
plot(l1992_class$map) 

#calculate the amount of thig that are changed with time => function frequency (statistical)
freq(l1992_class$map)
#1992
# class 1 (forest) 306059
# class 2 (human)   35233
#now we cal calculate the proportion betweent the two classes
#forest
f1992 <- 306059/(306059 + 35233) #0.90 90% of forest 
h1992 <-  35233/(306059 + 35233) #0.10

#let's now for 2002
l2006_class <- unsuperClass(l2006, nClasses = 2)
freq(l2006_class$map)
plot(l2006_class$map)
#2006
#!!! NB CLASSES ARE REVERSE COMPARE TO BEFORE  !!!
# class 2 (forest) 178075 
# class 1 (human)  164651
f2006 <- 178075/(178075 + 164651) #0.52 51% forest
h2006 <- 164651/(178075 + 164651) #0.48 48% human

#create a table with the proportions, usinf function DATA.FRAME

