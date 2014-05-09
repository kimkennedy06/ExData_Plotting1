#Check to see if package "sqldf" is installed
#If not installed, install "sqldf"
if("sqldf" %in% rownames(installed.packages())==FALSE)
{
  install.packages.("sqldf")
}
#Run library sqldf and datasets
library(sqldf)
library(datasets)

#Create SQL call to pull only lines with Dates of Feb 1, 2007 or Feb 2,2007
specificDates<-"Select * from file where Date='1/2/2007' or Date='2/2/2007'"
#Create data frame with only the lines with specific dates found from SQL
PowerConsumption<-read.csv2.sql("household_power_consumption.txt",sql=specificDates,header=TRUE,sep=";")

#Create Histogram of Global_active_power
with(PowerConsumption,hist(Global_active_power,main="Global Active Power",col="red",xlab="Global Active Power (kilowatts)",ylab="Frequency"))