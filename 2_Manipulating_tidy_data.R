#-------------------BASIC DATA MANIPULATION------------------------
#A particular set of packages useful to manipulate tidy data is tidyverse
library(tidyverse)
#tidyverse includes dplyr package to manipulate data frames, purrr for working with functions, and ggplot2 for graphs. It also
#includes the readr package, to import spreadsheets, and many others
#We say that a data table is in tidy format if each row represents an observation and columns represent different 
#variables for each of the observations. For example, the murders dataset is in tidy format
library(dslabs)
data("murders")
murders

#-------------Adding a column to a data frame with mutate-----------------
murders<-mutate(murders,rate = total/population*10^5)
#Note that in the previous we use total and population, which are not defined in the workspace as variables, but we don't get 
#any error. This is one of the dplyrr functionalities. Functions in this package, such as mutate, know how to look for variables
#in data frames provided in the firs argument. For example, the call of total inside the mutate function is taking values in
#murders$total
murders
#although we have changed the object murders, this does not change the object loaded from the data base. I.e., if we load
#data(murders) we get the original data frame

#----------------Subsetting with filter---------------------
#To filter the data table to a subset of rows, we use filter
#For example, if we want to filter data table to show only the entries for which rate is lower than 0.71
filter(murders,rate<=0.71)

#----------------Subsetting with select----------------------
#To subset the data frame by selecting specified columns, we use select. For example, 
new_table<-select(murders, state, region, rate)
filter(new_table,rate<=0.71)

#--------------------The pipe %>% -------------------------
#In dplyr we can send the result from a function to the input of another with the %>% operator.
#For example, we can reach the previous result of selecting 3 columns and filtering by rate<0.71 without defining the object new_table
murders%>%select(state,region,rate)%>%filter(rate<0.71)
#This denotes what we wanted to do: original data -> select -> filter
#%>% is taking murders as the first argument of the select function, and the resulting data frame as the first argument of the filter function.
#In general, %>% sends the result of the left side of the pipe to be the first argument of the function on the right side of the pipe
16%>%sqrt
16%>%sqrt%>%log2
#this is equivalent to
log2(sqrt(16))
#Remember that the pipe sends values to the first argument of the function on the right, so we can define other arguments as if the first argument is
#already defined:
16%>%sqrt%>%log(4)
#is equivalent to 
log(sqrt(16),base=4)
