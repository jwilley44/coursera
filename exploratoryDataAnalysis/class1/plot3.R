library(tidyr)

plot3 <- function(power.cons)
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