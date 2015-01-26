######################################################################

## Getting and Cleaning Data Course Project
## Patrick Sturgill

# You should create one R script called run_analysis.R that does the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data
#    set with the average of each variable for each activity and each subject.

# Data obtained from: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

#######################################################################


#-------------------
# 1. Merges the training and the test sets to create one data set.
#-------------------

# set working directory 
setwd('/Users/Michael/Documents/UCI HAR Dataset')


# read activity labels & features
features <- read.table("./features.txt") #imports features.txt
activity_labels <- read.table("./activity_labels.txt") #imports activity_labels.txt
colnames(activity_labels) <- c('activityId', 'activityType') #rename activity_label columns


# read x data
x_train <- read.table("train/X_train.txt")
colnames(x_train) <- features[,2]  #rename x_train columns
x_test <- read.table("test/X_test.txt")
colnames(x_test) <- features[,2]  #rename x_test columns


# read y data
y_train <- read.table("train/y_train.txt")
colnames(y_train) <- "activity" #rename y_train columns
y_test <- read.table("test/y_test.txt")
colnames(y_test) <- "activity" #rename y_test columns


# read subject data
subject_train <- read.table("train/subject_train.txt")
colnames(subject_train) <- "subjectId" #rename subject_train columns
subject_test <- read.table("test/subject_test.txt")
colnames(subject_test) <- "subjectId" #rename subject_test column


# create datasets (x, y, and subject)
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)


#-------------------
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#-------------------

# get only columns with mean() or std() in their names
mean_std_names <- grep("-(mean|std)\\(\\)", features[, 2])

# subset columns to only have mean_std_names
x_data <- x_data[, mean_std_names]



#-------------------
# 3. Uses descriptive activity names to name the activities in the data set
#-------------------
y_data[, 1] <- activity_labels[y_data[, 1], 2]

# bind into a single overall dataframe
overall_data <- cbind(subject_data, y_data, x_data) 



#-------------------
# 4. Appropriately labels the data set with descriptive variable names. 
#-------------------

# retrieve vector of colnames of overall_data
overall_names <- colnames(overall_data)

# clean vector colnames
for (i in 1:length(overall_names)) 
{
      overall_names[i] = gsub("()", "" , overall_names[i])
      overall_names[i] = gsub("-std()", " StdDev", overall_names[i])
      overall_names[i] = gsub("-mean()", " Mean", overall_names[i])
      overall_names[i] = gsub("^(t)", " time", overall_names[i])
      overall_names[i] = gsub("^(f)", " frequency", overall_names[i])
      overall_names[i] = gsub("BodyBody", "Body", overall_names[i])
      overall_names[i] = gsub("[Bb]odyaccjerkmag","BodyAccJerkMagnitude", overall_names[i])
      overall_names[i] = gsub("Mag","Magnitude", overall_names[i])
      overall_names[i] = gsub("([Gg]ravity)","Gravity", overall_names[i])
};

# Reassign names using new colnames vector
colnames(overall_data) <- overall_names



#-------------------
# 5. From the data set in step 4, creates a second, independent tidy data
#    set with the average of each variable for each activity and each subject.
#-------------------


# create aggregate of overall_data sorting by subject and then activity, and making a mean of groups
tidy_data <- aggregate(overall_data[,3:ncol(overall_data)], by=list(subject=overall_data$subjectId, label = overall_data$activity), FUN=mean)

# write the final 
write.table(format(tidy_data, scientific=T), "tidy.txt", row.name=F)
