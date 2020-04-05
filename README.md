---
title: "README"
author: "bennithor21"
date: "4/5/2020"
output: html_document
---

This README file explains the analysis file *run_analysis.R* that is used to create the tidy dataset found in the file *run_analysis.txt*. The code book for the file can be found in the file *CodeBook.md*.

The file is created to carry out a final project in the course Getting and Cleaning data.

#### Project description;  
One of the most exciting areas in all of data science right now is wearable computing.   
The data linked to from the course website represent data collected from the accelerometers 
from the Samsung Galaxy S smartphone.  
A full description is available at the site where the data was obtained:  
<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>  
Part of the README file for the experiment and raw data can be found after analysis file has been explained.

Here is the data for the project:  
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  
This code can be run as long as this Samsung data is in your working directory.  
After the data is downloaded do not change the folder structure or names or move any files around.

The aim og the project is to prepare a tidy dataset that can be used for later analysis.  
This will carried out in 5 steps from the project description, but first we need to read in the data.  

#### run_analysis.R

step 0 - First we read the raw data (all of the table/data.frame names are the same as the names of the text files) and import packages that will be used; plyr and dplyr. As we do not need the Inertial Signals we do not read in data from those folders.

step 1 - We merge the training and the test sets to create one data set. For simplicity we have one table for the measurements/features (merged_X), one for the activities (merged_Y) and one for the subjects (merged_subjects). The three tables are put together in step 4.

step 2 - from the measurement table (merged_X) we only select those on mean and standard deveiation, using the grep function. Notice that we include all the columns with the "mean(" and "std"" in the column name on purpose. The chosen columns are put into a new table, merged_X_meanORstd.

step 3 - merge the activity table (merged_Y) with acitvity_labels to put descriptive activity names to name the activities in the data set. For simplicity and clarity to we set the labels to lower case and remove the underscore ("_") in te activity names. By doing so the variable becomes a char variable so we set it back to a factor variable again.

step 4 - name the columns in the three data tables wit descriptive names and put the three tables together to for one dataset, final_dataset (including subjects, activities and mean and std measurements). For the measurements/features we use the features given in the features table. As I find the variable name descriptive I only get rid of the parentheses ("()") in the column names. Notice that we do not need the activity_id in the final dataset.

step 5 - from the data set in step 4, a second independent tidy data set is created with the average of each variable for each activity and each subject, lets call it activity_subject_means. To do so we use the groub_by and summarise_all function in the dplyr package and pipe them together (using %>%) for simplicity.

step 6 - finally we create a txt file with write.table() using row.name=FALSE to return the tidy dataset in a simple format.

#### Part of README for the experiment itself

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.
