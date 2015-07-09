################################################################################
# File: plot3.R
# Author: Milen Angelov
# Date: 9th of July, 2015
# 
# This is third out of four scripts which are part of Course Project 1 of
# Exploratory Data Analysis course at Coursera.
################################################################################

# Define some variables
# fName - file name containing raw data
fName <- "household_power_consumption.txt";
# fUrl - url of dataset
fUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip";

# Function to be called in case file name does not exists in the 
# working directory. Does not take any parametars. 
# Does not return any data. 
# Simply download and unzip dataset
downloadAndUnzipRawData <- function() {
    
    # Download source, on Mac OS X method should be specified
    download.file(fUrl, destfile="rawData.zip", method="curl")
    
    # Unzip it so it can be read directly.
    powerConsumption <- unzip("rawData.zip", fName);
}

# The function does not take parameters and returns working 
# (cleaned and processed) subset of the raw data. 
# Also one can put in use some ideas from "Getting and Cleaning Data" 
# course and use dplyr library to select, rename and filter the subset of the
# raw data.
getWorkingData <- function() {
    
    # First check is the file exists
    if( !file.exists( fName ) ){
        downloadAndUnzipRawData();
    }
    
    # Read the raw data.
    rData <- read.csv(fName, sep = ";", na.strings = "?");
    
    # Get working (subset) of the raw data containing only records
    # from the dates 2007-02-01 and 2007-02-02
    wData <- subset(rData, Date == "1/2/2007" | Date == "2/2/2007");
    
    # Merge Date and Time in a new column
    wData$DateTime <- as.POSIXct(strptime( paste(wData$Date, wData$Time), 
                                           format = "%d/%m/%Y %H:%M:%S") );
    return(wData);
}

data <- getWorkingData();

# Open device for writing
png(filename = "plot3.png",
    width = 480, 
    height = 480, 
    units = "px", 
    bg = "white");

# Plot 
plot(x=data$DateTime,
     y=data$Sub_metering_1,type = "l",
     xlab = "",
     ylab = "Energy Sub Meetering");


lines(x = data$DateTime,
      y = data$Sub_metering_2, 
      type="l",
      col="red");

lines(x = data$DateTime,
      y = data$Sub_metering_3, 
      type="l",
      col="blue");

# array of labels to be put in the legends
legendLabels <- c("Sub Meetering 1", "Sub Meetering 2",  "Sub Meetering 3");

# Put a legend in the upper right corner
legend("topright",
       legendLabels,
       lty = c(1, 1, 1),
       lwd = c(2.5, 2.5, 2.5),
       col = c("black", "blue", "red") );

# Close device
dev.off();
