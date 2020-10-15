# 1. Merges the training and the test sets to create one data set. 
# & 4. Appropriately labels the data set with descriptive variable names.
name<-read.table("features.txt")
x_test<-read.table("./test/X_test.txt") 
names(x_test)<-make.names(names=name[,2],unique = TRUE,allow_=TRUE)
y_test<-read.table("./test/y_test.txt")
names(y_test)<-"activity"
whole_test<-cbind(x_test,y_test)
x_train<-read.table("./train/X_train.txt")
names(x_train)<-make.names(names=name[,2],unique = TRUE,allow_=TRUE)
y_train<-read.table("./train/y_train.txt")
names(y_train)<-"activity"
whole_train<-cbind(x_train,y_train)
library(plyr)
all<-list(whole_test,whole_train)
final<-join_all(all)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.
mean_std<-final[,grepl("mean()",names(final))| grepl("std()",names(final))]

#3. Uses descriptive activity names to name the activities in the data set
act<-read.table("activity_labels.txt",stringsAsFactors = FALSE)
table(final$activity)
for (i in act[,1])
{
  final$activity[final$activity %in% i]<-act[i,2]
}
table(final$activity)
act

#5. From the data set in step 4, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.
library(dplyr)
final2<-group_by(final,activity) %>% summarise_all(list(mean))


