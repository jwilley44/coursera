#!/usr/bin/local/Rscript

library(dplyr)
library(ggplot2)

#Read in the data
nei <- readRDS("summarySCC_PM25.rds")

totalEmisions <- group_by(nei, year, type) %>% summarize(total.emissions=sum(Emissions))


p <- ggplot(data=totalEmisions) + 
		geom_bar(aes(x=factor(year), y=total.emissions), stat="identity") +
		facet_wrap(~type) +
		theme_bw() + 
		labs(x="Year", y="Total Emissions (PM2.5 emitted in tons)", title="Total Emissions per Year by Source")

ggsave("plot3.png", p)