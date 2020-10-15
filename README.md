---
title: "Getting and Cleaning Data Course Project- README"
author: "Neagu Georgeta"
date: "10/11/2020"
output: pdf_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## The run_analysis.R performs the following:

Assigns the activity data *(Y)* to each set, training and test, so the data set to be **accurate**. The assigning is done by *cbind* function.

> Reads the data and the names of the variables from the text file *features.txt* to avoid having duplicate name columns. Y set has the column name *V1* and the first column from the X set has the same name, *V1*. 

```{r}
x_test<-read.table("./test/X_test.txt")
y_test<-read.table("./test/y_test.txt")
x_train<-read.table("./train/X_train.txt")
y_train<-read.table("./train/y_train.txt")
name<-read.table("features.txt")
names(y_test)
names(x_test)[1]
```

> Assigns the names to the **X sets** using the *make.names* function. The *unique and allow_* arguments are set to *TRUE* for the names to be unique and compatible to the R format/version.

```{r}
names(x_test)<-make.names(names=name[,2],unique = TRUE,allow_=TRUE)
names(x_train)<-make.names(names=name[,2],unique = TRUE,allow_=TRUE)
```

> From the documentation provided, **Y sets** contain the *activity*, so the name it's set accordingly.

```{r}
names(y_test)<-"activity"
names(y_train)<-"activity"
```


> Assigns the activity data *(Y)* to each set, training and test, so the data set to be **accurate**. The assigning is done by *cbind* function.

```{r}
whole_test<-cbind(x_test,y_test)
dim(whole_test)
whole_train<-cbind(x_train,y_train)
dim(whole_train)
```

> Joins the training and test set using the *plyr library*. The resulting set **(final)** will have the common values. (I chose join instead merge because the resulting set from merging had 0 observations.)

```{r}
library(plyr)
all<-list(whole_test,whole_train)
final<-join_all(all)
head(final)
dim(final)
```

> Searches for the **mean()** and **std()** in the column names to subset the data that contains values on the mean and standard deviation for each measurement, the output will be assigned to the variable *mean_std*.

```{r}
mean_std<-final[,grepl("mean()",names(final))| grepl("std()",names(final))]
head(mean_std)
```

> Reads the *activity labels text file* into a variable that will be used to label the observations on activity. 

```{r}
act<-read.table("activity_labels.txt",stringsAsFactors = FALSE)
act
```

> Loops for assigning the label and verifies the correctness of the looping.
  + Observations for each activity *before looping*
  
```{r}
table(final$activity)
```

  + The code for the *for loop*:

```{r}
for (i in act[,1])
{
  final$activity[final$activity %in% i]<-act[i,2]
}
```

  + Observations *after looping*
  
```{r}
table(final$activity)
```

  **The results match.** 

> Groups the data by activity and summarises all the columns of the data frame by mean.

```{r}
library(dplyr)
final2<-group_by(final,activity) %>% summarise_all(list(mean))
head(final2)
```