#R code to deal with Landast images

library(raster)
library(RStoolbox)

setwd("~/Scrivania/Magistrale/monitoring_ecosystem/lab/p224r63_2011")

#grid file .grd
#brick function to go out from R and catch the data and assing to a certain name
image <- brick("p224r63_2011_masked.grd") 
image
###################################################################################
#class      : RasterBrick 
#dimensions : 1499, 2967, 4447533, 7  (nrow, ncol, ncell, nlayers)  //4 millions of data each level, there are 7 levels 
#resolution : 30, 30  (x, y)     //each pixel is 30mX30m
#extent     : 579765, 668775, -522705, -477735  (xmin, xmax, ymin, ymax)  //coordinates
#crs        : +proj=utm +zone=22 +datum=WGS84 +units=m +no_defs 
#source     : p224r63_2011_masked.grd 
#names      :       B1_sre,       B2_sre,       B3_sre,       B4_sre,       B5_sre,        B6_bt,       B7_sre 
#min values : 0.000000e+00, 0.000000e+00, 0.000000e+00, 1.196277e-02, 4.116526e-03, 2.951000e+02, 0.000000e+00 
#max values :    0.1249041,    0.2563655,    0.2591587,    0.5592193,    0.4894984,  305.2000000,    0.3692634 
##################################################################################
#let's plot directly
plot(image)  #in each band we're measuring reflectance at different wavelenght
#LANDSAT BANDS 1)deep blue and violets 2)-...
#High refectace = darker color, low reflectance = absorption => lighter color

#change color bar =grey scale
cl <- colorRampPalette(c('black','grey','light grey'))(100)
plot(image, col=cl)
