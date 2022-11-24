#CODE TO CALCULATE VEGETATION INIDICES FROM REMOTE SENSING

#load useful library
library(rgdal)
library(RStoolbox)
library(rasterdiv)

#upload the data into R
setwd("/home/serena/Scrivania/Magistrale/monitoring_ecosystem/lab")

#landast data from 1992, already processed
l1992 <- brick("defor1.png")

#bands order: 1 NIR, 2 red, 3 green, 4 blue (mostly in landast)
#[to know which are the bands usually we look for metadata associated to the image]
# if 1 = NIR => if everithing is vegetation the image'll become red, because vegetation is reflecting a lot in NIR
#if we put green band at the top, if it is vegetaion we'll have green image
#NOR MOST USED BAND FOR ECOSYSTEM DO TO THE PROPERTIES OF PLANTS REFLECTING RED LIGHT

#color plot
plotRGB(l1992, r=1, g=2, b=3, stretch="lin")

#import the second image
l2006 <- brick("defor2.png")
plotRGB(l2006, r=1, g=2, b=3, stretch="lin")

#multiframe
par(mfrow=c(2,1))
plotRGB(l1992, r=1, g=2, b=3, stretch="lin")
plotRGB(l2006, r=1, g=2, b=3, stretch="lin")

#if a lot of soil eroded => blue, because water abosorb red light
#bare soil reflect light
#river is a proof that we're looking at the same area in differt year, but also straith patch assure us that the area is the same

#calculate some VEGETATION INIDICES to give a quantitive value of the deforestation
#that we'll apply some CLASSIFICATION to determine a treshold to use to give a quantification

#[WE REPRESENT THE AMOUNT OF REFLECTANCE IN INTEGER USING BIT. BY DEFINITIO REFLECTANCE IS FROM 0 TO 1 
#=> IN INTERGER NUMBER IS FROM 0 TO 255 BECAUSE WE'RE USING 8 BIT TO REPRESENT IMAGE]

#DVI INDEX = NIR - R bands of the image
#lower value => increase the red, so diminish the vegetation (image more yellow)
par(mfrow=c(1,2))
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100) 
dvi1992 = l1992[[1]] - l1992[[2]] 
dvi2006 = l2006[[1]] - l2006[[2]] 
plot(dvi1992, col=cl)
plot(dvi2006, col=cl) #more yellow = higher decrease of vegetation
