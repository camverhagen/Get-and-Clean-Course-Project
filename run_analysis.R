library(dplyr)

##Check for download directory
if(!file.exists("data")) {
  dir.create("data")
}

##Download data files
fileURL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile="./data/UCI HAR Dataset.zip")

##Unzip download file
filePath <- "./data/UCI HAR Dataset.zip"
unzip(filePath, exdir="./data")

##Reads data
features <- read.table("./data/UCI HAR Dataset/features.txt")
activity <- read.table("./data/UCI HAR Dataset/activity_labels.txt", col.names = c("activity cde", "activity nme"))
subtest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
subtrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
Xtest <- read.table("./data/UCI HAR Dataset/test/X_test.txt", col.names = features$V2)
Xtrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt", col.names = features$V2)
Ytest <- read.table("./data/UCI HAR Dataset/test/Y_test.txt", col.names = "activity.cde")
Ytrain <- read.table("./data/UCI HAR Dataset/train/Y_train.txt", col.names = "activity.cde")

##Converts tables to data frames
Xtest <- tbl_df(Xtest)
Xtrain <- tbl_df(Xtrain)
Ytest <- tbl_df(Ytest)
Ytrain <- tbl_df(Ytrain)
subtest <- tbl_df(subtest)
subtrain <- tbl_df(subtrain)
activity_labels <- tbl_df(activity)

##Merges data
Xall <- rbind(Xtest, Xtrain)
Yall <- rbind(Ytest, Ytrain)
Dall <- cbind(Yall, Xall)
Suball <- rbind(subtest, subtrain)

##Creates final data set
AlmostAll <- cbind(Suball, Dall)
All <- merge(AlmostAll, activity_labels, by="activity.cde")

##Subsetting to Columns representing mean and std metrics
##Excluding the Frequency transformation metrics
df1 <- select(All, subject, activity.nme, contains("mean"), contains("std"), -contains("Freq"))
df2 <- select(df1, subject, activity.nme, starts_with("t"))

##Summarizing by Activity and Subject using the mean() function.
df3 <- df2 %>% group_by(activity.nme, subject) %>% summarise_each(funs(mean))

write.table(df3, file = "./data/tidy_data_set.txt", row.names=FALSE)