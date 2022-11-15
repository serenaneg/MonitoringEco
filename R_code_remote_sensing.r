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

#plot with different color palette
#blue
clb <- colorRampPalette(c('dark blue','blue','light blue'))(100) # 
plot(image$B1_sre, col=clb)

#green
clg <- colorRampPalette(c('dark green','green','light green'))(100) # 
plot(image$B2_sre, col=clg)

#red
clr <- colorRampPalette(c('dark red','red','pink'))(100) # 
plot(image$B3_sre, col=clr)

#NIR band
clnir <- colorRampPalette(c('red','orange','yellow'))(100) # 
plot(image$B4_sre, col=clnir)

#plot RGB plot
par(mfrow=c(2,2))  #create ad image 2 rows, 2 col with the following for plot !!BEFORE PDF SAVING
pdf("remotesensing.pdf")
plotRGB(image, r=3, g=2, b=1, stretch="Lin") #dark blue
plotRGB(image, r=4, g=3, b=2, stretch="Lin") #reddish
plotRGB(image, r=3, g=4, b=2, stretch="Lin") #green
plotRGB(image, r=3, g=2, b=4, stretch="Lin") #blue
dev.off() #to close the par function


