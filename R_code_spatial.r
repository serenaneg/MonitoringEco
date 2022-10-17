library("sp")

data(meuse)

head(meuse)

#looking at the spacial componenets of the dataset
coordinates(meuse) = ~x+y  #x, y spacial components of the data that can be used for mapping the data, using coordnates() function; ~ to clamp
                           #through coordinates() we set the datatset as a spatial dataset
plot(meuse) #now we obtain the spatial distribution of the data

#plotting every single variable in space: plot of the package sp
spplot(meuse, "zinc", main="Concentration of Zinc") #dataframe, variable to plot, data divied into different ctegories depending on their value
spplot(meuse, "copper", main="Concentration of Copper")

#spatial plot of several varibales
spplot(meuse, c("copper","zinc"))  #two plots, same categories of values for both variables, obviously the spatial distribution id the same

#instead of different colors we can use bubbles with increasing diameters  according to the increase of values
bubble(meuse, "zinc")  #very nice manner to show data :)
bubble(meuse, "lead", col="blue") #not working with array of variables
