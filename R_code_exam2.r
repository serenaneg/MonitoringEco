#load useful library
library(rgdal)
library(RStoolbox)
library(rasterdiv)
library(ggplot2)
library(viridis)
library(RColorBrewer)

#upload the data into R
setwd("/home/serena/Scrivania/Magistrale/monitoring_ecosystem/alga_bloom/LT05_L1TP_019031_20111005_20200820_02_T1")

#load layers that create the image
blue <- raster("LT05_L1TP_019031_20111005_20200820_02_T1_B1.TIF")#09/10/2011
green <- raster("LT05_L1TP_019031_20111005_20200820_02_T1_B2.TIF")
red <- raster("LT05_L1TP_019031_20111005_20200820_02_T1_B3.TIF")
red_lw <- raster("LT05_L1TP_019031_20111005_20200820_02_T1_B4.TIF")
nir <- raster("LT05_L1TP_019031_20111005_20200820_02_T1_B5.TIF")  #mostly land => treshold value to mask the land
swir <- raster("LT05_L1TP_019031_20111005_20200820_02_T1_B6.TIF")

image <- stack(swir, nir, red_lw, red, green, blue)

#cut the image to zoom on the region of interest
#extention of the original image:
#extent     : 283185, 430005, 4514385, 4732515  (xmin, xmax, ymin, ymax)
boundary <- raster( xmn = 365000, xmx = 430000 , ymn = 4600000, ymx = 4680000)
image <- crop(image, boundary)

#plot true color image and save
pdf("rgbTrue.pdf")
plotRGB(image, r = 4, g = 5, b = 6, stretch = "lin")
dev.off

#ok with linear stretching because it has a strong contrast very useful to visualise algae

#infrared image
#create the image with nir band (5) as red, red band (4) green and green band (3) as blue 
rgb_lw <- stack(nir, red_lw, red)
boundary <- raster( xmn = 365000, xmx = 430000 , ymn = 4600000, ymx = 4680000)
image_lw <- crop(rgb_lw, boundary)

#plot
pdf("rgbFalse.pdf")
plot(image_lw, xaxt='n', yaxt='n', main = c("NIR - Band 5", "Red lw - Band 4", "red - Band 4" ))
dev.off()

#looking at the nir image band, id the one with grater contrast between land and sea pixels => used to create the mask
#create the mask usig NIR band because is were we have the major contrast between land and sea
nir_image <- crop(nir, boundary)
nir_image[nir_image > 20] <- NA

#apply the mask
image_masked <- mask(image, mask = nir_image)
#plot images
pdf("masked.pdf")
par(mfrow=c(1,2))
#TRUE COLOR
plotRGB(image_masked, r = 4, g = 5, b = 6, stretch = "lin")
legend("top", legend = NA, title = expression(bold("RGB True Color")), bty = "n", cex = 1.3)

#FALSE COLOR
plotRGB(image_masked, r = 2, g = 3, b = 4, stretch = "lin") 
legend("top", legend = NA, title = expression(bold("RGB False Color")), bty = "n", cex = 1.3)
dev.off()

#DVI INDEX = NIR - RED
dvi <- image_masked[[1]] - image_masked[[2]]
pal <- brewer.pal(10, "RdYlBu")
colors <- colorRampPalette(pal)
plot(dvi, col = colors(10))

#NDVI INDEX = (NIR - RED) / (NIR + RED) -> normalized
#using masked image
ndvi <- (image_masked[[1]] - image_masked[[2]]) / (image_masked[[1]] + image_masked[[2]])
colors = colorRampPalette(c("red3", "white", "darkcyan"))(255)
plot(ndvi, col = colors(10))

#SABI = (NIR - RED) / (BLUE + GREEN)
image2 <- stack(nir, red, green, blue)
image2 <- crop(image2, boundary)

image2 <- mask(image2, mask = nir_image)
plot(image2)
plotRGB(image2, stretch = "lin")

sabi <- (image2[[1]] - image2[[2]]) / (image2[[4]] + image2[[3]])
plot(sabi, col = colors(10))

#Floating Algae Index FAI 
swir <- raster("LT05_L1TP_019031_20111005_20200820_02_T1_B6.TIF")
image3 <- stack(swir, nir, red_lw)
image3 <- crop(image3, boundary)
image3 <- mask(image3, mask = nir_image)

#FAI = NIR - RED - (SWIR - RED)*(l_NIR - l_RED) / (l_SWIR - l_RED)
fai <- image3[[2]] - image3[[3]] - (image3[[1]] - image3[[2]])*((865 - 655) / (1610 - 655))
plot(fai, col = colors(10))

par(mfrow=c(1,4))
plot(dvi, col=colors(10), main = "DVI")
plot(ndvi, col=colors(10), main = "NDVI")
plot(sabi, col=colors(10), main = "SABI")
plot(fai, col = colors(10), main = "FAI")