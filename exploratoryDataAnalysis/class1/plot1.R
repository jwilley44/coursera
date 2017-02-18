#!/usr/local/bin/Rscript

plot1 <- function(power.cons)
{
	
with(power.cons, 
		hist(Global_active_power,
				col="red",
				main="Global Active Power", 
				xlab="Global Active Power (kilowats)"))

}

source("plotUtil.R")

# Read and format the data
power.cons <- readAndFormatData()

# Plot the data
printPlotToPng(plot1, power.cons, "plot1.png")