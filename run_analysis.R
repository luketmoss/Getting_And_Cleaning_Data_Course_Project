##Define global variables
data_file_name <- "getdata-projectfiles-UCI HAR Dataset.zip"


##Required packages
if(!is.element("plyr", installed.packages()[,1])){
    print("Installing plyr package")
    install.packages("plyr")
}

print("Loading plyr package")
library(plyr)


##See if data is available and download if not
if(file.exists(data_file_name)){
    print("Data Exists")
} else{
    print("Data Does Not Exist, downloading...")
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",data_file_name, mode = "wb")
}

##Create a folder for results
if(!file.exists("results")){
    print("Creating results folder")
    dir.create("results")
} else{
    print("Results folder already exists")
}


##Use features.txt to get col names when creating data sets
f <- unz(data_file_name, paste("UCI HAR Dataset","features.txt",sep="/"))
features <- read.table(f,sep="",stringsAsFactors=F)