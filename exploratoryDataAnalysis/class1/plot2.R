#!/usr/local/bin/Rscript

plot2 <- function(power.cons)
{
	with(power.cons, 
			plot(date.time, 
				Global_active_power,
				type="l",
				xlab="", 
				ylab="Global Active Power (kilowats)"))
}


source("plotUtil.R")

# Read and format the data
power.cons <- readAndFormatData()

# Plot the data
printPlotToPng(plot2, power.cons, "plot2.png")