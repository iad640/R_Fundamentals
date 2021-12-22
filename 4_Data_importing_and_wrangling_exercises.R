#------Rhesaphing, from  Introduction to data science, pp 395
co2_wide<-data.frame(matrix(co2, ncol=12, byrow=TRUE))%>%setNames(1:12)%>%mutate(year=as.character(1959:1997))
co2_wide
co2_tidy<-gather(co2_wide,key=month, value=co2,-year,convert=TRUE)
co2_tidy
class(co2_tidy$year)
class(co2_tidy$month)
class(co2_tidy$co2)
co2_tidy%>%ggplot(aes(month, co2, color=year))+geom_line()

data(admissions)
admissions
dat<-admissions%>%select(-applicants)%>%spread(gender, admitted)%>%rename(men_admitted_percentage=men, women_admitted_percentage=women)

tmp<-gather(admissions,key, value,-major,-gender)
tmp2<-tmp%>%unite(column_name, gender, key)
tmp3<-tmp2%>%spread(column_name, value)
admissions_0<-tmp3
rm(tmp, tmp2, tmp3)#removes temp variables
admissions_0
#Do the same in a line of code
admissions<-gather(admissions,key, value,-major,-gender)%>%unite(column_name, gender, key)%>%spread(column_name, value)
#Add two columns with the percentages
admissions<-admissions%>%mutate(percentage_admitted_men=100*men_admitted/men_applicants, percentage_admitted_women=100*women_admitted/women_applicants)
admissions

#Joining table exercises, from 22.4 section of Introduction to data science
#load the Lahman library. This database includes data related to baseball teams.
#It includes summary statistics about how the players performed on offense and defense for several years. It also 
#includes personal information about the players.
library(Lahman)

#The Batting data frame contains the offensive statistics for all players for many years. You can see, for example, 
#the top 10 hitters by running this code:
Batting
top<-Batting%>%filter(yearID==2016)%>%arrange(desc(HR))%>%slice(1:10)
top%>%as_tibble()
#But who are these players? We see an ID, but not the names. The player names are in this table
Master%>%as_tibble()
#We can see column names nameFirst and nameLast. Use the left_join function to create a table of the top home run 
#hitters. The table should have playerID, first name, last name, and number of home runs (HR). Rewrite the object 
#top with this new table.
top<-top%>%left_join(Master)%>%select("playerID","nameFirst","nameLast","HR")
top

#Now use the Salaries data frame to add each player’s salary to the table you created in the previous exercise. Note 
#that salaries are different every year so make sure to filter for the year 2016, then use right_join. This time show 
#first name, last name, team, HR, and salary.
Salaries
top<-top%>%right_join(Salaries)%>%filter(yearID==2016)%>%select("nameFirst","nameLast","teamID","HR","salary")%>%slice(1:10)
top

#In a previous exercise, we created a tidy version of the co2 dataset:
co2_wide <- data.frame(matrix(co2, ncol = 12, byrow = TRUE)) %>% 
  setNames(1:12) %>%
  mutate(year = 1959:1997) %>%
  pivot_longer(-year, names_to = "month", values_to = "co2") %>%
  mutate(month = as.numeric(month))
co2_wide
#We want to see if the monthly trend is changing so we are going to remove the year effects and then plot the results.
#We will first compute the year averages. Use the group_by and summarize to compute the average co2 for each year.
#Save in an object called yearly_avg.
yearly_avg<-co2_wide%>%group_by(year)%>%summarize(avg=mean(co2))
yearly_avg
#Now use the left_join function to add the yearly average to the co2_wide dataset. Then compute the residuals: observed 
#co2 measure - yearly average.

co2_wide<-co2_wide%>%left_join(yearly_avg, by ="year")%>%mutate(residuals = co2 - avg)
co2_wide_year<-co2_wide%>%select(year,month,co2,residuals)%>%group_by(month)

co2_wide<-co2_wide%>%select(co2,residuals)
co2_wide
#Make a plot of the seasonal trends by year but only after removing the year effect.
#I think he means to do this: https://anomaly.io/seasonal-trend-decomposition-in-r/index.html

library(forecast) #We load the package to work with time series
#To detect the underlying trend, we smooth the time series using the “centred moving average“. To perform the 
#decomposition, it is vital to use a moving window of the exact size of the seasonality. Therefore, to decompose 
#a time series we need to know the seasonality period: weekly, monthly, etc… If you don’t know this figure, you 
#can detect the seasonality using a Fourier transform.
co2_ts<-ts(co2_wide, frequency=12, start=c(1959,1))
plot.ts(co2_ts) #The first plot represents the seasonal trend including the yearly effect. The second one does not have
#into account the yearly effect


