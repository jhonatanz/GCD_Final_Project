# I assume you have the unzipped "UCI HAR Dataset" directory in the working directory, and you
# source and run this script from there.
# Please note that all the variables and data will be created on the working directory.
# Loading libraries
library(dplyr)
library(reshape2)

rm(list=ls())
## Creating path to files
path_X_test<-"UCI HAR Dataset/test/X_test.txt"
path_Y_test<-"UCI HAR Dataset/test/y_test.txt"
path_X_train<-"UCI HAR Dataset/train/X_train.txt"
path_Y_train<-"UCI HAR Dataset/train/y_train.txt"
path_activity_labels<-"UCI HAR Dataset/activity_labels.txt"
path_features<-"UCI HAR Dataset/features.txt"
path_sub_test<-"UCI HAR Dataset/test/subject_test.txt"
path_sub_train<-"UCI HAR Dataset/train/subject_train.txt"

## Reading data
f_names<-read.table(path_features, stringsAsFactors = FALSE)
act_lab<-read.table(path_activity_labels, stringsAsFactors = FALSE)
testDS<-read.table(path_X_test, stringsAsFactors = FALSE)
trainDS<-read.table(path_X_train, stringsAsFactors = FALSE)
act_col_testDS<-read.table(path_Y_test, stringsAsFactors = FALSE)
act_col_trainDS<-read.table(path_Y_train, stringsAsFactors = FALSE)
sub_test<-read.table(path_sub_test, stringsAsFactors = FALSE)
sub_train<-read.table(path_sub_train, stringsAsFactors = FALSE)

# Step 1: Merges the training and the test sets to create one data set.
testDS<-cbind(testDS, act_col_testDS, sub_test) ##activity and subject added in the last columns
trainDS<-cbind(trainDS, act_col_trainDS, sub_train) ##activity and subject added in the last columns
DataSet<-rbind(trainDS, testDS)
## since activity and subject columns has the same name i must to convert in unique
names(DataSet)<-make.unique(names(DataSet))

# Step 2:Extracts only the measurements on the mean and standard deviation 
# for each measurement.
sel_vec<-grep("mean|std", f_names$V2)
DataSet<-select(DataSet, c(sel_vec, 562, 563))
## the last numbers added is for the activity and subject columns

# Step 3: Uses descriptive activity names to name the activities in the data set.
## the column for activity is V1.1 after make.unique, splitting per activity
s<-split(DataSet, DataSet$V1.1)
## Using lapply with replace function by each group splitted
x1<-lapply(s, function(x) replace(x$V1.1, values = act_lab$V2[x$V1.1[1]]))
DataSet$V1.1<-unlist(x1)

# Step 4: Appropriately labels the data set with descriptive variable names.
## Selecting from f_names data frame (for features names). Adding "Activity" label for last
## column.
names(DataSet)<-c(f_names$V2[sel_vec], "Activity", "Subject")

#Step 5: From the data set in step 4, creates a second, independent tidy data set with the 
#average of each variable for each activity and each subject.
DataSet2<-DataSet %>% group_by(Subject, Activity) %>% summarise_at(1:length(sel_vec), mean)

##organizing dataset1
DataSet1<-cbind(DataSet$Subject, DataSet$Activity, DataSet[,1:length(sel_vec)])
names(DataSet1)[1:2]<-c("Subject", "Activity")

## Generate the datasets
write.csv(DataSet1, "DataSet1.csv")
write.csv(DataSet2, "DataSet2.csv")