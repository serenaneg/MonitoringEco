#load useful library
library(rgdal)
library(RStoolbox)
library(raster)
library(RColorBrewer)
library(ggplot2)
library(reshape2) #to create the data frame for ggplot graphs
library(patchwork)

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

#use crop() to create the geographica subset of the original image (raster object)
image <- crop(file, boundary)

#plot true color image and save
pdf("rgbTrue.pdf", 7, 8)
par(mfrow=c(2,2))
plotRGB(image, r = 3, g = 2, b = 1, stretch = "lin")
dev.off()


#infrared image
#create the image with nir band (5) as red, red band (4) green and green band (3) as blue 
rgb_lw <- stack(red, nir, swir)
boundary <- raster( xmn = 365000, xmx = 430000 , ymn = 4600000, ymx = 4680000)
image_lw <- crop(rgb_lw, boundary)

#plot layers red bands
pdf("rgbFalse.pdf")
par(pty = "m", mar = c(3.5, 3.5, 3.5, 3.5))
plot(image_lw, xaxt = 'n', yaxt = 'n', main = c( "Red - Band 3", "NIR - Band 4", "SWIR - Band 5"))
dev.off()

#looking at the swir image band, id the one with grater contrast between land and sea pixels => used to create the mask
#create the mask usig NIR band because is were we have the major contrast between land and sea
swir_image <- crop(swir, boundary)
swir_image[swir_image > 11] <- NA

pdf("mask.pdf")
plot(swir_image, xaxt = 'n', yaxt = 'n', col = 'darkcyan', legend = F, axes = F)
dev.off()

#apply the mask using mask() => return same values as image, except for the cells that are NA in the mask
image_masked <- mask(image, mask = swir_image)

#plot images
pdf("masked_rgb.pdf")
#TRUE COLOR
plotRGB(image_masked, r = 3, g = 2, b = 1, stretch = "lin")
legend("top", legend = NA, title = expression(bold("RGB True Color")), bty = "n", cex = 1.3)
dev.off()

#FALSE COLOR
pdf("masked_false.pdf")
plotRGB(image_masked, r = 4, g = 3, b = 2, stretch = "lin") 
legend("top", legend = NA, title = expression(bold("RGB False Color")), bty = "n", cex = 1.3)
dev.off()

#layers
pdf("layers.pdf")
plot(image_masked, xaxt='n', yaxt='n', main = c("BLUE - Band 1", "GREEN - Band 2", "RED - Band 3", "NIR - Band 4", "SWIR - Band 5"))
dev.off()

#################################### SPECTRAL INDECES #######################################################
#specify color scheme
colors <- colorRampPalette(c('darkblue', 'yellow', 'red', 'black'))(100)

#Difference Vegetation Index
#DVI = NIR - RED
dvi <- image_masked[[4]] - image_masked[[3]]

pdf("dvi.pdf")
plot(dvi, main = "DVI", col = colors)
dev.off()

#Normalized DVI
#NDVI = (NIR - RED) / (NIR + RED) -> normalized
ndvi <- ((image_masked[[4]] - image_masked[[3]]) / (image_masked[[4]] + image_masked[[3]]))

pdf("ndvi.pdf")
plot(ndvi, main = "NDVI", col = colors)
dev.off()

#Surface Algae Blooming Index
#SABI = (NIR - RED) / (BLUE + GREEN)
sabi <- (image_masked[[4]] - image_masked[[3]]) / (image_masked[[1]] + image_masked[[2]])

pdf("sabi.pdf")
plot(sabi, main = "SABI", col = colors)
dev.off()

#Floating Algae Index
#FAI = NIR - RED - (SWIR - RED)*(l_NIR - l_RED) / (l_SWIR - l_RED)
fai <- image_masked[[4]] - image_masked[[3]] - (image_masked[[5]] - image_masked[[3]])*((0.83 - 0.66) / (1.65 - 0.66))
#waveleght associated to the band calculated as the mean value of the range of values of the Landasat Bands

pdf("fai.pdf")
plot(fai, main = "FAI", col = colors)
dev.off()

#comparison amog indexes
pdf("confronto.pdf")
par(mfrow=c(2,2), mar = c(3.5, 3.5, 3.5, 7))
plot(dvi, col = colors, main = "DVI")
plot(ndvi, col = colors, main = "NDVI")
plot(sabi, col = colors, main = "SABI")
plot(fai, col = colors, main = "FAI")
dev.off()

#histogram
pdf("hist.pdf")
par(mfrow=c(2,2))
hist(dvi, xlab = "Value", main = "DVI")
hist(ndvi, xlab = "Value", main = "NDVI")
hist(sabi, xlab = "Value", main = "SABI")
hist(fai, xlab = "Value", main = "FAI")
dev.off()
#can be better => use ggplot

############################################# GGPLOT GRAPHS ##################################################################
#create a data frame with the indices (raster)
#stack of the indices
index <- stack(dvi, ndvi, sabi, fai)
dat <- as.data.frame(index)

#remove NAN values
dat <- na.omit(na)

#Histograms
p1 <- ggplot(dat, aes(x = layer.1)) + 
     geom_histogram(color = "black", fill = "chartreuse3", alpha = .4, lwd = 0.5) + labs(title = "DVI distribution", x = "Value", y = "Frequency")
p2 <- ggplot(dat, aes(x = layer.2)) + 
     geom_histogram(color = "black", fill = "orange", alpha = .4, lwd = 0.5) + labs(title = "NDVI distribution", x = "Value", y = "Frequency")
p3 <- ggplot(dat, aes(x = layer.3)) + 
     geom_histogram(color = "black", fill = "blue", alpha = .4, lwd = 0.5) + labs(title = "SABI distribution", x = "Value", y = "Frequency")
p4 <- ggplot(dat, aes(x = layer.4)) + 
     geom_histogram(color = "black", fill = "coral", alpha = .4, lwd = 0.5) + labs(title = "FAI distribution", x = "Value", y = "Frequency")

pdf("hist_gg.pdf", 11, 8)
(p1 + p2) / (p3 + p4)
dev.off()

#density distributions
d1 <- ggplot(dat, aes(x = layer.1)) + 
     geom_density(color = "chartreuse3", fill = "chartreuse3", alpha = .25) + labs(title = "DVI density", x = "Value", y = "Density")
d2 <- ggplot(dat, aes(x = layer.2)) + 
     geom_density(color = "orange",  fill = "orange", alpha = .25) + labs(title = "NDVI density", x = "Value", y = "Density")
d3 <- ggplot(dat, aes(x = layer.3)) + 
     geom_density(color = "blue", fill = "blue", alpha = .25) + labs(title = "SABI density", x = "Value", y = "Density")
d4 <- ggplot(dat, aes(x = layer.4)) + 
     geom_density(color = "coral", fill = "coral", alpha = .25) + labs(title = "FAI density", x = "Value", y = "Density")

pdf("density.pdf", 11, 8)
(d1 + d2) / (d3 + d4)
dev.off()

#overlay density on histrograms
ggplot(dat, aes(x = layer.1)) +
  geom_histogram(aes(y = ..density..), color = "black", fill = "white", lwd = 0.5) + 
  geom_density(lwd = 1, fill = "chartreuse3", col = "chartreuse3", alpha = .25) +
  labs(title = "DVI distribution", x = "Value", y = "Density")

     #mh not so nice
  
  
