source("plot1.R")
source("plot3.R")

plot4 <- function(power.cons)
{
	par(mfrow=c(2,2))
	plotTopLeft(power.cons)
	plotTopRight(power.cons)
	plotBottomLeft(power.cons)
	plotBottomRight(power.cons)
}

plotTopLeft <- function(power.cons)
{
	with(power.cons, 
			plot(date.time, 
					Global_active_power,
					type="l",
					xlab="", 
					ylab="Global Active Power (killowats)"))
}

plotTopRight <- function(power.cons)
{
	with(power.cons, 
			plot(date.time, 
					Voltage,
					type="l",
					xlab="datetime", 
					ylab="Voltage"))
}

plotBottomLeft <- function(power.cons)
{
	with(power.cons, 
			plot(date.time, 
					Sub_metering_1,
					type="l",
					xlab="", 
					ylab="Energy sub metering"))
	with(power.cons, lines(date.time, Sub_metering_2, col="red"))
	with(power.cons, lines(date.time, Sub_metering_3, col="blue"))
	legend("topright",
			lty="solid",
			col=c("black", "red", "blue"), 
			legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
}

plotBottomRight <- function(power.cons)
{
	with(power.cons,
			plot(date.time, 
					Global_reactive_power,
					type="l",
					xlab="datetime"))
}