####################-------------EXERCISES--------------#######################
#Let's load the murders dataset from the dslabs gallery:

library (dslabs)
data(murders)
#Check that this is a data frame
class(murders)
#Find out about the structure of the object. Which of the following best describes the variables represented in this data frame?
#What are the column names used by the data frame for these five variables?
str(murders)
#Use the accesor $ to extract the state abbreviations and  assign it to a variable a. Which class is a?

a<-murders$abb
a
class(a)
#Do the same with [[ ...]] instead of $, assign it to variable b and check that the two variables are identical
b<-murders[,2]
b
class(b)
identical(a,b)

#Show the first 6 and last 6 observations from the data frame
head(murders)
tail(murders)

name_states<-murders$state
class(name_states)

#The population of each state is:
pop<-murders$population
#which is a vector. The function length tells us how many entries are in the vector:
length(pop)
#class is:
class(pop)
#the vector with all state names is
#Sort the pop vector
sort(pop)
#Select the smallest population size with sort and with min
sort(pop)[1]
min(pop)
#Find the index of the entry with the smallest population size with order and with which.min
order(pop)[1]
index_smallest<-which.min(pop)
#which state is this?
murders$state[index_smallest]


#In the murders dataset, region is a factor instead of a character

class(murders$region)
levels(murders$region)
length(murders$region)

#Suppose we want the levels of the region by the total number of murders rather than alphabetical order. If there are values associated with each level,
#we can use the reorder function and specify a data summary to specify the order. The following takes the sum of total murders in each region and reorders the factor following these sums
region<-murders$region
value<-murders$total
region<-reorder(region,value, FUN=sum)
levels(region)
#Use table function to create a table of states per region
table(murders$region)

#Say we want to rank the states from least to most gun murders. The function sort sorts a vector in increasing order. We can therefore see the largest number of guns murders by:

sort(murders$total)
#However this doe snot give us information about which state had 1257 murders. How to do it?
#First we obtain the index that orders the vectors of the data frame according to murders total. Therefore, we index the states names vector
ind<-order(murders$total)
murders$state[ind]
#According to this, California has the most murders
#If we are only interested in the entry with largest number of murders,
max(murders$total)
#and for the index of the largest value
i_max<-which.max(murders$total)
murders$state[i_max]
#For the minimum,
min(murders$total)
i_min<-which.min(murders$total)
murders$state[i_min]
#We can also find out which state has the largest population
murders$state[which.max(murders$population)]
max(murders$population)
#Create a data frame :
temp<-c(35, 88, 42, 84, 81, 30)
city<-c("Beijing","Lagos","Paris","Rio de Janeiro","San Juan","Toronto")
city_temps<-data.frame(Name=city, Temperature=temp)

#Use the rank function to determine the temperature rank of each state from smallest popultaion to biggest. Save these ranks in an object called ranks, then crate a data frame called my_df with the state name and the rank
ranks<-rank(murders$population)
my_df<-data.frame(Name=murders$state, rank=ranks)
my_df
#Repeat the same but this time reorder the states from least to most populous. 
ind<-order(murders$population)
states2<-murders$state[ind]
ranks2<-ranks[ind]
my_df<-data.frame(Name=states2, rank=ranks2)
my_df

#Determine the class of a vector generated with seq using the length.out argument.
#Specifically, what is the class of the following object a <- seq(1, 10, length.out = 100)?
  
#-------------arithmetics with vectors-----------------------

#Find the 100000% murder rates in the data set
murder_rate<-100000*murders$total/murders$population
#Now we can reorder the states by increasing murder rate, and check that California is by far not the most dangerous state:
murders$state[order(murder_rate)]
#Or, in decreasing order of murder rate,
murders$state[order(murder_rate,decreasing=TRUE)]

#--------Indexing-------------------
#Compute the per 100,000 murder rate for each state and store it in an object called murder_rate.
#Then use the logical operators to create a logical vector, name it low, that tells us which entries of murder_rate are lower than 1, and which are not, in one line of code.

murder_rate<-10000*murders$total/murders$population
low<-murder_rate<1
#Use the results from the previous exercise and the function which to determine the indices of murder_rate associated with values lower than 1.
which(low,murder_rate)
#Use the results from the previous exercise to report the names of the states with murder rates lower than 1, using the square brackets to retrieve the names of the states from the dataset.
murders$state[low]
#Now we will extend the code from the previous exercises to report the states in the Northeast with a murder rate lower than 1.
ind<-(murders$region=="Northeast")&low
murders$state[ind]
#How many states are below the average?
sum(murder_rate<mean(murder_rate))

#In this exercise we use the match function to identify the states with abbreviations AK, MI, and IA.
# Store the 3 abbreviations in a vector called `abbs` (remember that they are character vectors and need quotes)
abbs<-c("AK","MI","IA")
# Match the abbs to the murders$abb and store in ind
ind<-match(abbs,murders$abb)
# Print state names from ind
murders$state[ind]

