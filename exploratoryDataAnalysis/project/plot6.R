#!/usr/bin/local/Rscript

library(dplyr)
library(ggplot2)
library(girdExtra)

#Read and merge the data
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")
data.merged <- merge(nei, scc)


# Get total motor vehicle related emissions by year
motor.vehicle.bltmr <- filter(data.merged, grepl("On-Road", EI.Sector), fips == "24510") %>%
		group_by(year) %>%
		summarize(total.emissions=sum(Emissions)) %>%
		mutate(location.name="Baltimore")
motor.vehicle.la <- filter(data.merged, grepl("On-Road", EI.Sector), fips == "06037") %>% 
		group_by(year) %>% 
		summarize(total.emissions=sum(Emissions)) %>%
		mutate(location.name="LA County")

#Combine the data 
motor.vehicle <- rbind(motor.vehicle.la, motor.vehicle.bltmr)

#Calculate Percent Change
total.1999 <- filter(motor.vehicle, year == "1999") %>% 
		rename(emissions.1999 = total.emissions) %>%
		select(-year)
motor.vehicle.percent <- merge(total.1999, motor.vehicle, by=c("location.name")) %>% 
		filter(year != "1999") %>%
		mutate(percent.change=(total.emissions-emissions.1999)*100/emissions.1999)

# Plot total emissions


totalEmissionsPlot <- ggplot(data=motor.vehicle) + 
		geom_bar(aes(x=factor(year), y=total.emissions, fill=location.name), stat="identity", position="dodge") +
		theme_bw() + 
		labs(title="Total Motor Vehicle Related Emissions in Baltimore and LA County", 
				x="Year", 
				y="Total Emissions (PM2.5 emitted in tons)",
				fill="Location")

percentChangePlot <- ggplot(data=motor.vehicle.percent, 
				aes(x=as.character(year), y=percent.change, colour=location.name, group=location.name)) +
				geom_point(size=4) +
				geom_line() + 
				theme_bw() +
				labs(title="Percent Change in Motor Vehicle Emissions Since 1999",
						x="Year",
						y="Percent Change Since 1999",
						colour="Location")

ggsave("plot6.png", grid.arrange(totalEmissionsPlot, percentChangePlot, ncol=2))
