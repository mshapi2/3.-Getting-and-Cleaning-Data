3.-Getting-and-Cleaning-Data
============================

### Programming assignment Getting and Cleaning Data.

Prepare for future analysis a dataset with activity data recorded by a Samsung phone.

#### 1. Get the data set from 
####      http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#
#### 2. Merge the training and the test sets to create one data set.
#### 3. Extract only the measurements on the mean and standard deviation for each measurement. 
#### 4. Use descriptive activity names to name the activities in the data set
#### 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 

##### The script run_Analysis.R does the following:

Set the workspace environment, load required libraries

##### 1. Get the data
  
- donwload .zip file and unzip

##### 2. Merge the training and test sets into one dataset

- read the features to be used as colnames
- read the train data, add the subject and activity code columns

- read the test data, add the subject and activity code columns
- combine the train and test datasets

##### 3. Extract only the measurements on the mean and standard deviation for each measurement. 

- create a new dataset with columns that contain only mean and SD data

##### 4. Appropriately label the data set with descriptive activity names.
  
- read the activity labels
- use merge to insert activityLabels column into the combined dataset
  
##### 5. Create a tidy data set with the average of each variable for each activity and each subject.
  
- melt and dcast the merged dataset
- save the tidy dataset 

