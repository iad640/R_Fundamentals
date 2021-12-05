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

#------------------COPYING FILES------------------------------------
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

                                                                                                                                                                                                  