run_analysis.R Description
==========================

Overview
--------
The run_analysis.R code takes data accelerometer data from Samsung Galaxy S smartphone 
obtained as a zip file from the following link:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
and creates a wide, tidy data set of the average of the mean and standard deviation variables
for the various accelerometer measurements after grouping by subject and activity.  Please
see the code book file for more information on the variables of the output file.

Requirements
------------
The run_analysis.R code must be in the same working directory as the top level UCI HAR Dataset
that is extracted from the zip files.  The directory structure of the files extracted from
the zip file should not be altered.
The run_analysis.R code also requires that the dplyr package be installed.

Overview of Script
------------------
The overview of the script is as follows:
* Read in the required files from the UCI HAR Dataset
* Merge the files into a single data set as follows:
  * Add the subject information and the activity information as the first two columns of
the training and test datasets
  * Combine the training and testing datasets using rbind (in other words, the columns are
consistent between the training and testing datasets)
* Assign the variable names as the column names to the combined data set.  The variable names
were obtained from the features file
* Extract just the variables that are the mean and the standard deviation of the various
accelerometer measurements.  Note that the mean frequency measurements were not considered 
as a mean variable since it is not strictly just a mean measurement
* Replace the activity IDs (numbers) with the name of the activity 
* Create a dataset with just the subject, activity names, and mean and standard deviation 
measurements
* Rename the variables to conform to the tidy format, eg:
  * Remove underscores, dashes, etc
  * Remove all capitalization
  * Avoid abbreviations as much as possible
* Calculate the average of each variable after grouping by the subject and activity.  Note
that this step requires use of the dplyr package
  
Specifics of Each Step
----------------------
### Read in files
Since the files are stored locally in the UCI HAR Dataset folder, read.table is used to load
the following files:
* features.txt -- to be used to rename the variable names
* activity_labels.txt -- to be used to rename activity IDs to activity names
* X_test.txt -- the test data
* Y_test.txt -- the activities for the test data
* subject_test.txt -- the subject IDs for the test data
* X_train.txt -- the training data
* Y_train.txt -- the activities for the training data
* subject_train.txt -- the subject IDs for the training data

### Merging files into a single dataset
The files were merged using a combination of cbind and rbind.  Specifically, cbind
was used to add the subject information (subject_test or subject_train) and the activity 
information (Y_test or Y_train) as the first two columns to the test (X_test) or training
(X_train) respectively.  rbind was then used to combine the test data set and the training 
data set.

### Assigning variable names
The first two columns were manually assigned, using "subject" and "activity" as the names.
The names for the remainder of the columns were obtained from the features.txt file.  A
vector with "subject", "activity", the data (ie variable names) from the features.txt file
was created.  colnames was then used to assign this vector as the column names for the 
combined dataset.

### Extract mean and standard deviation variables
The mean and standard deviation variables were extracted using the grep function.  For the
mean, the meanFreq variables had to be excluded

### Rename the activity IDs
The activity_labels.txt file was used as a look up table to reassign activity IDs to their 
actual name.  The match function was used to find the activity ID that was the same
and the activity ID replaced with the corresponding activity name.

### Create the final dataset
cbind was used to combine the subject IDs, activity names, the mean subset and standard
deviation subset of the data

### Rename variables
Variables were renamed using the sub or gsub functions to conform to tidy data standards

### Average the data
The data was first grouped by subject and activity using the group_by function in the dplyr
package.  The average of each variable was then calculated using the summarise_each function
in the dplyr package.  The variable names were modified to add "avg" to the end of each
variable.