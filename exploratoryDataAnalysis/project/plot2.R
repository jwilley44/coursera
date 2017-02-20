#!/usr/bin/local/Rscript

#Read in the data
nei <- readRDS("summarySCC_PM25.rds")

# keep only the Baltimore data
bltmr <- subset(nei, fips == 24510)

#Caclculate total emissions
bltmr.totalEmissionsPerYear <- tapply(bltmr$Emissions, bltmr$year, sum)

#Plot bar chart of total emmisions
png("plot2.png")
barplot(bltmr.totalEmissionsPerYear)
title(main="Total Emissions by Year for Baltitmore", xlab="Year", ylab="Total Emissions (PM2.5 emitted in tons)")
dev.off()