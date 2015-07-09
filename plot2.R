################################################################################
# File: plot2.R
# Author: Milen Angelov
# Date: 9th of July, 2015
# 
# This is second out of four scripts which are part of Course Project 1 of
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

# Reusable piece of code which I use in all four scripts
# The function does not take parameters and returns working (cleaned and tidy)
# data
getWorkingData <- function() {
    
    # First check is the file exists
    if( !file.exists( fName ) ){
        downloadAndUnzipRawData();
    }
    
    # Read the raw data, on my machine RAM is sufficient and I think it is
    # not necessary to read in piece by piece.
    rData <- read.csv(fName, sep = ";", na.strings = "?");
    
    # Get working (subset) of the raw data containing only records
    # from the dates 2007-02-01 and 2007-02-02
    wData <- subset(rData, Date == "1/2/2007" | Date == "2/2/2007");
    
    # Merge Date and Time in a new col
    wData$DateTime <- as.POSIXct(strptime( paste(wData$Date, wData$Time), 
                                           format = "%d/%m/%Y %H:%M:%S") );
    return(wData);
}

# Open the png device for writing
png(filename="plot2.png", 
    height = 480, 
    width = 480, 
    units = "px", 
    bg = "white");

data <- getWorkingData();

plot(data$DateTime,
     data$Global_active_power,type = "l",
     xlab = "",
     ylab = "Global Active Power (kilowatts)");

# Close device
dev.off();

dev.off()