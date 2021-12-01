#--------------------IMPORTING DATA from spreadsheets -------------------------
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

