library(ggplot2)
library(dslabs)
data("murders")
#plot() can be used to make scatterplots
x<-murders$population/10^6
x<-log10(x)
y<-murders$total
y<-log10(y)
plot(x,y)
#with() let us use the murders column names in the plot function.

with(murders, plot(population, total))
#histograms are useful to see data distribution
x<-with(murders,total/population *10^5)
hist(x)
popu<-murders$population
hist(popu)
str(murders)
murders$state[which.max(x)]
#boxplots provide more terse information than histograms
murders$rate<-with(murders, total/population*10^5)
boxplot(rate~region, data=murders)
boxplot(popu~region, data=murders)

#image() display the value of a matrix using colorConverter

x<-matrix(1:120,12,10)
image(x)
