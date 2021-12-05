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
