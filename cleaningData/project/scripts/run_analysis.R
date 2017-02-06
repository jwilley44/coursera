#!/usr/local/bin/Rscript

scriptArguments <- commandArgs(trailingOnly=TRUE)

if (length(scriptArguments) < 1) stop("Data directory must be given")

originalDataDir <- scriptArguments[1]
if (!dir.exists(originalDataDir)) stop(paste("Data directory:", originalDataDir, "does not exist"));

if(!file.exists("tidyData.R")) stop(paste(
					"Not in correct directory.",
					"You must be in the coursera/cleaningData/project/scripts", "
					directory to run this script"))

source("tidyData.R")

print("Setting intial variables")
setInitialVariables(originalDataDir)

print("Loading data")
train.data <- getTrainFeatureData(originalDataDir)
test.data <- getTestFeatureData(originalDataDir)
all.data <- rbind(train.data, test.data)

print("Tidying data")
tidy.data <- tidyFeatureData(all.data)
tidyDir <- file.path(dirname(originalDataDir), "tidyData")
dir.create(tidyDir, showWarnings=FALSE)
write.table(tidy.data, file=file.path(tidyDir, "tidyData.tsv"), sep="\t", col.names=T, row.names=F, quote=F)

print("Summarizing data")
summarized.data <- summarizeFeatureData(tidy.data)
write.table(summarized.data, file=file.path(tidyDir, "tidyData.summarized.tsv"), sep="\t", col.names=T, row.names=F, quote=F)

print(paste("Finished! Results can be found in", tidyDir))