#load in files needed
data_labels <- read.table(file='UCI HAR Dataset/features.txt')
activity_labels <- read.table(file='UCI HAR Dataset/activity_labels.txt')

test_data <- read.table(file='UCI HAR Dataset/test/X_test.txt')
test_activity <- read.table(file='UCI HAR Dataset/test/Y_test.txt')
test_subject <- read.table(file='UCI HAR Dataset/test/subject_test.txt')

train_data <- read.table(file='UCI HAR Dataset/train/X_train.txt')
train_activity <- read.table(file='UCI HAR Dataset/train/Y_train.txt')
train_subject <- read.table(file='UCI HAR Dataset/train/subject_train.txt')

#add subject information and activity information as the first two columns to train and test data
full_test_data <- cbind(test_subject, test_activity, test_data)
full_train_data <- cbind(train_subject, train_activity, train_data)

#combine test data and train data into single data set
full_data <- rbind(full_test_data, full_train_data)

#assign column names of data set
col_labels <- c("subject", "activity", as.character(data_labels[,2]))
colnames(full_data) <- col_labels

#extract column indices with mean
all_mean_index <- grep("mean", names(full_data)) #provides indices of all columns with any occurrence of "mean" -- this also includes "meanFreq"
no_mean_freq_index <- grep("meanFreq", names(full_data)[all_mean_index], invert=TRUE) #provides indices of all columns within the subset of columsn with "mean" in the name that do not include "meanFreq"
mean_index <- all_mean_index[no_mean_freq_index] #index number of all columns with just "mean" in the name

#extract column incides with std
std_index <- grep("std", names(full_data))

#create vector with activity names using activity labels as the look up table
colnames(activity_labels) <- c("id", "activity")
activity_names <- activity_labels[match(full_data[,2], activity_labels$id), 2]

#create data set with just mean and std

mean_std_data <- cbind("subject" = full_data[,1], "activity" = activity_names, full_data[,mean_index], full_data[,std_index])

#rename variables
varnames <- names(mean_std_data)
newvarnames <- sub("\\(\\)","", varnames)
newvarnames <- gsub("-", "", newvarnames)
newvarnames <- sub("tBodyAcc", "bodyacceleration", newvarnames)
newvarnames <- sub("tGravityAcc", "gravityacceleration", newvarnames)
newvarnames <- sub("tBodyAccJerk", "bodyaccelerationjerk", newvarnames)
newvarnames <- sub("tBodyGyro", "bodygyro", newvarnames)
newvarnames <- sub("tBodyGyroJerk", "bodygyrojerk", newvarnames)
newvarnames <- sub("tBodyAccMag", "bodyaccelerationmagnitude", newvarnames)
newvarnames <- sub("tGravityAccMag", "gravityaccelerationmagnitude", newvarnames)
newvarnames <- sub("tBodyAccJerkMag", "bodyaccelerationjerkmagnitude", newvarnames)
newvarnames <- sub("tBodyGyroMag", "bodygyromagnitude", newvarnames)
newvarnames <- sub("fBodyAcc", "fftbodyacceleration", newvarnames)
newvarnames <- sub("fBodyAccJerk", "fftbodyaccelerationjerk", newvarnames)
newvarnames <- sub("fBodyGyro", "fftbodygyro", newvarnames)
newvarnames <- sub("fBodyAccMag", "fftbodyaccelerationmagnitude", newvarnames)
newvarnames <- sub("fBodyAccJerkMag", "fftbodyaccelerationjerkmagnitude", newvarnames)
newvarnames <- sub("fBodyGyroMag", "fftbodygyromagnitude", newvarnames)
newvarnames <- sub("fBodGyroJerkMag", "fftbodgyrojerkmagnitude", newvarnames)
newvarnames <- sub("fBodyBodyAccJerkMag", "fftbodyaccelerationjerkmagnitude", newvarnames)
newvarnames <- sub("fBodyBodyGyroMag", "fftbodygyromagnitude", newvarnames)
newvarnames <- sub("fBodyBodyGyroJerkMag", "fftbodygyrojerkmagnitude", newvarnames)

colnames(mean_std_data) <- newvarnames

#calculate average of each variable after grouping by subject and activity.  uses dplyr package
library (dplyr)
new_mean_std_data <- tbl_df(mean_std_data)
grouped_data <- group_by(new_mean_std_data, subject, activity)
averaged_data <- summarise_each(grouped_data, funs(mean))
avg_col_names <- c(newvarnames[1:2], paste(newvarnames[3:68], "avg", sep=""))
colnames(averaged_data) <- avg_col_names
