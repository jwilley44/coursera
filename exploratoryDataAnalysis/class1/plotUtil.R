library(readr)
library(dplyr)
library(lubridate)


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
