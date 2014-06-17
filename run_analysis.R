## Programming assignment Getting and Cleaning Data. 
## 1. Get the data set from 
##      http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#
## 2. Merge the training and the test sets to create one data set.
## 3. Extract only the measurements on the mean and standard deviation for each measurement. 
## 4. Use descriptive activity names to name the activities in the data set
## 5. Appropriately label the data set with descriptive activity names. 
## 6. Create a second, independent tidy data set with the average of each variable
##      for each activity and each subject. 


## Set the workspace environment
  dirProject<-"/Coursera/JohnsHopkins-Data-Science/3. Getting and Cleaning Data/Peer asignment . June 2 session"
  setwd(paste(setwd("~/"),dirProject, sep="", collapse=NULL))

  if (!"data.table" %in% installed.packages()) install.packages("data.table")
  library(data.table)
  if (!"Hmisc" %in% installed.packages()) install.packages("Hmisc")
  library("Hmisc") 
  if (!"plyr" %in% installed.packages()) install.packages("plyr")
  library("plyr") 
## 1. Get the data
  
# donwload .zip file and unzip
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, dest="dataset.zip")
  unzip("dataset.zip", list=FALSE)
# change working directory to the unzipped data
  setwd("./UCI HAR Dataset")

## 2. Merge the training and test sets into one dataset

# read the features to be used as colnames
  features<-fread("./features.txt")
  featureNames <- features$V2
# read the train data, set column names
# NB: fread() failed  for X_train because of two leading spaces in each row
# the dataset may be large, so use the trick from R programming
  temp <- read.table("./train/X_train.txt", nrows=100) # read small number of rows
  classes <- sapply(temp,class)  # determine the calss of each column
  trainX <- read.table("./train/X_train.txt", colClasses = classes) # read the full dataset
  trainSubject <- as.data.frame(fread("./train/subject_train.txt"))
  trainActivity <- as.data.frame(fread("./train/y_train.txt"))
# cbind all columns in a single train dataframe. NB: all train vectors have the same length
  trainData <- cbind(trainSubject, trainActivity , trainX)

# read the test data
  temp <- read.table("./test/X_test.txt", nrows=100) # read small number of rows
  classes <- sapply(temp,class)  # determine the calss of each column
  testX <- read.table("./test/X_test.txt", colClasses = classes) # read the full dataset
  testSubject <- as.data.frame(fread("./test/subject_test.txt"))
  testActivity <- as.data.frame(fread("./test/y_test.txt"))
# cbind all columns in a single test dataframe
  testData <- cbind(testSubject, testActivity , testX)

# rbind the test and train datasets
  allData <- rbind(trainData,testData)
# assign column names
  colnames(allData)<- c("subject", "activityCode", featureNames)

## 3. Extract only the measurements on the mean and standard deviation for each measurement. 

# get the column names with "mean" and "std"
  namesMeanStd <- (grep(paste(c("mean","std"),collapse="|"), 
                         names(allData), ignore.case=TRUE, value=TRUE))
  allMeanStd <- allData[, c("subject","activityCode",namesMeanStd)]

## 4-5. Appropriately label the data set with descriptive activity names.
  
# add a column with activityLabels
# read the activity labels
  activityLabels <- read.table("./activity_labels.txt", 
                               as.is=TRUE, col.names=c("activityCode","activityLabel"))
# use merge to insert activityLabels column
  allActivity <- merge(activityLabels,allMeanStd,by.x="activityCode", by.y="activityCode")
# order (easier to quickly compare with allMeansStd to see if the merge is correct)
  allActivity <- allActivity[order(allActivity$subject,allActivity$activityCode),]
  
## 6. Create a tidy data set with the average of each variable
##      for each activity and each subject.
  
# melt prepares the data for using dcast  
  allMelted <- melt(allActivity, id=c("subject", "activityCode","activityLabel"),
                  measure.vars=namesMeanStd)
  allTidy <- dcast(allMelted, subject+activityCode+activityLabel ~ variable, mean)
# save the tidy dataset 
  write.table(allTidy,"./tidy_dataset.txt")

