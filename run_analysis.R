library(reshape2)
zipfilename<-"getdata-projectfiles-UCI HAR Dataset.zip"
## Download the zip file containing dataset:
if(!file.exists(zipfilename)){
        fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL,zipfilename,method="curl")
}
if(!file.exists("UCI HAR Dataset")){
        unzip(zipfilename)
}
## Load activity labels and features
activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character")
features<-read.table("UCI HAR Dataset/features.txt",header=FALSE, colClasses="character")
##Extract data containing mean and standard deviation
dataWanted<-grep(".*mean.*|.*std.*",features)
dataWanted_names<-features[dataWanted,2]
dataWanted_names<-gsub('-mean','Mean',dataWanted_names)
dataWanted_names<-gsub('-std','Std',dataWanted_names)
dataWanted_names<-gsub('[-()]','',dataWanted_names)
## Load the datasets
# Load train datasets
train<-read.table("UCI HAR Dataset/train/X_train.txt")[dataWanted]
train_activities<-read.table("UCI HAR Dataset/train/Y_train.txt")
train_subjects<-read.table("UCI HAR Dataset/train/subject_train.txt")
train<-cbind(train_subjects,train_activities,train)
#Load test datasets
test<-read.table("UCI HAR Dataset/test/X_test.txt")[dataWanted]
test_activities <- read.table("UCI HAR Dataset/test/Y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_subjects, test_activities, test)
#Now merge datasets and add labels
final_data<-rbind(train,test)
colnames(final_data)<-c("subject","activity",dataWanted_names)
#Now turn activities and subjects into factors
final_data$activity<-factor(final_data$activity,levels=activity_labels[,1],labels=activity_labels[,2])
final_data$subject<-as.factor(final_data$subject)

final_data_melted<-melt(final_data,id=c("subject","activity"))
final_data_mean<-dcast(final_data_melted,subject + activity ~ variable,mean)

#write.table(final_data_mean,file="tidy.csv",sep=",",row.names = FALSE,quote=FALSE)
write.table(final_data_mean,file="tidy.txt",row.names = FALSE,quote=FALSE)




