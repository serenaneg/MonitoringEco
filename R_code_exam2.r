#load useful library
library(rgdal)
library(RStoolbox)
library(rasterdiv)
library(ggplot2)
library(RColorBrewer)

#upload the data into R
setwd("/home/serena/Scrivania/Magistrale/monitoring_ecosystem/alga_bloom/LT05_L1TP_019031_20111005_20200820_02_T1")

#load layers that create the image
blue <- raster("LT05_L1TP_019031_20111005_20200820_02_T1_B1.TIF") #0.45-0.52 mum
green <- raster("LT05_L1TP_019031_20111005_20200820_02_T1_B2.TIF") #0.52-0.60 mum
red <- raster("LT05_L1TP_019031_20111005_20200820_02_T1_B3.TIF") #0.63-0.69 mum
nir <- raster("LT05_L1TP_019031_20111005_20200820_02_T1_B4.TIF") #0.76-0.90 mum
swir <- raster("LT05_L1TP_019031_20111005_20200820_02_T1_B5.TIF") #1.55-1.75 mum

file <- stack(blue, green, red, nir, swir)

#cut the image to zoom on the region of interest
#extention of the original image: 283185, 430005, 4514385, 4732515  
boundary <- raster( xmn = 365000, xmx = 430000 , ymn = 4600000, ymx = 4680000)
image <- crop(file, boundary)

#plot true color image and save
pdf("rgbTrue.pdf")
par(mfrow=c(2,2))
plotRGB(image, r = 3, g = 2, b = 1, stretch = "lin", main = "Linear stretching")
dev.off()

#ok with linear stretching because it has a strong contrast very useful to visualise algae

#infrared image
#create the image with nir band (5) as red, red band (4) green and green band (3) as blue 
rgb_lw <- stack(red, nir, swir)
boundary <- raster( xmn = 365000, xmx = 430000 , ymn = 4600000, ymx = 4680000)
image_lw <- crop(rgb_lw, boundary)

#plot layers red bands
pdf("rgbFalse.pdf", width = 7, height = 6)
par(pty = "m", mar = c(2, 4, 4, 4))
plot(image_lw, xaxt = 'n', yaxt = 'n', main = c( "Red - Band 3", "NIR - Band 4", "SWIR - Band 5"))
dev.off()

#looking at the swir image band, id the one with grater contrast between land and sea pixels => used to create the mask
#create the mask usig NIR band because is were we have the major contrast between land and sea
swir_image <- crop(swir, boundary)
swir_image[swir_image > 1] <- NA

pdf("mask.pdf")
plot(swir_image, xaxt = 'n', yaxt = 'n', col = 'darkcyan', legend = F, axes = F)
dev.off()

#apply the mask
image_masked <- mask(image, mask = swir_image)
#plot images
pdf("masked_rgb.pdf")
#TRUE COLOR
plotRGB(image_masked, r = 3, g = 2, b = 1, stretch = "lin")
legend("topleft", legend = NA, title = expression(bold("RGB True Color")), bty = "n", cex = 1.3)
dev.off()

#FALSE COLOR
pdf("masked_false.pdf")
plotRGB(image_masked, r = 4, g = 3, b = 2, stretch = "lin") 
legend("topleft", legend = NA, title = expression(bold("RGB False Color")), bty = "n", cex = 1.3)
dev.off()

#layers
pdf("layers.pdf")
plot(image_masked, xaxt='n', yaxt='n', main = c("BLUE - Band 1", "GREEN - Band 2", "RED - Band 3", "NIR - Band 4", "SWIR - Band 5"))
dev.off()

#specify color scheme
colors <- colorRampPalette(c('darkblue', 'yellow', 'red', 'black'))(100)

#DVI INDEX = NIR - RED
dvi <- image_masked[[4]] - image_masked[[3]]
plot(dvi, col = colors)

#NDVI INDEX = (NIR - RED) / (NIR + RED) -> normalized
#using masked image
ndvi <- ((image_masked[[4]] - image_masked[[3]]) / (image_masked[[4]] + image_masked[[3]]))
plot(ndvi, col = colors)

#SABI = (NIR - RED) / (BLUE + GREEN)
sabi <- (image_masked[[4]] - image_masked[[3]]) / (image_masked[[1]] + image_masked[[2]])
plot(sabi, col = colors)

#Floating Algae Index FAI
#FAI = NIR - RED - (SWIR - RED)*(l_NIR - l_RED) / (l_SWIR - l_RED)
fai <- image_masked[[4]] - image_masked[[3]] - (image_masked[[5]] - image_masked[[3]])*((0.83 - 0.66) / (1.65 - 0.66))
#waveleght of the band calculated as the mean value of the range given
plot(fai, col = colors)

pdf("confronto.pdf")
par(mfrow=c(2,2), mar= c(3.5, 3.5, 3.5, 7))
plot(dvi, col=colors, main = "DVI")
plot(ndvi, col=colors, main = "NDVI")
plot(sabi, col=colors, main = "SABI")
plot(fai, col = colors, main = "FAI")
dev.off()

#histogram
pdf("hist.pdf")
par(mfrow=c(2,2)m mar= c(3.5, 3.5, 3.5, 3.5))
hist(dvi, xlab = "Value", main = "DVI")
hist(ndvi, xlab = "Value", main = "NDVI")
hist(sabi, xlab = "Value", main = "SABI")
hist(fai, xlab = "Value", main = "FAI")
dev.off()
