plot1 <- function(power.cons)
{
	
with(power.cons, 
		hist(Global_active_power,
				col="red",
				main="Global Active Power", 
				xlab="Global Active Power (killowats)"))

}