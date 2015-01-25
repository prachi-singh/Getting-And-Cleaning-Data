##Getting And Cleaning Data, Peer Assessment Assignment
##Prachi Singh, Jan 24th, 2015
##run_analysis.r
##Script to merge and analyze the training and test activity datasets of 6 levels  
##of activities performed by 30 volunteers.

#Ensure that UCI HAR Dataset folder is in your current working directory.
#Need to have data.table, reshape2, and tidyr packages installed to run this script.

#Load required libraries: data.table, reshape2, tidyr

require("data.table")
require("reshape2")
require("tidyr")

#Load activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

#Load data column names
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

#Clean up column names to make more readable, using gsub() pattern replacement
features <- gsub('[-()]', '', features)
features <- gsub("^t", "Time_", features)
features <- gsub("^f", "Freq_", features)
features <- gsub("*Gyro*", "AngularVelocity_", features)
features <- gsub("*Acc*", "Acceleration_", features)

#Use grepl to only extract measurements on the mean and standard deviation for each measurement.
#grepl() returns logical vector of columns that match.
#Our desired features have -mean() or -std() as a part of the column name.
select_features <- grepl("mean|std", features)

#Load and process X_test & y_test data.
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

names(X_test) <- features

#Extract measurements on the mean and standard deviation for each measurement.
X_test <- X_test[,select_features]

#Load activity labels
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) <- c("Activity_ID", "Activity_Label")
names(subject_test) <- "Subject"

#Column bind the entire test data
test_data <- cbind(as.data.table(subject_test), y_test, X_test)

#Load and process X_train & y_train data.
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

names(X_train) <- features

#Extract only the measurements on the mean and standard deviation for each measurement.
X_train = X_train[,select_features]

#Load activity data
y_train[,2] <- activity_labels[y_train[,1]]
names(y_train) <- c("Activity_ID", "Activity_Label")
names(subject_train) = "Subject"

#Column bind training dataset
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

#Merge test and train datasets
combined_data <- rbind(test_data, train_data)

#Differentiate ID variables and Measured variables and melt dataset
id_labels <- c("Subject", "Activity_ID", "Activity_Label")
data_labels <- setdiff(colnames(combined_data), id_labels)
melt_data <- melt(combined_data, id = id_labels, measure.vars = data_labels)

#Apply mean function to dataset using dcast function
tidy_dataset <- dcast(melt_data, Subject + Activity_Label ~ variable, mean)

write.table(tidy_dataset, file = "./uci_har_tidy_data.txt")
write.table(tidy_dataset, file="./uci_har_tidy_data.csv")

