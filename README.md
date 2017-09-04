# FINAL PROJECT
##Getting and cleaning data
##README
This dataset is composed by two files (.csv) derived from the original dataset from the following link: [Original data set](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) 
The original dataset has information about measurements on 30 subjects that wear a celphone with acelerometers, there were three classes of states to be reconigzed:
- Walking
- Walking upstairs
- Walking downstairs
- Standing
- Laying
- Sitting
The variables measured by accelerometers were transformed in to 561 variables.
The original dataset was modified to obtain a file "DataSet1.csv" in which 79 variables were selected, only means and standard deviations of the original measurements.
The second available file is "DataSet2.csv" in which we summarise the average of each of 79 variables grouped by subject and activity.