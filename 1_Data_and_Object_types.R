#--------------1.BASIC INTRODUCTION TO R-------------------------------

#---------------------------Load libraries------------------------------
library(tidyverse)




#----------names of objects must be meaningful, though concise----------
solution1<-(-b+sqrt(b^2-4*a*c))/(2*a)
solution2<-(-b-sqrt(b^2-4*a*c))/(2*a)
N<-1000
sum_of_N_first_naturals<-N*(N+1)/2
x<-seq(1,N)
sum(x)
?seq
#---the function modulo, %% gives the remainder of the left number when divided by the right one
7%%3

#-------------------------2.DATA TYPES------------------------------

#---Data and variables can be one of the following types or atomic classes: integer, numeric (real numbers), complex,character or logic
#---You can check the data type of a variable with the class() function---
my_character <- "universe"
class(my_character)
a<-2
class(a)
#Comment: by default, numbers are assigned class numeric even when they are round integers. For example, class(1) returns numeric. 
#you can turn them into integer class with as.integer() function or by adding and L like this: 1L
class(2L)
z<-3==2
z
class(z)
#in the console, you see this is an integer and not a numeric. For most practical purposes, integers and 
#numerics are indistinguishable. For example 3, the integer, minus 3 the numeric is 0. To see this type this in the console

3L - 3
#The main difference is that integers occupy less space in the computer memory, so for big computations using integers can have a substantial impact.
#R has other special numbers
Inf
pi


#----------------------3.DATA OBJECTS-------------------------------

#Data objects can be vectors, matrices, data frames, factors, or lists


#---------------------------3.1VECTORS-----------------------------------
#The most basic object in R
#In R, you can create a vector with the combine function c(). You place the vector elements separated by a comma between the parentheses. For example:
#All elements from a vector must be of the same class
my_first_vector<-c(1,2,3)
my_second_vector<-c(1, 1, 1, 2, 5, 7, 9, 2, 5)
boolean_vector<-c(TRUE,FALSE,TRUE)
character_vector<-c("italy","canada", "spain")
#we can use the vector() function when initializing a vcetor
vector("numeric", length=5)
#single quote is also accepted for characters. Watch out not to confuse with back quote `´`
country_vector<-c('U.S.A','U.S.S.R','China')

#After defining a vector, you can give a name to the elements of a vector with the names() function. Have a look at this example:
some_vector<-c("john Paxter","poker player")
names(some_vector)<-c("Name","Profession")
print(some_vector)
some_vector

#Names can also be assigned initially in the definition of a vector. with quotes, with single quotes or without. Does no matter:
number_of_victories_vector<-c(italy=28, canada= 12, spain=17)
number_of_victories_vector
number2<-c(italy=28, "canada"= 12, 'spain'=17)
number2
names(number_of_victories_vector)
class(number_of_victories_vector)
#dim() function gives the dimensions of an object
#Each object in R has metadata associated, which can be explored with the attrbiutes function. Beware since not all objects have attributes
attributes(number2)
#seq generates also vectors First argument defines the start, the second the end of the sequence. By defaults the sequence jumps 1 unit, but a third argument can change the jump distance:
seq1<-seq(1,10)
seq2<-seq(1,12,2)
2:11
#R produes integers with seq function
class(seq1)
# Also generates numeric data types
class(seq(1,5,0.5))
#The seq() function has another useful argument. The argument length.out. This argument lets us generate sequences that are increasing by the same amount but are of the prespecified length.
#For example, this line of code
x <- seq(0, 100, length.out = 5)
#produces the numbers 0, 25, 50, 75, 100. 

#--------3.1.1arithmetics in vectors-----------------

#R operations on vectors occur element wise.
#sum() calculates the sum of all elements of a vector
sum(my_first_vector)
#if the vector is logical, sum() calculates the total number of true entries
inches<-c(69, 62, 66, 70, 66)
cms<-2.54*inches
cms
inches-69
#Calculate the average of the values with the mean() function.
mean(my_first_vector)
#Take a vector and return the frequency of each element
table(my_second_vector)
my_second_vector
#If we have two vectors of the same length, R will add them entry by entry. The same holds for - * and /

# -----3.1.2-Selecting elements from vectors---------------

#To select elements of a vector (and later matrices, data frames, …), you can use square brackets. Between the square brackets, you indicate what elements to select.
character_vector[2]
#To select multiple elements from a vector, you can add square brackets at the end of it. You can indicate between the brackets what elements should be selected.
character_vector[c(1,3)]
#Selecting multiple elements of poker_vector with c(2, 3, 4) is not very convenient. Many statisticians are lazy people by nature, so they created an easier way to do this: c(2, 3, 4) can be abbreviated to2:4
character_vector[2:3]
#Another way to tackle the previous exercise is by using the names of the vector element
some_vector["Profession"]
number_of_victories_vector[c("italy","spain")]

#-------------------------3.1.3-coercion-------------------------------
#When an entry does not match the expected, R tries to guess what was meant before throwing a error. This is coercion
#Sometimes it creates confussion. For exmple, since we know that all the elements of a vector must have the same data type, the following vector would result in an error
x<-c("canada",3)
#However, R coerces the value of 3 to a character, to avoid the error
class(x)
#The fact that R does not even warn, can cause many unnoticed errors in R.
#Explicit coercion
#We can avoid issues with coercion in R by changing characters to numerics and vice-versa. This is known as typecasting.
x<-1:5
y<-as.character(x)
w<-as.numeric(y)
as.logical
as.integer



#--------------------------------------NAs------------------------------------
#When R tries to coerce one type to another and encounters no possibility, it gives an error and NA
x<-c("1","b","3")
as.numeric(x)
#The na_example vector represents a series of counts. You can quickly  examine the object
data("na_example")
str(na_example)
#However, when computing the average it gives an error
mean(na_example)

#The is.na function returns a logical vector that tells us which entries are NA. Assign this logical vector to an object called ind and determine how many NAs does na_example have
ind<-is.na(na_example)
ind
factors_na_example<-factor(ind)
#The following function gives us the number of true, i.e., the number of NAs
summary(factors_na_example)
#To calculate the average of na_example,
na_ex<-na_example[order(ind)]

non_na<-na_ex[1:855]
mean(non_na)
#Na is not the same as NAN. The latter stands for when a undefined quantity is represented
#is.na is used to test if objects if they are NA
#is.nan is used to test if objects if they are NAN

#---------------------------3.1.3-recycling------------------------
#Vectors add elementwise. If we add two vectors of different length, R fills the shorter one by recycling its elements:
x<-c(1,2,3)
y<-c(10, 20, 30, 40, 50, 60, 70)
x+y

#-------------------3.1.4 Indexing--------------------------------
#We work with the murders database
library(dslabs)
data("murders")
murder_rate<-100000*murders$total/murders$population
#In R we can use logicals to index vectors. If we compare a vector to a single number, it actually performs the test for each entry
ind<-murder_rate<0.71
ind     
#we can employ any comparison operator: <, <=, >, >=, ==, !=
#To se which states have less murder rate than 0.71, we can leverage  the fact that the vectors can be indexed with logicals:
murders$state[ind]
#To count how many are true, we use the function sum(), knowing that R coerces TRUE to 1 and FALSE to 0
sum(ind)

#Therefore, we can come back to the na_example case and solve the problem in a simpler way we did
ind<-is.na(na_example)
#the total number of TRUES is the same as the number of Nas, given by
sum(ind)
#Removing Nas. When using a logic index, it only takes into account the true values
nna_example<-na_example[!ind]

mean(nna_example)
#Function which tells us which entries of a logical vector are TRUE
ind<-which(murders$state=="California")
murder_rate[ind]
#The function match tells us which indexes of a second vector match each of the entries of a first vector
ind<-match(c("New York","Florida", "Texas"),murders$state)
ind
# so the murder rates of these three states are:
murder_rate[ind]

#Indexing with Logical operators.& (AND),| OR,!NOT, ...Suppose we want a murder rate less than 1, and we want to live in the west region
west<-murders$region=="West"
safe<-murder_rate<1
ind<-safe&west
murders$state[ind]

#If rather than an index vector que want a logical that tells us if each element of a first vector appear in a second vector, we use %in%. For example, to check that Boston and Dakota are states,
c("Boston", "Dakota")%in%murders$state
#match and %in% are related via which:
match(c("New York","Florida"),murders$state)
which(murders$state%in%c("New York", "Florida"))

#---------------------------3.2-MATRICES------------------------------------#

#create a matrix. The first argument is the collection of elements that R will arrange into the rows and columns of the matrix.
# byrow indicates that the matrix is filled by the rows. nrow indicates that the matrix should have three rows
my_matrix<-matrix(1:9, byrow = TRUE, nrow=3)
#DEfine a matrix specifying the number of rows and columns
mat<-matrix(1:12, 4,3)
matrix(nrow=2,ncol=3)
#dim() function gives the dimensions of an object
dim(my_matrix)
attributes(my_matrix)

#Similar to vectors, you can add names for the rows and the columns of a matrix
row_names_vector<-c("apples","bananas","figs")
col_names_vector<-c("Paul","Michael","Richard")
rownames(my_matrix) <- row_names_vector
colnames(my_matrix) <- col_names_vector
#another posibbility is
dimnames(my_matrix)<-list(row_names_vector,col_names_vector)
my_matrix
#All elements from a vector must be of the same data type
class(my_matrix)
#In R, the function rowSums() conveniently calculates the totals for each row of a matrix. This function creates a new vector.
total_fruits<-rowSums(my_matrix)
names(total_fruits)<-c("Apples","Bananas","Figs")
total_fruits
#In R, the function colSums() conveniently calculates the totals for each column of a matrix.
total_each_person<-colSums(my_matrix)
names(total_each_person)<-col_names_vector
total_each_person

#You can add a column or multiple columns to a matrix with the cbind() function, big_matrix <- cbind(matrix1, matrix2, vector1 ...)
pinneapple_vector<-c(2,0,3)
pinneapple<-matrix(pinneapple_vector, byrow = FALSE, ncol = 3)

big_matrix<-rbind(my_matrix, pinneapple)
row_names_bigmat_vector<-c("apples","bananas","figs","bananas")
rownames(big_matrix)<-row_names_bigmat_vector
big_matrix
pinneapple_vector
#You can add row or multiple rows to a matrix with the rbind() function
# Similar to vectors, you can use the square brackets [ ] to select one or multiple elements from a matrix. 

big_matrix[3,2]
big_matrix[1:2,3]
#If you want to select all elements of a row or a column, no number is needed before or after the comma, respectively:
# big_matrix[,1] selects all elements of the first column.
big_matrix[,1]
# big_matrix[1,] selects all elements of the first 
big_matrix[1,]

#-----------------------3.3-FACTORS-----------------------------------

#The term factor refers to a statistical data type used to store categorical variables. The difference between a categorical variable and a continuous variable is that a categorical variable can belong to a limited number of categories. A continuous variable, on the other hand, can correspond to an infinite number of values.

#It is important that R knows whether it is dealing with a continuous or a categorical variable, as the statistical models you will develop in the future treat both types differently.
#To create factors in R, you make use of the function factor(). First thing that you have to do is create a vector that contains all the observations that belong to a limited number of categories.
random_vector<-c(1,2,1,5,6,2,6,5)
factors_random_vector<-factor(random_vector)
factors_random_vector
read.table() creates factors automatically from datasets
#There are two types of categorical variables: a nominal categorical variable and an ordinal categorical variable.
#A nominal variable is a categorical variable without an implied order. This means that it is impossible to say that 'one is worth more than the other'. For example, think of the categorical variable animals_vector with the categories "Elephant", "Giraffe", "Donkey" and "Horse". Here, it is impossible to say that one stands above or below the other. (Note that some of you might disagree ;-) ).
animal_vector<-c("Elephant", "Lion", "Wolf","Rhinoceront")
factors_animal_vector<-factor(animal_vector)
factors_animal_vector
#In contrast, ordinal variables do have a natural ordering. Consider for example the categorical variable temperature_vector with the categories: "Low", "Medium" and "High"
temperature_vector<-c("medium", "low","high","low","high")
factors_range_of_temperatures<-factor(temperature_vector,order = TRUE, levels = c("low", "medium", "high"))
factors_range_of_temperatures
#When you first get a data set, you will often notice that it contains factors with specific factor levels. However, sometimes you will want to change the names of these levels for clarity or other reasons. R allows you to do this with the function levels():
#levels(factor_vector) <- c("name1", "name2",...)
#A good illustration is the raw data that is provided to you by a survey. A common question for every questionnaire is the sex of the respondent. Here, for simplicity, just two categories were recorded, "M" and "F". (You usually need more categories for survey data; either way, you use a factor to store the categorical data.)
#survey_vector <- c("M", "F", "F", "M", "M")
#Recording the sex with the abbreviations "M" and "F" can be convenient if you are collecting data with pen and paper, but it can introduce confusion when analyzing the data. At that point, you will often want to change the factor levels to "Male" and "Female" instead of "M" and "F" for clarity.
#Watch out: the order with which you assign the levels is important. If you type levels(factor_survey_vector), you'll see that it outputs [1] "F" "M". If you don't specify the levels of the factor when creating the vector, R will automatically assign them alphabetically. To correctly map "F" to "Female" and "M" to "Male", the levels should be set to c("Female", "Male"), in this order.
survey_vector <- c("M", "F", "F", "M", "M")
factor_survey_vector <- factor(survey_vector)
levels(factor_survey_vector)
levels(factor_survey_vector)<-c("Female","Male")
factor_survey_vector
#After finishing this course, one of your favorite functions in R will be summary(). This will give you a quick overview of the contents of a variable
summary(animal_vector)
summary(factor_survey_vector)  
summary(survey_vector)
#Since "Male" and "Female" are unordered (or nominal) factor levels, R returns a warning message, telling you that the greater than operator is not meaningful. As seen before, R attaches an equal value to the levels for such factors.
#But this is not always the case! Sometimes you will also deal with factors that do have a natural ordering between its categories. If this is the case, we have to make sure that we pass this information to R…
#Let us say that you are leading a research team of five data analysts and that you want to evaluate their performance. To do this, you track their speed, evaluate each analyst as "slow", "medium" or "fast", and save the results in speed_vector.
# Create speed_vector
speed_vector <-c("medium","slow","slow","medium","fast")
#speed_vector should be converted to an ordinal factor since its categories have a natural ordering. By default, the function factor() transforms speed_vector into an unordered factor. To create an ordered factor, you have to add two additional arguments: ordered and levels.
factor_speed_vector <-factor(speed_vector,ordered=TRUE,levels=c("slow","medium","fast"))
factor_speed_vector
summary(factor_speed_vector)
#Comparing ordered factors
# Factor value for second data analyst
da2 <-factor_speed_vector[2]

# Factor value for fifth data analyst
da5 <-factor_speed_vector[5]

# Is data analyst 2 faster than data analyst 5?
da2>da5


#-----------------3.4-DATA FRAMES---------------------------

#The most common way of storing a dataset in R is in a data frame. It is a table with rows representing observations and the different variables or predictors reported for each observation define the columns.
#Data frames are particularly interesting for datasets because we can define different data types into one object.

#dplyr package has an optimized set of functions designed to work efficiently with data frames. ggplot2 works best with data stored in data frames

#-------In R there are data sets included for the users to practice-------
data()

#-------for instannce-----
CO2

#Difference from matrix is that a data frame entries can be of different data type, while in matrices all entries must be of the same data type, the same as for vectors.

#You may remember from the chapter about matrices that all the elements that you put in a matrix should be of the same type. Back then, your data set on Star Wars only contained numeric elements.
#When doing a market research survey, however, you often have questions such as:
#'Are you married?' or 'yes/no' questions (logical)
#'How old are you?' (numeric)
#'What is your opinion on this product?' or other 'open-ended' questions (character)
#The output, namely the respondents' answers to the questions formulated above, is a data set of different data types. You will often find yourself working with data sets that contain different data types instead of only one.
#A data frame has the variables of a data set as columns and the observations as rows. This will be a familiar concept for those coming from different statistical software packages such as SAS or SPSS.
mtcars
#Wow, that is a lot of cars!
#Working with large data sets is not uncommon in data analysis. When you work with (extremely) large data sets and data frames, your first task as a data analyst is to develop a clear understanding of its structure and main elements. Therefore, it is often useful to show only a small part of the entire data set.
#So how to do this in R? Well, the function head() enables you to show the first observations of a data frame. Similarly, the function tail() prints out the last observations in your data set.
#Both head() and tail() print a top line called the 'header', which contains the names of the different variables in your data set.
head(mtcars)
tail(mtcars)
#Another method that is often used to get a rapid overview of your data is the function str(). The function str() shows you the structure of your data set. For a data frame it tells you:
#The total number of observations (e.g. 32 car types)
#The total number of variables (e.g. 11 car features)
#A full list of the variables names (e.g. mpg, cyl … )
#The data type of each variable (e.g. num)
#The first observations
str(mtcars)
#Data frames can be built from datasets with the following functions
read.table()
read.csv()
#creating your own data sets: As a first goal, you want to construct a data frame that describes the main characteristics of eight planets in our solar system. According to your good friend Buzz, the main features of a planet are:

#The type of planet (Terrestrial or Gas Giant); The planet's diameter relative to the diameter of the Earth; The planet's rotation across the sun relative to that of the Earth.
#If the planet has rings or not (TRUE or FALSE).
#After doing some high-quality research on Wikipedia, you feel confident enough to create the necessary vectors: name, type, diameter, rotation and rings; these vectors have already been coded up in the editor. The first element in each of these vectors correspond to the first observation.

name <- c("Mercury", "Venus", "Earth", 
          "Mars", "Jupiter", "Saturn", 
          "Uranus", "Neptune")
type <- c("Terrestrial planet", 
          "Terrestrial planet", 
          "Terrestrial planet", 
          "Terrestrial planet", "Gas giant", 
          "Gas giant", "Gas giant", "Gas giant")
diameter <- c(0.382, 0.949, 1, 0.532, 
              11.209, 9.449, 4.007, 3.883)
rotation <- c(58.64, -243.02, 1, 1.03, 
              0.41, 0.43, -0.72, 0.67)
rings <- c(FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE)
#You construct a data frame with the data.frame() function. As arguments, you pass the vectors from before: they will become the different columns of your data frame. Because every column has the same length, the vectors you pass should also have the same length. But don't forget that it is possible (and likely) that they contain different types of data.
planets_df<-data.frame(name,type,diameter,rotation,rings)
planets_df
attributes(planets_df)


#By default, data.frame turns characters into characters
grades<-data.frame(names=c("John", "Juan","Jean", "Yao"), exam_1=c(95, 80, 90, 85), exam_2=c(90, 91, 65, 13))
class(grades$names)
#To turn characters into factors we use the function stringsAsFactors
grades<-data.frame(names=c("John", "Juan","Jean", "Yao"), exam_1=c(95, 80, 90, 85), exam_2=c(90, 91, 65, 13), stringsAsFactors = TRUE)
class(grades$names)

#Selecting from data frames
planets_df[1,1]
planets_df[1:2,3]
#a whole column
planets_df[,3]
#Instead of using numerics to select elements of a data frame, you can also use the variable names to select columns of a data frame.
#Suppose you want to select the first three elements of the type column. One way to do this is
planets_df[1:3,2]
#A possible disadvantage of this approach is that you have to know (or look up) the column number of type, which gets hard if you have a lot of variables. It is often easier to just make use of the variable name:
planets_df[1:3,"type"]
planets_df[1:5,"diameter"]
#You will often want to select an entire column, namely one specific variable from a data frame. If you want to select all elements of the variable diameter, for example, both of these will do the trick:
planets_df[,3]
planets_df[,"diameter"]
#However, there is a short-cut. If your columns have names, you can use the $ sign:
planets_df$diameter
# The code shows the names for planets with rings
rings_vector<-planets_df$rings
rings_vector
planets_df[rings_vector, "name"]
# Adapt the code to select all columns for planets with rings
planets_df[rings_vector, ]
#Now, let us move up one level and use the function subset(). You should see the subset() function as a short-cut to do exactly the same as what you did in the previous exercises. 
#subset(my_df, subset = some_condition)
#The first argument of subset() specifies the data set for which you want a subset. By adding the second argument, you give R the necessary information and conditions to select the correct subset. 
subset(planets_df,subset=rings)
#Now we select data from the frame for planets with no rings
subset(planets_df,subset=!rings)
# Select planets with diameter < 1
subset(planets_df,subset=(diameter<1))

#Transform a matrix in a data frame
mat<-matrix(1:12,4,3)
mat_df<-as.data.frame(mat)

class(mat)
class(mat_df)

murders[2:3,]
#data frames can be coerced to matrices using
data.matrix()
#instead of
as.matrix()
#Functions for naming data frames are
#for rows
row.names()
#for columns:
names()
#---------------------------3.5-LISTS-------------------------------------

#A list in R allows you to gather a variety of objects under one name (that is, the name of the list) in an ordered way.
#hese objects can be matrices, vectors, data frames, even other lists, etc. It is not even required that these objects are related to each other in any way.

#You could say that a list is some kind super data type: you can store practically any piece of information in it!
#Let us create our first list! To construct a list you use the function list():

#my_list <- list(comp1, comp2 ...)
#The arguments to the list function are the list components. Remember, these components can be matrices, vectors, other lists, …
# Vector with numerics from 1 up to 10
my_vector <- 1:10 
my_vector

# Matrix with numerics from 1 up to 9
my_matrix <- matrix(1:9, ncol = 3)
my_matrix

# First 10 elements of the built-in data frame mtcars
my_df <- mtcars[1:10,]
my_df

# Construct list with these different elements:
my_list <-list(my_vector, my_matrix, my_df)
my_list
#Just like on your to-do list, you want to avoid not knowing or remembering what the components of your list stand for. That is why you should give names to them: 
my_list2<-list(vec=my_vector, mat=my_matrix,df=my_df)
my_list2
#If you want to name your lists after you've created them, you can use the names() function as you did with vectors. 
names(my_list)<-c("vec","mat","df")
my_list
#We can create an empty list from vector() function
vector("list", length=5)

#Selecting elements from a list
#Your list will often be built out of numerous elements and components. Therefore, getting a single element, multiple elements, or a component out of it is not always straightforward.
#One way to select a component is using the numbered position of that component. For example, to "grab" the first component of my_list you type 
my_list[[1]]
#You can also refer to the names of the components, with [[ ]] or with the $ sign. 
my_list[["mat"]]
my_list$df
#Besides selecting components, you often need to select specific elements out of these components. For example
my_list[[3]][1,]
my_list$df[1,1]
my_list[["df"]][,1]


#---------------------------3.6-SORTING----------------------------------------

#Making and creating rankings is one of mankind's favorite affairs. These rankings can be useful (best universities in the world), entertaining (most influential movie stars) or pointless (best 007 look-a-like).
#In data analysis you can sort your data according to a certain variable in the data set. In R, this is done with the help of the function order().
#sort() is a function that sorts a vector in increasing order
a <- c(100, 10, 1000)
sort(a)
#order() is a function that gives you the ranked position of each element when it is applied on a variable, such as a vector for example:

order(a)
#10, which is the second element in a, is the smallest element, so 2 comes first in the output of order(a). 100, which is the first element in a is the second smallest element, so 1 comes second in the output of order(a).
#This means we can use the output of order(a) to reshuffle a:
a[order(a)]
#The function order helps to what we want. It takes a vector as an input and returns the vector of indexes that sorts the input vector
x<-c(31,4,15,92,65)
index<-order(x)
x[index]
#order gives by default the increasing ordering. but, one can define a decreasing ordering if needed
x[order(x,decreasing=TRUE)]
#The function order() returns the index vector needed to sort the vector. This implies that sort(x) and x[order(x)] give the same result.

sort(x)

#You would like to rearrange your data frame such that it starts with the smallest planet and ends with the largest one. A sort on the diameter column.
positions<-order(planets_df$diameter)
planets_df[positions,]

#The functions min() and max() gives the smallest or largets entries of a vector. which.min() and which.max() gives the index of the smallest and largest entry respectively
min(planets_df$diameter)
i_min<-which.min(planets_df$diameter)
planets_df$name[i_min]
max(planets_df$diameter)
i_max<-which.max(planets_df$diameter)
planets_df$name[i_max]

#For any given vector, rank(x) returns a vector with the rank of the first entry, the second, and so on, from lowest to highest
x<-c(31, 4, 15, 92, 65)

rank(x)
#rank(-x) gives us the ranks of x from highest to lowest
rank(-x)
