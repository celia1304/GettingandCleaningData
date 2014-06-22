## This script will install the necessary R packages and perform needed opration to achieve the following: 
## 
##  1.  Merges the training and the test sets to create one data set.
##  2.  Extracts only the measurements on the mean and standard deviation for each measurement. 
##  3.  Uses descriptive activity names to name the activities in the data set
##  4.  Appropriately labels the data set with descriptive variable names. 
##  5.  Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
## 
##  Assumptions: 
##  1.  The source zip file has been manually downloaded and extracted
##  2.  All of the data files needed for the analysis have been copied into the appropriate working directory 

## Install "plyr" packages to get "join" function
install.packages("plyr")
library("plyr")

## Install "reshape2" package to get "melt" and "dcast" functions
install.packages("reshape2")
library("reshape2")

## Install "foreign" package to get "write.table" function for export data frame to file for tidy dataset upload
install.packages("foreign")
library("foreign")

## reading the column labels file
colNames <- read.table("features.txt")

## Read in the activity labels file & name the columns
actNames <- read.table("activity_labels.txt")
colnames(actNames) <- c("ActNo", 'ActName')

## Read the "test" & "training" activity datasets
y_test <- read.table('y_test.txt')
y_train <- read.table("y_train.txt")

## Read the "test" & "training" measurements datasets
x_test <- read.table('x_test.txt')
x_train <- read.table("x_train.txt")

## 1. Merge the training & test activity datasets
## 2. Name the column for the combined dataset
## 3. Add ActName column by looking up the activity name on "activity_labels.txt" based on the ActNo
humanAct <- rbind(y_train, y_test)
colnames(humanAct) <- c("ActNo")
humanAct1 <- join(humanAct, actNames, by="ActNo")

## Merge the training & test activity measurements datasets
humanActRec <- rbind(x_train, x_test)

## Create a dataframe with column position and the corresponding column name for all of the selected columns by
## selecting only column names with "std" or "mean" in them. 
finalCol <- rbind(colNames[grep('mean', colNames[,2], ignore.case=TRUE),], 
                  colNames[grep('std', colNames[,2], ignore.case = TRUE),])

## Remove any special characters from the column names
finalCol[,2] <- gsub("\\(", "", finalCol[,2])
finalCol[,2] <- gsub("\\)", "", finalCol[,2])

## Re-order the final columns dataframe and create two vectors: 
##      1. Column position for each of the chosen columns
##      2. Column name for each of the chosen columns
fCol <- finalCol[order(as.numeric(finalCol[,1])),]
colList <- fCol[,1]
colNameList <- fCol[,2]

## Create dataframe with only the chosen measurements columns
## Name the new dataframe columns with the previously created column names vector
humanActDF <- humanActRec[,colList]
colnames(humanActDF) <- colNameList

## Create final merged dataframe by column combined the "Y" (i.e. activity) and the "X" (measurements) dataframes 
FinalHumanActDF <- cbind(humanAct1, humanActDF)

## Melt the dataframe by Activity and create "tidy" dataframe with the average of each meansurement by activity 
meltDF <- melt(FinalHumanActDF, id=c("ActName"), measure.vars=colNameList)
tidyDF <- dcast(meltDF, ActName ~ variable, mean)

## Export the final tidy dataframe to a flat/text file
write.table(tidyDF, "average_measure_by_activity1.txt", sep="\t")


