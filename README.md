GettingandCleaningData
======================

This repository is used to house the project assignment for the "Getting and Cleaning Data" course



## README for run_analysis.R 
### This script will install the necessary R packages and perform needed opration to achieve the following: 
    
  1.  Merges the training and the test sets to create one data set.
  2.  Extracts only the measurements on the mean and standard deviation for each measurement. 
  3.  Uses descriptive activity names to name the activities in the data set
  4.  Appropriately labels the data set with descriptive variable names. 
  5.  Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
 
## Assumptions: 
  1.  The source zip file has been manually downloaded and extracted, here is link to the data for the project:
          https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
  2.  All of the data files needed for the analysis have been copied into the appropriate working directory 

## R packages required: 
  1.  Install "plyr" packages to get "join" function
  2.  Install "reshape2" package to get "melt" and "dcast" functions
  3.  Install "foreign" package to get "write.table" function for export data frame to file for tidy dataset upload

## Detail outline of the run_analysis.R script
  1.  Read the column labels file "features.txt" using read.table into dataframe colNames
  2.  Read in the activity labels file "activity_labels.txt" into dataframe actNames & name the columns
  3.  Read the test activity file "y_test.txt" using read.table into dataframe y_test
  4.  Read the training activity file "y_train.txt" using read.table into dataframe y_train
  5.  Read the test activity measurements file "x_test.txt" using read.table into dataframe x_test
  6.  Read the training activity measurements file "x_train.txt" using read.table into dataframe x_train
  7.  Merge the training and test activity dataset into dataframe humanAct using rbind function
  8.  Name the column for humanAct with more descriptive name using colnames function
  9.  Add ActName column by looking up the activity name on "activity_labels.txt" based on the ActNo using join function, this will provide more meaningful activity names instead of the original activity number in the y_* files 
  10. Merge the training & test activity measurements datasets inro dataframe humanActRec
  11. Create a dataframe with column position and the corresponding column name for all of the selected columns by selecting only column names with "std" or "mean" in them. "grep" function is used for column name patterns matching, and the "rbind" function is used to concatenate the selected column positions and names
  12. Remove any special characters from the column names using gsub, this will allow easier manipulation of the columns later on.  Reusing and transformation the measurement names provided by the data source to achieve project goal#4.
  13. Re-order the final columns dataframe and create two vectors for use later:
    - colList = Column position for each of the chosen columns
    - colNameList = Column name for each of the chosen columns
  14. Create dataframe humanActDF with only the chosen measurements columns using colList and name the new dataframe columns with the previously created column names vector colNameList
  15. Create final merged dataframe FinalHumanActDF by column combined the "Y" (i.e. activity) and the "X" (measurements) dataframes using cbind function
  16. Create tall/narrow dataset meltDF using melt function, this dataset will be used to create the final tidy dataset
  17. Create the final tidy dataset tidyDF using dcast function to take average of each selected measurements by activity
  18. Export the final tidy dataframe to a flat/text file using write.tablel function


