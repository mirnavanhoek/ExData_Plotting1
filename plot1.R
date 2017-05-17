library(dplyr)
library(lubridate)

#### Read in the houshold file which is an csv file delimited by ; 
#### and missing values indicated by ?
#### It is assumed that the household data are in the Data subdirectory
household <- read.csv("./Data/household_power_consumption.txt", sep=";", as.is=TRUE, na.string="?")
#### Add an extra column combining Date and Time
household <- mutate(household, datetime <- dmy_hms(paste(Date, Time)))
                    
#### Select only the observations on first and second days of February 2007
date1 <- ymd_hms("2007-02-01 00:00:00")
date2 <- ymd_hms("2007-02-03 00:00:00")
household <- household[household$datetime >= date1 & household$datetime <= date2, ]

#### Make sure variables other than Date and Time are numeric
household <- mutate_each(household, funs(as.numeric), Global_active_power:Sub_metering_2)

## Produce plot1.png with the required width and height
png("plot1.png", width=480, height=480)
##### make plot
with( household, hist(Global_active_power, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)"))
dev.off()

