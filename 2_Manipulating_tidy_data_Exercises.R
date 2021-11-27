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

#---------------------------------SUMMARIZING DATA-----------------------------
#From Introduction to Data science, pp 65-66
#we use the data set from the NHANES package
library(NHANES)
data(NHANES)
NHANES
#The data base has many NAs. ANy summarization function in R will return and NA if any of the entries of the vector is NA
#To avoid it, we can use the na.rm argument
#Lets explore the NHANES dataset. First, we will select 20-29 years old females, using the categorical variable AgeDecade 
#What is the mean and standard deviation of the systolic blood pressure as saved in the BPSysAve variable?
ref<-NHANES%>%filter(Gender =="female" & AgeDecade == " 20-29") %>% summarize (average=mean(BPSysAve, na.rm=TRUE), standard_deviation = sd(BPSysAve, na.rm=TRUE))
ref
#Assign the average to a numeric variable ref_avg
ref_avg<-ref%>%pull(average)
#Now report the min and max values for the same group
NHANES%>%filter(Gender =="female" & AgeDecade == " 20-29") %>% summarize (minimum=min(BPSysAve, na.rm=TRUE), maximum = max(BPSysAve, na.rm=TRUE))
#Compute the average and standard deviation for females, but for each age groupseparately
NHANES%>%filter(Gender =="female") %>% group_by(AgeDecade) %>% summarize (average=mean(BPSysAve, na.rm=TRUE), standard_deviation = sd(BPSysAve, na.rm=TRUE))
#Repeat for males
NHANES%>%filter(Gender =="male") %>% group_by(AgeDecade) %>% summarize (average=mean(BPSysAve, na.rm=TRUE), standard_deviation = sd(BPSysAve, na.rm=TRUE))
#Combine both summaries in a simple line of code
NHANES %>% group_by(Gender, AgeDecade) %>% summarize (average=mean(BPSysAve, na.rm=TRUE), standard_deviation = sd(BPSysAve, na.rm=TRUE))
NHANES %>% group_by(AgeDecade, Gender) %>% summarize (average=mean(BPSysAve, na.rm=TRUE), standard_deviation = sd(BPSysAve, na.rm=TRUE))
#For males between the ages of 40 to 49 compare systolic blood pressure across race as reported in Race1 variable. Order the resulting table from lowest to highest average sytolic blood pressure
NHANES %>% filter(Gender=="male"& AgeDecade== " 40-49") %>% group_by(Race1)%>% summarize(average_systolic_bp = mean(BPSysAve, na.rm=TRUE))%>%arrange (average_systolic_bp)

#---------------tidyverse------------------------
#pp 74 del libro Introduction to DAta Science
data(murders)
murders
class(murders)
murders_tibble<-as_tibble(murders)
class(murders_tibble)
library(tidyverse)


m_f<-function(murders){
  x<-exp(mean(log(murders$population)))
  tibble(x)
}

murders%>%group_by(region)%>%do(m_f(.))

#El ejercicio 5, que intento a continuación, no me sale


compute_s_n_2 <- function(n){
  x<-1:n
  tibble(s_n_2 = sum (x^2))
}


compute_s_n<-function(n){
  x<-1:n
  tibble(n=x, s_n = sum(x), s_n_2 = sum (x^2))
}

n<-1:100
s_n<-map_df(n, compute_s_n)
s_n

