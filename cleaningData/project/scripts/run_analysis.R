#!/usr/local/bin/Rscript

source("tidyData.R")

train.data <- readFeatureData(file.path(trainDir, "X_train.txt"), file.path(trainDir, "y_train.txt")) %>%
		mutate(set="train")
test.data <- readFeatureData(file.path(testDir, "X_test.txt"), file.path(testDir, "y_test.txt")) %>%
		mutate(set="test")

all.data <- rbind(train.data, test.data)
write.table(all.data, file="../tidyData/tidyData.tsv", sep="\t", col.names=T, row.names=F, quote=F)

summarized.data <- summarizeFeatureData(all.data)
write.table(summarizedl.data, file="../tidyData/tidyData.summarized.tsv", sep="\t", col.names=T, row.names=F, quote=F)

