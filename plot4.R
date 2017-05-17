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

## Save the old settings.
pold <- par()
## Produce plot4.png with the required width and height
png("plot4.png", width=480, height=480)
### 4 plots on a 'page': 2 rows and 2 columns
par(mfcol=c(2,2))

## Plot 1
plot(household$datetime,  household$Global_active_power, ylab="Global Active Power", type="l", xlab="")

## Plot 2
## Make plot without data
plot(household$datetime,  household$Sub_metering_1, ylab="Energy sub metering", type="n", xlab="")
## Add Sub_metering_1 in black
lines(household$datetime, household$Sub_metering_1 , type="l", col="black")
## Add Sub_metering_2 in red
lines(household$datetime, household$Sub_metering_2 , type="l", col="red")
## Add Sub_metering_3 in blue
lines(household$datetime, household$Sub_metering_3 , type="l", col="blue")
## Define list of names to use in legend
toplot <- names(select(household, contains("Sub")))
## Define a legend but without a border.
legend("topright", col=c("black", "red", "blue"), legend=toplot, lty = c(1,1,1), bty="n")

## Plot 3
plot(household$datetime,  household$Voltage, ylab="Voltage", xlab="datetime", type="l")

## Plot 4
plot(household$datetime,  household$Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power")


dev.off()
## set the old settngs
par(pold)

