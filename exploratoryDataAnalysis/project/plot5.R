#!/usr/bin/local/Rscript

library(dplyr)
library(ggplot2)

#Read and merge the data
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")
data.merged <- merge(nei, scc)

# Get total motor vehicle related emissions by year
motor.vehicle.bltmr <- filter(data.merged, grepl("On-Road", EI.Sector), fips == 24510) %>%
						group_by(year) %>%
						summarize(total.emissions=sum(Emissions))

p <- ggplot(data=motor.vehicle.bltmr) + 
		geom_bar(aes(x=factor(year), y=total.emissions), stat="identity") +
		theme_bw() + 
		labs(title="Total Motor Vehicle Related Emissions in Baltimore", 
		x="Year", 
		y="Total Emissions (PM2.5 emitted in tons)")
ggsave("plot5.png", p)