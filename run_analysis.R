##Define global variables
data_file_name <- "getdata-projectfiles-UCI HAR Dataset.zip"
file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"


##Automatically install required packages
if(!is.element("plyr", installed.packages()[,1])){
    print("Installing plyr package")
    install.packages("plyr")
}

print("Loading plyr package")
library(plyr)


##See if data is available and download if not
if(file.exists(data_file_name)){
    print("Data Already Exists")
} else{
    print("Data Does Not Exist, downloading...")
    download.file(file_url,data_file_name, mode = "wb")
}


##Create a folder for results
if(!file.exists("tidy_data_sets")){
    print("Creating tidy_data_sets folder")
    dir.create("tidy_data_sets")
}

##Utility function to read and bind dataset
getData <- function(type, features_data){  
    ##Get subject data
    subject_filename <- paste(type,"/","subject_",type,".txt",sep="")
    subject <- unz(data_file_name, 
                   paste("UCI HAR Dataset",subject_filename,sep="/"))
    subject_data <- read.table(subject,sep="",stringsAsFactors=F,col.names="id")
    
    ##Get y_data
    y_filename <- paste(type,"/","y_",type,".txt",sep="")
    y <- unz(data_file_name, 
        paste("UCI HAR Dataset",y_filename,sep="/"))
    y_data <- read.table(y,sep="",stringsAsFactors=F,col.names="activity")
    
    #get x_data
    x_filename <- paste(type,"/","X_",type,".txt",sep="")
    x <- unz(data_file_name, 
             paste("UCI HAR Dataset",x_filename,sep="/"))
    x_data <- read.table(x,sep="",stringsAsFactors=F,col.names=features_data$V2)
    
    ##bind data and return
    return (cbind(subject_data,y_data,x_data)) 
}

##Get data
##Use features.txt to get col names when creating data sets
features <- unz(data_file_name, paste("UCI HAR Dataset","features.txt",sep="/"))
features_data <- read.table(features,sep="",stringsAsFactors=F)

##Load data sets
print("Getting Train Data")
train_data <- getData("train",features_data)

print("Getting Test Data")
test_data <- getData("test",features_data)



#1. Merge train and test data sets and arrange by id
print("Merge the data")
merged_data <- rbind(train_data, test_data)
merged_data <- arrange(merged_data, id)




#2. Extract only the measurements on the mean and standard deviation for each
#   measurement
#3. Use descriptive activity names to name the activities in the data set
#4. Appropriately label the data set with descriptive variable names
# Get the labels from activity_labels.txt for use in the new tidy data set
labels <- unz(data_file_name, 
              paste("UCI HAR Dataset","activity_labels.txt",sep="/"))
labels_data <- read.table(labels,sep="",stringsAsFactors=F)
#set activity labels
merged_data$activity <- factor(merged_data$activity, 
                               levels=labels_data$V1, 
                               labels=labels_data$V2)
#only get data that contains either std or mean
ds1 <- merged_data[,c(1,2,grep("std", colnames(merged_data)), 
                           grep("mean", colnames(merged_data)))
                        ]
#Write file
print("Write first dataset to txt file")
write.table(ds1,paste("tidy_data_sets", "/","ds1.txt" ,sep=""),row.names=FALSE)




#5. Create a second, independent tidy data set with the average of each variable
#   for each activity and each subject
#calculate mean by id and activity
ds2 <- ddply(ds1, .(id, activity), .fun=function(z){ colMeans(z[,-c(1:2)]) })
#append _avg to all column names
colnames(ds2)[-c(1:2)] <- paste(colnames(ds2)[-c(1:2)], "_avg", sep="")
#Write file
print("Write second dataset to txt file")
write.table(ds2,paste("tidy_data_sets", "/","ds2.txt" ,sep=""),row.names=FALSE)