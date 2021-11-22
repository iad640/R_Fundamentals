#----------IFELSE--------------
#The function nchar tells you how many characters long a character vector is. For example:

char_len <- nchar(murders$state)
tail(char_len)
murders$state
#The function ifelse is useful because you convert a vector of logicals into something else. For example, some 
#datasets use the number -999 to denote NA. A bad practice! You can convert the -999 in a vector to NA using the following ifelse call:

x <- c(2, 3, -999, 1, 4, 5, -999, 3, 2, 9)
ifelse(x == -999, NA, x)
#If the entry is -999 it returns NA, otherwise it returns the entry.

#We will combine a number of functions for this exercise.

#Use the ifelse function to write one line of code that assigns to the object new_names the state abbreviation when the 
#state name is longer than 8 characters and assigns the state name when the name is not longer than 8 characters.

#For example, where the original vector has Massachusetts (13 characters), the new vector should have MA. But where the 
#original vector has New York (8 characters), the new vector should have New York as well.
new_names<-ifelse(nchar(murders$state)>8,murders$abb,murders$state)

#-----------DEFINING MY OWN FUNCTION--------------
#We will define a function sum_n for this exercise.

#Create a function sum_n that for any given value, say n, creates the vector 1:n, and then computes the sum of the integers from 1 to n.
#Use the function you just defined to determine the sum of integers from 1 to 5,000.
# Create function called `sum_n`
sum_n<-function(x){
  y<-1:x
  sum(y)
}
# Use the function to determine the sum of integers from 1 to 5000
sum_n(5000)

#We will make another function for this exercise. We will define a function altman_plot that takes two arguments x and y and plots the 
#difference y-x in the y-axis against the sum x+y in the x-axis. 
altman_plot<-function(x,y){
  plot(x+y,y-x)
}

#--------------------------------LEXICAL SCOPING------------------------------
#Lexical scoping is a convention used by many languages that determine when an object is available by its name. When you run the code below 
#you will see which x is available at different points in the code.

x <- 8
my_func <- function(y){
  x <- 9
  print(x)
  y + x
}
my_func(x)
print(x)

#Note that when we define x as 9, this is inside the function, but it is 8 after you run the function. The x changed 
#inside the function but not outside.

#---------------------------------FOR LOOPS----------------------------------
# Here is an example of a function that adds numbers from 1 to n
example_func <- function(n){
  x <- 1:n
  sum(x)
}

# Here is the sum of the first 100 numbers
example_func(100)

# Write a function compute_s_n with argument n that for any given n computes the sum of 1 + 2^2 + ...+ n^2
compute_s_n<-function(n){
  x<-1:n
  y<-x^2
  sum(y)
}


#this code generates the same function
compute_s_n <- function(n){
  x <- 1:n
  sum(x^2)
}

#Compute the the sum when n is equal to each integer from 1 to 25 using the function we defined in the previous exercise

s_n <- vector("numeric", 25) # Create a vector for storing results

# write a for-loop to store the results in s_n
for(i in 1:25){
  s_n[i]=compute_s_n(i)
}

compute_s_n(10)# Report the value of the sum when n=10

#If we do the math, we can show that a plot of s_n versus n should look cubic. Let's make this plot.
plot(n,s_n)

#Now, let's chechk that we had the same identical answer than using the formula from maths:
identical(s_n,n*(n+1)*(2*n+1)/6)

       