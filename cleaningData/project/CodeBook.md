# Tidy Data

## tidyData.tsv
Contains all the mean and standard deviation values from the training and the
test sets.
### Column Values
- set
  - test
  - train
- activity
  - WALKING
  - WALKING_UPSTAIRS
  - WALKING_DOWNSTAIRS
  - SITTING
  - STANDING
  - LAYING
- metric: the quantity that was measured
  - fBodyAcc 
  - fBodyAccJerk 
  - fBodyAccMag 
  - fBodyBodyAccJerkMag 
  - fBodyBodyGyroJerkMag
  - fBodyBodyGyroMag
  - fBodyGyro
  - tBodyAcc
  - tBodyAccJerk
  - tBodyAccJerkMag
  - tBodyAccMag
  - tBodyGyro
  - tBodyGyroJerk
  - tBodyGyroJerkMag
  - tBodyGyroMag
  - tGravityAcc
  - tGravityAccMag
- measurement: how the metric was recorded
  - mean
  - standard deviation
- direction: the direction of the metric
  - X
  - Y
  - Z
  - [blank]
- value: the value that was recorded. See
  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
  for more information on methods, units, etc..

## tidyData.summarized.tsv
Summarizes tidyData.tsv over:
- set
- activity
- metric
- measurement
- direction
by taking the average of the value column (with NAs removed). Additionally the
data is 'spread' so that that the there are two new columns 'mean' and 'std'
(representing the average value for the mean and standard deviation
respectively) to replace the measurement column.
