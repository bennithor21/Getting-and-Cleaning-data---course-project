# Getting and Cleaning Data Course Project
# Student: Benedikt Thorarensen
# Date: 2020-04-05

# Project description
# One of the most exciting areas in all of data science right now is wearable computing. 
# The data linked to from the course website represent data collected from the accelerometers 
# from the Samsung Galaxy S smartphone. 
# A full description is available at the site where the data was obtained:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# Here are the data for the project:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# This code can be run as long as the Samsung data is in your working directory.
# After the data is downloaded do not change the folder structure or names or move any files around.

# The aim og the project is to prepare tidy data that can be used for later analysis.
# This will carried out in 5 steps from the project description, but first we need to read in the data.

# 0) Read the data and import packages that will be used
# all of the table/data.frame names are the same as the names of the text files

#get training data
X_train <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")

#get test data
X_test <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

#get features and activity labels
features <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")
activity_labels <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")

#the follwoing packages will be used to make the data tidy
library(plyr)
library(dplyr)

# 1) Merge the training and the test sets to create one data set 
# Merge training and test data - notice that the three tables are put together in step 4
merged_X <- bind_rows(X_train, X_test)
merged_Y <- bind_rows(Y_train, Y_test)
merged_subject <- bind_rows(subject_train, subject_test)

# 2) Extract only the measurements on the mean and standard deviation for each measurement
# We use the grep to findfind location of measurements for mean and standard deviation in the features table.
# Notice that we include all the columns with the mean and std in the column name. 
# except for meanFreq columns, on purpose.
merged_X_meanORstd <- merged_X[,grep("mean[(]|std",features$V2)] 


# 3) Use descriptive activity names to name the activities in the data set 
# join the activity lables to the table for activities of each subject
merged_Y_names <- join(merged_Y,activity_labels) #join by variable v1
# use lower cae and remove underscore ("_") in the activity names
merged_Y_names$V2 <- tolower(merged_Y_names$V2)
merged_Y_names$V2 <- sub("_"," ",merged_Y_names$V2)
# put the activity variable back to a factor variable
merged_Y_names$V2 <- as.factor(merged_Y_names$V2)

# 4) Appropriately label the data set with descriptive variable names
# for the features we use the features given in the features table
names(merged_X_meanORstd) <- grep("mean[(]|std",features$V2, value = T)
# the only thing I find undescriptive are the parentheses ("()")
names(merged_X_meanORstd) <- sub("[(][)]","",names(merged_X_meanORstd),)
names(merged_Y_names) <- c("activity_id","activity")
names(merged_subject) <- c("subject")
# The final dataset is put togehter here by merging the three datasets 
# subjects, activities and mean and std measurements - notice that we do not need the activity_id
final_dataset <- bind_cols(merged_subject, activity = merged_Y_names$activity, merged_X_meanORstd)
#str(final_dataset)

# 5) From the data set in step 4, create a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
activity_subject_means <- final_dataset %>% group_by(activity,subject) %>% summarise_all(funs(mean))
#by_activity_subject <- group_by(final_dataset,activity,subject)
#new_table <- summarise_all(by_activity_subject,funs(mean))
#View(activity_subject_means)

# 6) Create a txt file with write.table() using row.name=FALSE
write.table(activity_subject_means, file = "run_analysis.txt", row.name=FALSE)
