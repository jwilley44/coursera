library(plyr)
library(dplyr)
library(tidyr)
library(readr)

# Global Variables
originalDataDir <- "../originalData"
trainDataDir <- file.path(originalDataDir, "train")
testDataDir <- file.path(originalDataDir, "test")
featureNames <- readLines(file.path(originalDataDir, "features.txt")) %>% gsub(".* ", "", .) %>% make.names()
labelMappings <- read.table(file.path(originalDataDir, "activity_labels.txt"), header=F, sep= ' ')$V2

# Reads the feature data. Returns a data.frame
# with the features as columns
readFeatureData <- function(featurefile, labelsFile)
{
	featureData <- readLines(featurefile) %>%
			strsplit(" ") %>%
			ldply(formatValues) %>%
			setColumnNames(featureNames)
	colnames(featureData) <- make.names(featureNames)
	featureData$activity <- labelMappings[as.numeric(readLines(labelsFile))]
	return(featureData)
}

# Tidy the feature data
# 
tidyFeatureData <- function(featureData)
{
	gather(featureData[, 1:562], metric, value, -activity) %>%
			mutate(metric=gsub("\\.+", ".", metric)) %>%
			separate(metric, c("metric", "type"), sep="\\.", extra="merge") %>%
			separate(type, c("measurement", "direction"), sep="\\.", extra="merge", fill="right") %>%
			filter(measurement %in% c("mean", "std"))
}

# Summarize the data over:
# 		set (test or train)
#		activity (see activity labels)
#		metric (the measured quantity
#		measurement (how it was recorded: mean or standard deviation)
#		direction (X, Y, Z, ...)
# Takes the average value with NAs removed
summarizeFeatureData <- function(featureData)
{
	group_by(featureData, set, activity, metric, measurement, direction) %>%
			dplyr::summarize(avg.value=mean(value, na.rm=T)) %>% 
			spread(measurement, avg.value)
}

# Converts to numeric, removes NA values and converts the vector
# to a dataframe
formatValues <- function(featurevector)
{
	as.numeric(featurevector) %>%
			Filter(function(v) !is.na(v), .) %>%
			as.matrix() %>%
			t() %>%
			as.data.frame()
}
