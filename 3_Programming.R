#--------------------------CONDITIONALS-------------------------------
#Example of if clause: print the reciprocal of a unless it is zero:
a<-3
if(a!=0){
  print(1/a)
}else{
  print("No reciprocal for 0.")
}
#The general form of an if statement is:
#if(boolean condition){
#expressions
#}else{
#  alternative expressions
#}
#Let's do another example for the US murders data frame
library(dslabs)
data("murders")
murder_rate<-murders$total/murders$population*10^5
#Let's find if the smallest murder rate is lower than 0.5
ind<-which.min(murder_rate)

if(murder_rate[ind]<0.5){
  print(murders$state[ind])
}else{
  print("No state has murder rate lower than the predefined")
}
#If we try again with 0.25 the answer changes
if(murder_rate[ind]<0.25){
  print(murders$state[ind])
}else{
  print("No state has murder rate lower than the predefined")
}

#A related function is ifelse, that takes three arguments: an argument and two possible answers. If the logical is true,
#the secondargument is returned. If it is false, the third argument is returned
a<-0
ifelse(a!=0,1/a, NA)
a<-c(0,1,2,-4,5)
ifelse(a>0,1/a,NA)
#This function can be used to replace all the missing values in a vector with zeros:
data(na_example)
#there are 145 Nas in the na_example
sum(is.na(na_example))
#We can remove these Nas:
no_nas<-ifelse(is.na(na_example),0,na_example)
#We check we have removed the Nas
sum(is.na(no_nas))

#Two other useful functions are any and all. The any function takes a vector of logicals and returns TRUE if any of the entries is TRUE.
z<-c(TRUE,TRUE,FALSE)
w<-c(FALSE,FALSE,FALSE,FALSE)
any(z)
any(w)
#The all function takes a vector of logicals and returns TRUE if all the entries are TRUE:
all(z)
all(w)
all(c(TRUE,TRUE))

#----------------------tidyverse conditionals------------------------------
#we are seeing here conditionals from the purrr package, included in the tidyverse package

# The case_when function is useful for vectorizing conditional statements. It is similar to ifelse but can output any number of values,
#opposed to just TRUE or FALSE. Here there is an example splitting numbers into negative, positive or 0
x<-c(-2, -1, 0, 1, 2)


case_when(x <0 ~"Negative", x>0 ~"Positive", TRUE~"zero")
#A common use of this function is to define categorical variables based on existing variables.
#For example, suppose we want to compare the murder rates in three groups of states: New England, West Coast, South and other
murders %>% mutate(group = case_when(abb %in% c("ME", "NH", "VT", "MA", "RI", "CT")~"New England", abb %in% c("WA", "OR", "CA") ~ "West Coast", region == "South" ~ "South", TRUE ~"Other")) %>% group_by(group) %>% summarize(rate=sum(total)/sum(population)*10^5)
#------------between
#A common operation is to determine if a value falls inside an interval. We can check this using conditionals like:
#x>=a & x<=b
#Or we can use a between function
#between(x, a, b)
x<-3
between(x, 1, 7)

#------------DEFINING FUNCTIONS-----------------------------------
#lET'S WRITE AN EXAMPLE OF FUNCTION DEFINITION IN r. tHE FOLLOWING FUNCTION COMPUTES THE AVERAGE OF A VECTOR

avg<-function(x){
  s<-sum(x)
  n<-length(x)
  s/n
}
x<-1:100
#Let's check that the function we have defined is the same as mean()
identical(mean(x),avg(x))
#Note that variables defined inside a function are not saved in the workspace
#The general form of function definition is:
#my_function<-function(VARIABLE_NAME){
# perform operations on VARIABLE_NAME and calculate VALUE
# VALUE
#}
#The functions can have multiple arguments as well as default values.
#my_function<-function(x,y,z){
# perform operations on x,y,z and calculate VALUE
# VALUE
#}

#For example,we can define a function that computes either the geometric mean or the arithmetic 
#mean of an argument x depending on the value of the argument"arithmetic" 
avg<-function(x,arithmetic=FALSE){
  n<-length(x)
  ifelse(arithmetic,sum(x)/n,prod(x)^(1/n))
}
avg(x)

avg<-function(x,arithmetic=TRUE){
  n<-length(x)
  ifelse(arithmetic,sum(x)/n,prod(x)^(1/n))
}
avg(x)
#-----------------------------NAMESPACES----------------------------------
#Some packages have functions with the same name. For example, there is a filter function in dplyr, and another filter function in stats package. Each of them live in different namespaces. 
#Therefore, when we call for one of such functions, R follows a certain order when searching a function in these namespaces
#We can chech that order with the following function:
search()
#We can force R to use a specific name space by using :: like this
stats::filter
?filter
#To be sure we use filter from dplyr package,
dplyr::filter

#-------------------------------FOR LOOPS---------------------------------
#When we want to perform the same taks over and over again, we use the for loop. For-loops allows us to define the range that our variable takes
#(in our example from 1 to 10), then change the value and evaluate expression as you loop
for(i in 1:5){
  print(i)
}
#The general formula is
for(i in  range of values ){
  operations that use i, which is changing accross the range of values
}

#Another example: if we want to compute the sum of the first  n integers, changing n from 1 to 25:
compute_s_n<-function(n){
  x<-1:n
  sum(x)
}

m<-25
s_n<-vector(length=m)#cretaes an empty vector
for(n in 1:m){
  s_n[n]<-compute_s_n(n)
}
s_n
n<-1:m
plot(n,s_n)

#----------------------VECTORIZATION AND FUNCTIONALS---------------------------
#Since vector arithmetics operate element wise, we can do repeated operations in vectors rather than using for loops.
#For example,
x<-1:10
sqrt(x)
y<-1:10
x*y
#However, other functions do not work element-wise , for example the function compute_s_n since it expects to operate with a scalar
n<-1:25
compute_s_n(n)
#Functionals are functions that help us apply the same function to  each entry in a vector, matrix, data frame or list.
#HEre we cover the functional that operates on numerica, logical and character vectors: sapply
n<-1:25
s_n<-sapply(n,compute_s_n)
s_n
#Each element of n passes on to the compute_s_n function and returns the result. The result is a vector that gives the
# value of the function for each value of the entry vector. Anpother example:
x<-1:10
sapply(x, sqrt)
