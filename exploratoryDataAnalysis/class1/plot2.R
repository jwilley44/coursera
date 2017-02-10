plot2 <- function(power.cons)
{
	with(power.cons, 
			plot(date.time, 
				Global_active_power,
				type="l",
				xlab="", 
				ylab="Global Active Power (killowats)"))
}