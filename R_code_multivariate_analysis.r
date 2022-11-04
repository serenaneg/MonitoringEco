#community ecology example with R
#Multivariate analysis

#to perform multivariate analysis we use the library "vegan" = vegetation analysis: community ecology package
library("vegan") 

setwd("~/Scrivania/Magistrale/monitoring_ecosystem/lab/")

#importing a complete R project ".RData", to upload use the function load()
load("biomes_multivar.RData")

#check the files ibnside the projects
ls()

#we're interested in the files: biomes and biomes_types (matrix of plots and species)
#We have plots and species and we'd like to see than in just 2 dimensions (20 in reality)
biomes  #plot vs species 
head(biomes)
biomes_types #it gave us the association between plot and biomes (label)

#to to the multivariate analysis we'll use decorana() 
#function = Detrended Correspondence Analysis and Basic Reciprocal Averaging, similar to PCA

multivar <- decorana(biomes)
multivar

#                       DCA1   DCA2    DCA3    DCA4
#Eigenvalues          0.5117 0.3036 0.12125 0.14267
#Additive Eigenvalues 0.5117 0.2985 0.12242 0.12984
#Decorana values      0.5360 0.2869 0.08136 0.04814
#Axis lengths         3.7004 3.1166 1.30055 1.47888
#so first component is explaini 51% of the variance and the second the 30%
#taking these tow we can see the variability of ou dataset usgin just two dimensions

#let's plot that
plot(multivar)

#how to see the different biomes: easily selecting the label connected to each plot
#we need the biomes_types table
attach(biomes_types)

#than we can use the function ordiellipse() = display groups in ordinantin diagrams
ordiellipse(multivar, type, col=c("black", "red", "green", "blue"), kind="ehull", lwd=3) #type = group difffernt objects according to their type

#this function connect the data inside common ellipse and show their etiquette if label=T
ordispider(multivar, type, col=c("black", "red", "green", "blue"), label=T, lwd=3)

#how to export the plot in a pdf file and save into the folder
#we use pdf() function: it is a vectorial format => do not lose image quality
pdf("multivar.pdf")#quotes because we're going out from R
#after we write everything we what to save as an image
plot(multivar)
ordiellipse(multivar, type, col=c("black","red","green","blue"), kind = "ehull", lwd=3)
ordispider(multivar, type, col=c("black","red","green","blue"), label = T)
dev.off() #to close the pdf

#########################EXERCISE#################################
#export pdf with only multivar plot
pdf("multivar_only.pdf")
plot(multivar)
dev.off()
