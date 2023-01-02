#load useful library
library(rgdal)
library(RStoolbox)
library(rasterdiv)
library(ggplot2)
library(viridis)

#upload the data into R
setwd("/home/serena/Scrivania/Magistrale/monitoring_ecosystem/alga_bloom/LT05_L1TP_019031_20111005_20200820_02_T1")

#load layers that create the image
blue <- raster("LT05_L1TP_019031_20111005_20200820_02_T1_B1.TIF")#09/10/2011
green <- raster("LT05_L1TP_019031_20111005_20200820_02_T1_B2.TIF")
red <- raster("LT05_L1TP_019031_20111005_20200820_02_T1_B3.TIF")

rgb <- stack(red, green, blue)

#cut the image to zoom on the region of interest
#extention of the original image
#extent     : 283185, 430005, 4514385, 4732515  (xmin, xmax, ymin, ymax)
boundary <- raster( xmn = 365000, xmx = 430000 , ymn = 4600000, ymx = 4680000)
image <- crop(rgb, boundary)
plotRGB(image, stretch = "lin")


#ok with linear stretching because it has a strong contrast very useful to visualise algae

#infrared image
#create the image with nir band (5) as red, red band (4) green and green band (3) as blue 
green_lw <- raster("LT05_L1TP_019031_20111005_20200820_02_T1_B3.TIF")
red_lw <- raster("LT05_L1TP_019031_20111005_20200820_02_T1_B4.TIF")
nir <- raster("LT05_L1TP_019031_20111005_20200820_02_T1_B5.TIF")

rgb_lw <- stack(nir, red_lw, green_lw)

boundary <- raster( xmn = 365000, xmx = 430000 , ymn = 4600000, ymx = 4680000)
image_lw <- crop(rgb_lw, boundary)
plotRGB(image_lw, stretch = "lin")

hist(image_lw)

#NDVI INDEX = (NIR - RED) / (NIR + RED)
#combine red images with boundary
red_lw <- crop(red_lw, boundary)
nir <- crop(nir, boundary)

ndvi <- (nir - red_lw) / (nir + red_lw)

colors = colorRampPalette(c("red3", "white", "darkcyan"))(255)
plot(ndvi, col=colors)

