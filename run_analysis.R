#Packages sqldf, reshape and reshape2 need to be installed

#Read the data files
features<-read.table("./UCI HAR Dataset/features.txt")
activities<-read.table("./UCI HAR Dataset/activity_labels.txt")
x_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
x_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")

#Assign the names of the features after formatting them to both test & train dataframes
names(x_test)<-tolower(gsub("_|-|\\(|\\)|\\,", "",features[,2]))
names(x_train)<-tolower(gsub("_|-|\\(|\\)|\\,", "",features[,2]))

#Add the activities and subjects to the x's dataframes, naming them as "activitycode" and "subjectid"
x_test$activitycode<-y_test$V1
x_train$activitycode<-y_train$V1
x_test$subjectid<-subject_test$V1
x_train$subjectid<-subject_train$V1

#Join the x's dataframes with  activities df to include the activity names
library(sqldf)
x_test<-sqldf("SELECT * FROM activities A,x_test B where A.V1=B.activitycode")
x_train<-sqldf("SELECT * FROM activities A,x_train B where A.V1=B.activitycode")

#merge the test and train dataframes into widedf
widedf<-rbind(x_test,x_train)

#rename the column of the activity names
colnames(widedf)[2]<-"activity"

#create a narrow dataframe taking just the columns requested
narrowdf<-widedf[,names(widedf)[grepl("mean|std|subjectid|^activity$",names(widedf))]]
library(reshape)

#melt the narrow dataset, get the averages of the variables, and unmelt it, finally getting the tidy dataset
meltnarrowdf<-melt(narrowdf,id=c("subjectid","activity"))
avgdf<-sqldf("SELECT subjectid, activity, variable, avg(value) FROM meltnarrowdf GROUP BY subjectid, activity, variable")
library(reshape2)
tidy<-dcast(avgdf,subjectid + activity ~ variable)
write.table(tidy, "tidy.txt",row.names=FALSE)
