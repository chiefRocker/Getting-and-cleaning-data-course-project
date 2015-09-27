## Rory Guzowski
## September 25, 2015
## runAnalysis.r

# This script will perform the following steps on the UCI HAR Dataset downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

###################################################################################################################################################

library(reshape2)

#set wd to where the UCI HAR Datasets are
setwd('/Users/rguzowski/Desktop/Coursera/Getting and Cleaning Data/Course Project/data/UCI HAR Dataset/');

# load the activity_labels and features files
activitytype <- read.table("UCI HAR Dataset/activity_labels.txt")
activitytype[,2] <- as.character(activitytype[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract the mean and standard deviation
featuresExtract <- grep(".*mean.*|.*std.*", features[,2])
featuresExtract.names <- features[featuresExtract,2]
featuresExtract.names = gsub('-mean', 'Mean', featuresExtract.names)
featuresExtract.names = gsub('-std', 'Std', featuresExtract.names)
featuresExtract.names <- gsub('[-()]', '', featuresExtract.names)

# Load the train datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresExtract]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

# Load the test datasets
test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresExtract]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# merge datasets
tidyData <- rbind(train, test)
colnames(tidyData) <- c("subject", "activity", featuresExtract.names)

# turn activities & subjects into factors
tidyData$activity <- factor(tidyData$activity, levels = activitytype[,1], labels = activitytype[,2])
tidyData$subject <- as.factor(tidyData$subject)

tidyData.melted <- melt(tidyData, id = c("subject", "activity"))
tidyData.mean <- dcast(tidyData.melted, subject + activity ~ variable, mean)

#set wd to where you want the tidy.txt file written to
setwd('/Users/rguzowski/Desktop/Coursera/Getting and Cleaning Data/Course Project/');

write.table(tidyData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
