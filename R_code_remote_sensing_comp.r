#COMPARISON between two LANDSAT images of the same area but in differet years: 1988 vs 2011

#load libraries
library(raster)
library(RStoolbox)

setwd("~/Scrivania/Magistrale/monitoring_ecosystem/lab/remote_sensing")

#use brick function to catch the image data
image2011 <- brick("p224r63_2011_masked.grd") 
image1988 <- brick("p224r63_1988_masked.grd")

#let's check
new <- plot(image2011)
old <- plot(image1988)

#create and save pdf image
#PDF NON WORKIN WITH PAR????
pdf("1988vs2011.pdf")
par(mfrow=c(1,2))
plotRGB(image2011, r=3, g=2, b=1, stretch="Lin") #dark blue
plotRGB(image1988, r=3, g=2, b=1, stretch="Lin") 
dev.off()
