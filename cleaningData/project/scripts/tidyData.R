library(plyr)
library(dplyr)
library(tidyr)
library(readr)

# Given the data directory create some global variables to
# be used in the data cleaning
setInitialVariables <- function(originalDataDir)
{
	assign("testDataDir", file.path(originalDataDir, "test"), envir=.GlobalEnv)
	assign("trainDataDir", file.path(originalDataDir, "train"), envir=.GlobalEnv)
	featureNames <- readLines(file.path(originalDataDir, "features.txt")) %>% 
			gsub(".* ", "", .)
	assign("featureNames", featureNames, envir=.GlobalEnv)
	labelMappings <- read.table(file.path(originalDataDir, "activity_labels.txt"), header=F, sep= ' ')$V2
	assign("labelMappings", labelMappings, envir=.GlobalEnv);
}

# Read and format the training data
getTrainFeatureData <- function(originalDataDir)
{
	.getFeatureData(originalDataDir, "train")
}

# Read and format the test data
getTestFeatureData <- function(originalDataDir)
{
	.getFeatureData(originalDataDir, "test")
}

.getFeatureData <- function(originalDataDir, setLabel)
{
	featurefile <- file.path(originalDataDir, setLabel, paste0("X_", setLabel, ".txt"))
	labelsfile <- file.path(originalDataDir, setLabel, paste0("y_", setLabel, ".txt"))
	readFeatureData(featurefile, labelsfile) %>%
			mutate(set=setLabel)
}


# Reads the feature data. Returns a data.frame
# with the features as columns
readFeatureData <- function(featurefile, labelsFile)
{
	labelsList <- as.list(labelMappings[as.numeric(readLines(labelsFile))])
	featureData <- readLines(featurefile) %>%
			as.list() %>%
			mapply(paste, labelsList, .) %>%
			ldply(formatData)
}

# Tidy the feature data
# Separate the feature column into metric, measurement, and direction
tidyFeatureData <- function(featureData)
{
	separate(featureData, feature, c("metric", "type"), sep="-", extra="merge", fill="right") %>% 
			separate(type, c("measurement", "direction"), extra="merge", fill="right") %>%
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

# Converts the line data into a data.frame
formatData <- function(dataline)
{
	datavector <- strsplit(dataline, " ") %>% unlist()
	activity <- datavector[1]
	featurevector <- tail(datavector, -1)
	values <- as.numeric(featurevector) %>%
			Filter(function(v) !is.na(v), .)
	data.frame(value=values, feature=featureNames, activity=as.character(activity))
}
