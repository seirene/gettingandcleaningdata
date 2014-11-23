## course project for getting and cleaning data

# 1. Merges the training and the test sets to create one data set.

trainingdatalabels <- read.table("UCI HAR Dataset/train/Y_train.txt")
testdatalabels <- read.table("UCI HAR Dataset/test/Y_test.txt")

labels <- rbind(trainingdatalabels, testdatalabels)

trainingdatasubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
testdatasubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

subjects <- rbind(trainingdatasubjects, testdatasubjects)

trainingdata <- read.table("UCI HAR Dataset/train/X_train.txt")
testdata <- read.table("UCI HAR Dataset/test/X_test.txt")

alldata <- rbind(trainingdata, testdata)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

features <- read.table("UCI HAR Dataset/features.txt", row.names=1)

strmean <- "mean()"
strstd <- "std()"
meanvalues <- c()
stdvalues <- c()
for (i in 1:length(features[,1])){
    if (grepl(strmean, features[i,1]) > 0){
        meanvalues <- c(meanvalues, i)
    }
    if (grepl(strstd, features[i,1]) > 0){
        stdvalues <- c(stdvalues, i)      
    }    
}
#print(head(meanvalues))
#print(head(stdvalues))

meandata <- alldata[meanvalues]
stddata <- alldata[stdvalues]

# 3. Uses descriptive activity names to name the activities in the data set

activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt", row.names=1)
dataactivities <- data.frame(activitylabels[labels[,1],1])

# 4. Appropriately labels the data set with descriptive variable names. 

datawnames <- cbind(meandata, stddata)
datawnames <- cbind(datawnames, dataactivities)
datawnames <- cbind(datawnames, subjects)

colnames(datawnames) <- c(as.vector(features[meanvalues, 1]), as.vector(features[stdvalues, 1]), "activity", "subject")

#print(head(datawnames))

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

datasummary <- aggregate(datawnames[1:(length(datawnames)-2)], by=list(datawnames$subject, datawnames$activity), FUN=mean)
print(head(datasummary))
