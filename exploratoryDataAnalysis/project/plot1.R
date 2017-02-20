#!/usr/bin/local/Rscript

#Read in the data
nei <- readRDS("summarySCC_PM25.rds")

#Caclculate total emissions
totalEmissionsPerYear <- tapply(nei$Emissions, nei$year, sum)

#Plot bar chart of total emmisions
png("plot1.png")
barplot(totalEmissionsPerYear)
title(main="Total Emissions by Year", xlab="Year", ylab="Total Emissions (PM2.5 emitted in tons)")
dev.off()