library(dplyr)

#Downloading and unzipping the dataset to work with

if(!file.exists("./data")){dir.create("./data")}
# Retrieving dataset
fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")



#Step 1.Merges the training and the test sets to create one data set.

# 1.1 Reading files

# 1.1.1 Reading files from train data set
xtrain = read.table("./data/UCI HAR Dataset/train/x_train.txt")
ytrain = read.table("./data/UCI HAR Dataset/train/y_train.txt")
maintrain = read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# 1.1.2 Reading files from test data set
xtest = read.table("./data/UCI HAR Dataset/test/x_test.txt")
ytest = read.table("./data/UCI HAR Dataset/test/y_test.txt")
maintest = read.table("./data/UCI HAR Dataset/test/subject_test.txt")


features = read.table('./data/UCI HAR Dataset/features.txt')

# 1.1.4 Reading activity labels:
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

# Assigning the column names

colnames(xtrain) = features[,2]
colnames(ytrain) ="activityId"
colnames(subject_train) = "subjectId"

colnames(xtest) = features[,2] 
colnames(ytest) = "activityId"
colnames(subject_test) = "subjectId"

colnames(activityLabels) = c('activityId','activityType')

#1.3 Merging both datasets into one

merge_train = cbind(ytrain, maintrain, xtrain)
merge_test = cbind(ytest, maintest, xtest)
setAllInOne = rbind(merge_train, merge_test)



#Step 2.-Extracts only the measurements on the mean and standard deviation for each measurement.


# Reading the column names

colNames = colnames(setAllInOne)

# Creating vectors for defining ID, mean and standard deviation:

mean_std = (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

# Making subsets from setAllInOne:

setForMeanAndStd = setAllInOne[ , mean_std == TRUE]


#Step 3. Uses descriptive activity names to name the activities in the data set

setWithActivityNames = merge(setForMeanAndStd, activityLabels, by='activityId', all.x=TRUE)


#Step 4. Appropriately labels the data set with descriptive variable names.


# Done previously in step 1 and 2


#Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


#Making a second tidy data set

secTidySet = aggregate(.~subjectId + activityId, setWithActivityNames, mean)
secTidySet = secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

#Writing second tidy data set in txt file

write.table(secTidySet, "tidy_data.txt", row.name=FALSE)
