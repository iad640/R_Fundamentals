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

#-----------------------------SUMMARIZING DATA---------------------------------
#An important part of exploratory data analysis is data summarize. We do it here with a dataset heights included in the dslabs package

data(heights)
attributes(heights)
class(heights)
summary(heights)
#Compute the mean and the standard deviation for female heights
s<-heights %>% filter(sex=="Female") %>% summarize(average = mean(height), standard_deviation = sd(height))
s
#Note that like most of dplyr functions, summarize is aware of the variable names. So, we just called height or sex, instead of heights$sex and heights$height
#summarize returns a special data frame called tbl, or tibble
#We can add the median, minimum and maximum heights like this
heights%>%filter(sex == "Female") %>% summarize(median = median(height), minimum = min(height), maximum = max(height))
#We can obtain the same results with the quantile function
x<-heights%>%filter(sex=="Female")
quantile(x$height, c(0, 0.5, 1))
#note that q(x, c(0, 0.5, 1)) returns the 0th quantile (minimum), 50th quantile (median) and the 100 th quantile (maximum)
#we can calculate the US mean
us_murders_rate<-murders%>%summarize(rate=sum(total)/sum(population)*10^5)
us_murders_rate
#or We can find the average of murder rate from states, associating equal weight to every state independently on its size
summarize(murders, mean(rate))

#-----------PULL-------------------
#although us_murder_rate represents one number, it is store as a data frame since summarize returns a data frame:
class(us_murders_rate)
#this can be problematic if we need the value to be used in a function with a numeric value. For this, we can use pull()
y<-pull(us_murders_rate, rate)
# which is the same as y<-us_murders_rate%>%pull(rate)
#is also equivalent to us_murders_rate$rate
#therefor, to get a number from the original table in a single line of code we type
us_murders_rate<-murders%>%summarize(rate = sum(total)/sum(population)*10^5)%>%pull(rate)
#which is a number
class(us_murders_rate)

#-----------------GROUP BY -------------------------------
#sometimes it is interesting to split data into groups and then summarize in each group:
grouped_heights<-heights%>%group_by(sex)
#the new objects is similar to the previous one, but differs in that it is a grouped data frame. This new table can be seen
#as  many tables with the same columns but not the same number of rows neccesarily, stacked together into one object.
#This function returns a special data frame called tbl, or tibble
#If we summarize,
summarize(grouped_heights, avearge = mean(height), standard_deviation = sd (height))
#We obtain mean and standard deviation for different groups since summarize is applied to each group separately
#Another example
murders%>%group_by(region)%>%summarize(median = median(rate))

#----------------------SORTING DATA FRAMES------------------------------
#We know order and sort for vectors. For entire data tables, we can unse the function arrange. FOr example, to order by increasing population,
murders%>%arrange(population)%>%head()
#To order by decreasing population
murders%>%arrange(desc(population))%>%head()
#--------------nested sorting-------------
#Here we add a second argument to the arrange function to order by region, and then within region we order by murder rate
murders%>%arrange(rate)%>%head()


#-------------------top_n------------------------
#If we want to sort a data frame we use arrange. If we want to show only the n first rows, we use top_n
murders %>% top_n(5, rate)
#the first argument tells how many observations will be used. The second tells the criteria to filter the data frame,
#in this case, it shows the highest 5 murders rates, without sorting by rate
#To show the smallest 7 murder rates, without sorting by rate
murders %>% top_n(-7, rate)

#-----------------------------do----------------------------------------
#Tidyverse functions know how to interpret grouped tibbles. But this is not the case of other R functions. For example,
#the quantile function we can use it here like this
data(heights)
heights %>% filter(sex == "Female") %>% summarize(range = quantile(height, c(0, 0.5, 1)))
#or this way 
my_summary <- function (dat){x<- quantile(dat$height, c(0, 0.5, 1))
tibble(min =x[1], median=x[2], max=x[3])
}
#We can now apply the function to the heights dataset
heights%>%group_by(sex)%>%my_summary
#but we want a summary for each sex, instead of this. This is because the function my_summary is not a tidyverse function,
#and does not know how to handle grouped tibbbles. We need to use the do funtion
heights%>%group_by(sex)%>%do(my_summary(.))
#we have use the dot operator as explained in pp 71. If we don't, we get a error
heights%>%group_by(sex)%>%do(my_summary())
#this also give an error:
heights%>%group_by(sex)%>%do(my_summary)

#-------------the purr package------------------------
#Similar to sapply, the purrr package includes functions that apply the same function to elements of an object, but
#that better interact with other tidyverse functions. The main a dvantage is that we can better control the output type
#of functions

#map works similar to sapply but always with no exception returns a list
compute_s_n <- function(n){
  x<-1:n
  sum(x)
}
n <- 1:25
s_n<-map(n, compute_s_n)
s_n                             
class(s_n)

#if we want a numeric vector we can use map_dbl instead, that returns a vector of numeric values
s_n <- map_dbl(n, compute_s_n)
s_n
class(s_n)
#This produces the same result as sapply
s_n <- sapply(n, compute_s_n)
s_n
class(s_n)

# map_df always returns a tibble data frame. However, the function being called needs to return a vector or a list with names.
#For this reason, the following code would result in a Argument 1 must have names error
s_n <- map_df(n, compute_s_n)
#Therefore we need to change the function to make this work
compute_s_n <- function(n){
  x<- 1:n
  tibble(sum= sum(x))
}
s_n <- map_df(n, compute_s_n)
s_n
class(compute_s_n(5))

