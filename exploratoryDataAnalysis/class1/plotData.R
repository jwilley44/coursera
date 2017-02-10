#!/usr/local/bin/Rscript

library(readr)
library(dplyr)
library(lubridate)
source("plot1.R")
source("plot2.R")
source("plot3.R")
source("plot4.R")

# Reads in the file "household_power_consumption.txt"
# subsets only the dates 2007-02-01 and 2007-02-02
readAndFormatData <- function()
{
	read_delim("household_power_consumption.txt", delim=";") %>%
	mutate(Date=dmy(Date), Time=lubridate::seconds(Time), date.time=ymd_hms(Date+Time)) %>%
	filter(Date == ymd("2007-02-01") | Date == "2007-02-02")
}

# Takes a plot function, data, and filename and prints
# the plot to a png
printPlotToPng <- function(plotFunction, plotData, filename)
{
	png(filename)
	plotFunction(plotData)
	dev.off()
}

# Read and format the data
power.cons <- readAndFormatData()

# Plot the data
printPlotToPng(plot1, power.cons, "plot1.png")
printPlotToPng(plot2, power.cons, "plot2.png")
printPlotToPng(plot3, power.cons, "plot3.png")
printPlotToPng(plot4, power.cons, "plot4.png")
