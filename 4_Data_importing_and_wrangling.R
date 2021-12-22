#--------------------1.-IMPORTING DATA from spreadsheets -------------------------
#How to read a file that is in our PC. 

#To open a file, we need to know its path. A way to know the full path, relative to the root directory is:
library(dslabs)
dir<-system.file(package="dslabs")
filename<-"murders.csv"
file.path(dir, filename)
#The function system.file provides the full path of the folder containing all the directories relevant to the package specified
#by the package argument. We rarely will use this function since we do not usually have data in packages
#The function file.path is used to combine directory names to produce full path of the file we want to import
#We can use list.files to see examples of relative paths from working directory. IS like ls() in git bash terminal
#The system.file function permit us to provide a subdirectory as first argument, so we can obtain the full path of extdata direcvtory like this

dir<-system.file("extdata", package="dslabs")
list.files(path=dir)

#This give us the location of files or directories if we start in the directory with the full path.
#Or, for the working directory
list.files()

#Always work with relative paths. For that, start definig a variables called wd that stores the current working directory,
#and the rest of the code will be based on the wd
wd<-getwd()
#We can also know the wd with terminal, by typing pwd
#We can change the working directory with session panel from rstudio, or with with setwd(path)
#If the path does not start with /, R interprets that this is a relative path. If the path starts with /, it is interpreted as a full path from the root directory
setwd(dir = "projects/R_Fundamentals/")

#------------------1.1.-COPYING FILES------------------------------------
#It is always important to copy files to the working directory, to have always relative paths
#We do this with the file.copy function. This function copies the file from the path in the first argument
#to our home directory with the name given in the second argument
#For example:
dir<-"/Users/LENOVO/Documents/Libros/Gupta SQC/Gupta_Online_SQC_Data_folder/Online -SQC-Data folder/Example 3.2.csv"
file.copy(dir, "Example_3.2.csv")
list.files()
#--------------The readr and readxl packages---------------------
#We use here the murders.csv file provided by the dslabs package
filename<-"murders.csv"
dir<-system.file("extdata", package="dslabs")
fullpath<-file.path(dir, filename)
file.copy(fullpath, "murders.csv")
list.files()

#The readr library includes functions for reading data stored in text file spreadsheets into R. It is part of the tidyverse
#To know which function from readr we must use, we need to know which kind of file is it: csv, txt, etc. 
#For this, we need to open it looking at few lines:
read_lines("murders.csv", n_max=3)
#Now, that we know it is comma separated files, we can read the full file with the corresponding function:
dat<-read_csv(filename)

#Note that we can confirm that the data has in fact been read-in
View(dat)

#Examples from pp 80 of INTRODUCTION TO DATA SCIENCE IN R
path<-system.file("extdata", package="dslabs")
files<-list.files(path)
files
filename<-"olive.csv"
filepath<-file.path(path,filename)
read_lines(filepath,n_max=2)
data<-read_csv(filepath, header=FALSE)
View(data)
?read_csv
read_lines(filepath,n_max=1)
#-------------------Downloading files from internet----------------------
url<-"https://raw.githubusercontent.com/rafalab/dslabs/master/inst/extdata/murders.csv"
url<-"https://raw.githubusercontent.com/vstanev1/Supercon/master/Supercon_data.csv"#data of critical temperature for superconducting transition
dat_supercon<-read_csv(url)
dat_supercon
View(dat_supercon)
#If you want to save a local copy in our working directory
download.file(url, "dat_supercon.csv")
list.files()
data<-read_csv("dat_supercon.csv")
View(data)
#Two functions that are usually useful are tempfile and tempname. See in the book, pp81.
#To remove a file, use this
file.remove("dat_supercon.csv")



#---------------------------2.-RESHAPING DATA----------------------------
#To work with an example, we will use fertility wide format database from dslabs package
library(tidyverse)
library(dslabs)
path<-system.file("extdata", package="dslabs")
filename<-file.path(path,"fertility-two-countries-example.csv")
wide_data<-read_csv(filename)
View(wide_data)
#The object defined this way, wide_data, is in the wide format. In this format, each row includes several observations 
# as opossed to the tidy data that displays one observation for each row
#Furthermore, this wide data objects stores one of the variables, the year, stored in the header
#To use the tidyverse we need to convert the data into tidyformat with the gather function
new_tidy_data<-gather(wide_data, year, fertility, "1960":"2015")

#the first argument of gather, as other tidyverse function, takes the data frame that will be gathered. 
#The second argument sets the  name of the column that will hold the variable that are currently kept in the wide_Data column names. In this case, year 
#The third argument sets the column name for the column that will hold the values in the column cells. In this case, fertility
#The default is to gather all columns so, we specify the columns by means of the fourth argument. In this case, 
#we want columns from 1960 to 2015
View(new_tidy_data)
#Another way for the same is to specify the column that will not be gathered, instead of specifying all the columns that must be gathered:
wide_data%>%gather(year, fertility, -country)
#If we gather the default, i.e., all columns, the object changes, not being in tidy format:
gather(wide_data, year, fertility)

#The result is equivalent to the tidy_data object defined like this
data("gapminder")
tidy_data<-gapminder%>%filter(country %in% c("South Korea", "Germany") & !is.na(fertility))%>%select(country, year, fertility)
View(tidy_data)
#With one difference:
class(tidy_data$year)
class(new_tidy_data$year)
#the gather function assumes that the column names are characters. So we need convert characters into numbers to plot
#This is done with the convert argument inside the gather function
new_tidy_data<-wide_data%>%gather(year, fertility, -country, convert=TRUE)
class(new_tidy_data$year)
#Now we have tidy data and we can plot:
new_tidy_data%>%ggplot(aes(year, fertility, color=country)) + geom_point()

#Sometimes is useful to convert tidy data into wide data. For this we use the converse of gather, the spread( function
new_wide_Data<-new_tidy_data%>%spread(year, fertility)
#The first argument is the data frame. We do not show it here because we are piping. 
#The second argument tells spread which variables will be used as the column names
#The third argument tells spread which variables to use to fill out cells
select(new_wide_Data, country, "1960":"1967")

#--------------------------SEPARATE and UNITE---------------------------
#A more complex data wrangling is shown as follows, using the following data from the dslabs package
path<-system.file("extdata", package="dslabs")
filename<-"life-expectancy-and-fertility-two-countries-example.csv"
filename<-file.path(path, filename)
raw_dat<-read_csv(filename)
View(raw_dat)
select(raw_dat, 1:5)
#Note that data is in wide format. Additionally, table includes values for two variables, fertility and life expectancy, with
#the column name encoding which columns represents which variable
#To start converting data into tidy format, we start with gather but not using the column name year since now it contains the varibale type too
# wE will call it now key, the default
dat<-raw_dat%>%gather(key, value, -country)
head(dat)
#Now we want to separate the key column into the year and the variable type. readr package has the separate function to do this

#separate takes 4 arguments: the first, the data
#the second, the column to be separated
#the third, the names to be used for the new columns
#the fourth, the character that separates the variables
new_dat<-dat%>%separate(key, c("year", "variable_name"),"_")
new_dat
#Since _ is used to separate not only year and the variable name, but also life and expectancy, we run into a new problem, getting a warning message
#We might try this
new_dat<-dat%>%separate(key, c("year", "first_variable_name","second_variable_name"),"_")

#However, the separate function allows us to merge the last two variables when there is an extra separation
new_dat_2<-dat%>%separate(key, c("year", "variable_name"), extra="merge")
new_dat_2
#Now we create a column for each variable with the spread function
new_dat_2<-dat%>%separate(key, c("year", "variable_name"), extra="merge")%>%spread(variable_name, value)
View(new_dat_2)

#Sometimes we need the converse operation, uniting two columns into one. For this we use the unite function.We show each step separetely
dat%>%separate(key, c("year", "first_variable_name","second_variable_name"),fill="right")
dat%>%separate(key, c("year", "first_variable_name","second_variable_name"),fill="right")%>%unite(variable_name,first_variable_name, second_variable_name)
dat%>%separate(key, c("year", "first_variable_name","second_variable_name"),fill="right")%>%unite(variable_name,first_variable_name, second_variable_name)%>%spread(variable_name,value)
dat%>%separate(key, c("year", "first_variable_name","second_variable_name"),fill="right")%>%unite(variable_name,first_variable_name, second_variable_name)%>%spread(variable_name,value)%>%rename(fertility = fertility_NA)


#---------------------3.- JOINING TABLES----------------------

#The information we need for a given analysis may not be just in one table. Suppose we want to explore the relationship
# between population size for US states and electoral votes. We have population size in this table
library(tidyverse)
library(dslabs)
data(murders)
#and electoral votes here
data(polls_us_election_2016)
head(murders)
head(results_us_election_2016)
#Concatenating these tables will not work since the order of the sates is not the same
identical(results_us_election_2016$state,murders$state)
#The join functions in the dplyr package make sure that the tables are combined so that matching rows are together. 
# The general idea is that one needs to identify one or more columns that will serve to match the two tables. Then 
#a new table with the combined information is returned. Notice what happens if we join the two tables above by state 
#using left_join (we will remove the others column and rename electoral_votes so that the tables fit on the page):
tab<-left_join(murders, results_us_election_2016, by ="state")%>%select(-others)%>%rename(ev=electoral_votes)
head(tab)
#The data has been successfully joined and we can now, for example, make a plot to explore the relationship:
library(ggrepel)
tab %>% ggplot(aes(population/10^6, ev, label = abb)) + geom_point() + geom_text_repel() + scale_x_continuous(trans="log2") + scale_y_continuous(trans="log2") + geom_smooth(method="lm", se = FALSE)

#In practice, it is not always the case that each row in one table has a matching row in the other. For this reason, 
#we have several versions of join. To illustrate this challenge, we will take subsets of the tables above. We create
#the tables tab1 and tab2 so that they have some states in common but not all:
tab1<- slice (murders, 1:6) %>% select (state, population)
tab1
tab2<-results_us_election_2016%>%filter(state %in% c("Alabama", "Alaska", "Arizona", "California", "Connecticut", "Delaware" ))%>%select(state, electoral_votes)%>%rename(ev=electoral_votes)
tab2
#------------------Left join----------------------------
#Suppose we want a table like tab1 adding electoral votes when available. Then we use left join, with tab1 being the first argument
#We choose which column to use to match with the by argument
left_join(tab1, tab2, by ="state")
#Note that NAs are added to the states from tab1 not appearing in tab2
#---------------------Right join-------------------------
#If we want a table with the same rows as a second table
tab1%>%right_join(tab2, by ="state")
#--------------Inner join-----------------------
#If we want to keep only the rows that have information in both tables. Think of it as an intersection
inner_join(tab1, tab2, by ="state")
#--------------Full join-------------------
#If we want to keep all the rows and fill the missing parts with NAs. Think of it as a Union
full_join(tab1, tab2, by ="state")
#----------------------Semi join---------------------
#The semi_join function lets us keep the part of first table for which we have information in the second. 
#It does not add the columns of the second:
semi_join(tab1, tab2, by="state")
#------------------------anti join---------------------
#The function anti_join is the opposite of semi_join. It keeps the elements of the first table for 
#which there is no information in the second:
anti_join(tab1, tab2, by ="state")

#--------------------BINDING------------------------------
#Although we have yet to use it in this book, another common way in which datasets are combined is 
#by binding them. Unlike the join function, the binding functions do not try to match by a variable, but instead 
#simply combine datasets. If the datasets don’t match by the appropriate dimensions, one obtains an error
#The dplyr function bind_cols binds two objects by making them columns in a tibble. For example, we quickly want
#to make a data frame consisting of numbers we can use.
bind_cols(a=1:3, b=4:6)
#This function requires that we assign names to the columns. Here we chose a and b.
#Note that there is an R-base function cbind with the exact same functionality. An important difference is that 
#cbind can create different types of objects, while bind_cols always produces a data frame.

#bind_cols can also bind two different data frames. For example, here we break up the tab data frame and then bind 
#them back together:
tab_1<-tab[,1:3]
tab_2<-tab[4:6]
tab_3<-tab[,7:8]
new_tab<-bind_cols(tab_1, tab_2, tab_3)
head(new_tab)

#The bind_rows function is similar to bind_cols, but binds rows instead of columns:
tab_1<-tab[1:2,]
tab_2<-tab[3:4,]
bind_rows(tab_1, tab_2)

#---------------------------Set operators----------------------------------
#Another set of commands useful for combining datasets are the set operators. When applied to vectors, these behave 
#as their names suggest. Examples are intersect, union, setdiff, and setequal. However, if the tidyverse, or more 
# specifically dplyr, is loaded, these functions can be used on data frames as opposed to just on vectors.
intersect(1:10, 6:15)
intersect(c("a","b","c"),c("b","c","d"))
#The dplyr package includes an intersect function that can be applied to tables with the same column names. This 
#function returns the rows in common between two tables. To make sure we use the dplyr version of intersect rather 
#than the base package version, we can use dplyr::intersect like this:
tab_1<-tab[1:5,]
tab_1
tab_2<-tab[3:7,]
tab_2
dplyr::intersect(tab_1,tab_2)
#Similarly union takes the union of vectors. For example:
union(1:10, 6:15)
union(c("a","b","c"),c("c","d", "e"))
#The dplyr package includes a version of union that combines all the rows of two tables with the same column names.
tab_1<-tab[1:5,]
tab_2<-tab[3:7,]
dplyr::union(tab_1, tab_2)
#The set difference between a first and second argument can be obtained with setdiff. Unlike intersect and union, 
#this function is not symmetric:
setdiff(1:10, 6:15)
setdiff(6:15, 1:10)
#As for the functions above, dplyr has a function for data frames
tab_1<-tab[1:5,]
tab_2<-tab[3:7,]
dplyr::setdiff(tab_1,tab_2)
#Finally, the function setequal tells us if two sets are the same, regardless of order. So notice that:
setequal(1:5,1:6)
#but
setequal(1:5, 5:1)
#When applied to data frames that are not equal, regardless of order, the dplyr version provides a useful 
#message letting us know how the sets are different:
dplyr::setequal(tab_1, tab_2)
