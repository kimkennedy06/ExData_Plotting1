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
                                   sep=";"
                                   )

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

#Open png device and create 'plot2.png' in present working directory
png(file="plot3.png",width=480,height=480,units="px")

with(power.consumption,{
  
  #Create Line Plot of Sub_metering_1 over DateTime with y-axis label
  plot(DateTime,
       Sub_metering_1,
       xlab="",
       ylab="Energy sub metering",
       type="l",
       col="black"
       )
  
  #Add a line to plot for Sub_metering_2 over DateTime
  lines(DateTime,
        Sub_metering_2,
        type="l",
        col="red"
        )
  
  #Add a line to plot for Sub_metering_3 over DateTime
  lines(DateTime,
        Sub_metering_3,
        type="l",
        col="blue"
        )
  
  #Add a legend to specify what each line on the graph associates with each Sub_metering
  legend("topright",
         lwd=1,
         col=c("black","red","blue"),
         legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
         )
  })

#Close png device
dev.off()