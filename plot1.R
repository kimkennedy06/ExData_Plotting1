#Check to see if package "sqldf" is installed
#If not installed, install "sqldf"
if ("sqldf" %in% rownames(installed.packages()) == FALSE){
  install.packages.("sqldf")
}
#Run library sqldf and datasets
library(sqldf)
library(datasets)

#Create SQL call to pull only lines with Dates of Feb 1, 2007 or Feb 2,2007
specific.dates <- "Select * from file where Date='1/2/2007' or Date='2/2/2007'"

#Create data frame with only the lines with specific dates found from SQL
power.consumption <- read.csv2.sql("household_power_consumption.txt",
                                   sql=specificDates,
                                   header=TRUE,
                                   sep=";")

#Create column that combines Date and Time columns
power.consumption$DateTime <- sapply(power.consumption,
                                     function(x)paste(
                                       power.consumption$Date,
                                       power.consumption$Time,
                                       sep=" "
                                       )
                                     )[, 1]

#Change Class of DateTime to class Date
power.consumption$DateTime <- strptime(power.consumption$DateTime,
                                       '%d/%m/%Y %H:%M:%S')

#Remove Date and Time columns since created merged column of date and time
power.consumption <- power.consumption[, -c(1,2)]

#Reorder so that DateTime is first
power.consumption <- power.consumption[, c(length(power.consumption),
                                           1:length(power.consumption)-1)]

#Open png device and create 'plot1.png' in present working directory
png(file="plot1.png",width=480,height=480,units="px")

#Create Histogram of Global_active_power
with(power.consumption,
     hist(Global_active_power,
          main="Global Active Power",
          col="red",
          xlab="Global Active Power (kilowatts)",
          ylab="Frequency"
          )
     )

#Close png device
dev.off()