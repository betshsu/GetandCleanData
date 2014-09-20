run_analysis.R Description
==========================

Overview
--------
The run_analysis.R code takes data accelerometer data from Samsung Galaxy S smartphone 
obtained as a zip file from the following link:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
and creates a wide, tidy data set of the average of the mean and standard deviation variables
for the various accelerometer measurements after grouping by subject and activity.  Please
see the code book file for more information on the variables and the files.

Requirements
------------
The run_analysis.R code must be in the same working directory as the top level UCI HAR Dataset
that is extracted from the zip files.  The directory structure of the files extracted from
the zip file should not be altered.
The run_analysis.R code also requires that the dplyr package be installed.

Description
------------
The overview of the script is as follows:
* Read in the required files from the UCI HAR Dataset
* Merge the files into a single data set as follows:
..* Add the subject information and the activity information as the first two columns of
the training and test datasets
..* Combine the training and testing datasets using rbind (in other words, the columns are
consistent between the training and testing datasets)
* Assign the variable names as the column names to the combined data set.  The variable names
were obtained from the features file
* Extract just the variables that are the mean and the standard deviation of the various
accelerometer measurements.  Note that the mean frequency measurements were not considered 
as a mean variable since it is not strictly just a mean measurement
* Replace the activity IDs (numbers) with the name of the activity 
* Rename the variables to conform to the tidy formate, eg
..* Remove underscores, dashes, etc
..* Remove all capitalization
..* Avoid abbreviations as much as possible