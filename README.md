#Purpose
The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. 

#Instruction List
Step 1 - Execute run_analysis.R

#Files in this Repository
##CodeBook.md
This file contains the variables and details about the tidy sets (ds1.txt and ds2.txt).

##README.md
This contains the purpose, instruction list, and description of files

##run_analysis.R
This is the main R script which does the following:
*Checks to see if the input data is already in the directory
**If it is not, it is downloaded
*Checks to see if the appropriate packages are installed
**The only required package is 'plyr'
*Creates a results directory for the new tidy data sets
**If one already exists, this is skipped
*Merges the training and test sets to create a single data set
**Uses a utility function called getData to retrieve the test data and training data
**The merge is done using 'rbind' and then arranged by id
*The data is then subsetted to only retrieve columns that contain 'mean' or 'std'
**The activity id's are replaced with appropriate activity names
*A txt file is generated with this data set (ds1.txt)
*Another dataset (ds2.txt) is created that calculates the average of each variable for each activity and each subject

	

