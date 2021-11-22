#------------mutate, filter and select exercises----------------------
#From Introduction to Data science, pp 57-58
#Load the dplyr package and the murders dataset
library(dplyr)
library(dslabs)
data("murders")

murders<-mutate(murders, population_in_millions = population/10^6)
murders<-mutate(murders, rate=total/population*10^5)
murders
#add a column containing the rank from highest to lowest murder rate
murders<-murders%>%mutate(rank=rank(-rate))
#Show only the states and population sizes
murders%>%select(state, population)
#Show the state names and abbreviations
murders%>%select(state, abb)
#Show just the state of New York
murders%>%filter(state =="New York")
#Show the top 5 states with the highest murder rates
murders%>%filter(rank<=5)
#REmove rows
no_florida<-filter(murders, state!="Florida")
no_south<-filter(murders,region != "South")
#How many states are in this category?
nrow(no_south)
#See data from New York and Texas
filter(murders, state %in% c("New York","Texas"))
#Create a new data frame called murders_nw with only the states from the Northeat and the WEst. How many states are in the category?
murders_nw<-filter(murders, region %in% c("Northeast","West"))
nrow(murders_nw)
murders_nw
#Suppose you want to live in west or northeast regions, and with murder rate lower than 1
my_states<-murders%>%filter(region %in% c("Northeast","West") & rate < 1)%>%select(state, rate, rank)
my_states
murders

#--------------------------USING the Pipe %>% -----------------------------
#From Introduction to Data science, pp 59-60
# show the result and only include the state, rate, and rank columns, all in one line, in that order
murders%>%filter(region %in% c("Northeast","West")&rate<1)%>%select(state, rate, rank)
