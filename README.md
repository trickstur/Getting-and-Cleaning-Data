# Getting-and-Cleaning-Data Course Project
Getting and Cleaning Data - Course Project

##This repository includes three items:
..* README.md -- explains how all of the scripts work and how they are connected
..* CodeBook.md --  a code book that describes the variables, the data, and any transformations or work I performed to clean up the data 
..* run_analysis.R -- Script that does the analysis and creates the tidy data set

##run_analysis.R Objective
`run_analysis.R` is a highly-commented R script that analyzes exercise data and then creates a tidy data set by doing the following:

	1. Merges the training and the test sets to create one data set.
	2. Extracts only the measurements on the mean and standard deviation for each measurement.
	3. Uses descriptive activity names to name the activities in the data set
	4. Appropriately labels the data set with descriptive variable names.
	5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The script assumes that the user has already downloaded and installed the provided zipped contents into their working directory.

Files can be downloaded here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

##run_analysis.R Walkthrough

* Step 1: Merges the training and the test sets to create one data set.
    + sets working directory 
    + read in files as groups, starting with activity & features, data pertaining to x, y, and subject
    + rename file columns during import for easier comprehension  
    + create x, y, and subject datasets using imported data

*  Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.
    + use grep to create a vector (mean_std_names) with column names  that contain "mean" or "std"
    + subset columns with only those contained in vector mean_std_names

*  Step 3: Uses descriptive activity names to name the activities in the data set
    + rename y_data activities numbers into descriptive activity names using activity_labels
    + bind x, y, and subject into a new overall data set named overall_data (order of subjectId, activity, and then test data)

*  Step 4: Appropriately labels the data set with descriptive variable names.
    + create a vector (overall_names) of existing colnames of overall_data dataset
    + using gsub, substitute existing names with better alternatives (i.e. mean instead of StdDev instead of -sd)
    + replace old overall_data colnames with new revised version from overall_names

*  Step 5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    + create a tidy aggregated data set, listed by subjectID and activity name, with mean as operation passed using aggregate() function
    + write final tidy data set using write.table()

