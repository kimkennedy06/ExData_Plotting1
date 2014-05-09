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
#Create column that combines Date and Time columns
PowerConsumption$DateTime<-sapply(PowerConsumption,function(x)paste(PowerConsumption$Date,PowerConsumption$Time,sep=" "))[,1]

#Change Class of DateTime to class Date
PowerConsumption$DateTime<-strptime(PowerConsumption$DateTime,'%d/%m/%Y %H:%M:%S')

#Remove Date and Time columns since created merged column of date and time
PowerConsumption<-PowerConsumption[,-c(1,2)]

#Reorder so that DateTime is first
PowerConsumption<-PowerConsumption[,c(length(PowerConsumption),1:length(PowerConsumption)-1)]

#Open png device and create 'plot1.png' in present working directory
png(file="plot1.png",width=480,height=480,units="px")
#Create Histogram of Global_active_power
with(PowerConsumption,hist(Global_active_power,main="Global Active Power",col="red",xlab="Global Active Power (kilowatts)",ylab="Frequency"))
#Close png device
dev.off()