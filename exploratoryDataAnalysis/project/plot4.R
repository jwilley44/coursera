#!/usr/bin/local/Rscript

library(dplyr)
library(ggplot2)

#Read and merge the data
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")
data.merged <- merge(nei, scc)

# Get total coal combustion related emissions by year
coal.comb <- filter(data.merged, grepl("Fuel Comb", EI.Sector), grepl("Coal", EI.Sector)) %>%
		group_by(year) %>%
		summarize(total.emissions=sum(Emissions))

p <- ggplot(data=coal.comb) + 
		geom_bar(aes(x=factor(year), y=total.emissions), stat="identity") +
		theme_bw() + 
		labs(title="Total Coal Combustion Related Emissions", 
				x="Year", 
				y="Total Emissions (PM2.5 emitted in tons)")
ggsave("plot4.png", p)