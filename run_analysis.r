setwd("C:/Users/U41081/Documents/coursera/Getting and Cleaning Data")
if(!file.exists("Week 4")) {
  print("Doesn't exist")
  dir.create("Week 4")
} else {
  print("Exists")
}
setwd("Week 4")
getwd()

#Goal of the course project: 
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.
#From the data set in step 4, creates a second, independent tidy data set with the average 
#of each variable for each activity and each subject.

##From the UCI website linked in the project: 
# Data Set Information:
#   The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. 
#   Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone 
#   (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 
#   3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. 
#   The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating 
#   the training data and 30% the test data.

#   Check the README.txt file for further details about this dataset.
# 
# Attribute Information:
#   
#   For each record in the dataset it is provided:
#   - Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
# - Triaxial Angular velocity from the gyroscope.
# - A 561-feature vector with time and frequency domain variables.
# - Its activity label.
# - An identifier of the subject who carried out the experiment.

#libraries
library(dplyr)

#Import training datasets
setwd("UCI HAR Dataset/train")
x_train <- read.table("X_train.txt")  #7352 x 561
y_train <- read.table("y_train.txt")  #7352 x 1
subject_train <- read.table("subject_train.txt")  #7352 x 1

#Figure out what the tables contain
#table(y_train$V1)  
#    1    2    3    4    5    6      ### this is the 6 activities
#  1226 1073  986 1286 1374 1407 

#table(subject_train$V1)  #this is the 30 volunteers
# 1   3   5   6   7   8  11  14  15  16  17  19  21  22  23  25  26  27  28  29  30 
# 347 341 302 325 308 281 316 323 328 366 368 360 408 321 372 409 392 376 382 344 383 

#Import test datasets
setwd("../test")
x_test <- read.table("X_test.txt") #2947 x 561
y_test <- read.table("y_test.txt") #2947 x 1
subject_test <- read.table("subject_test.txt") #2947 x 1

#Import activity labels
#6 x 2 -- activity_number | activity_label
setwd("../")
activity_labels <- read.table("activity_labels.txt")  
activity_labels <- activity_labels %>% rename(activity_number=V1, activity_label=V2)
#Import features
#561 x 2 -- feature_number | feature_label
features <- read.table("features.txt")  
features <- features %>% rename(feature_number=V1, feature_label=V2)

## PART 1 -- MERGE TRAIN AND TEST 
# Make train set
#   rename subject_train$V1 to the subject's name
#   rename y$V1 to the activity name

  subject_train <- subject_train %>% rename(subject_number=V1)
  subject_test <- subject_test %>% rename(subject_number=V1)
  y_train <- y_train %>% rename(activity_number=V1)
  y_test <- y_test %>%  rename(activity_number=V1)
  training_dataset <- cbind(subject_train, y_train, x_train)
  test_dataset <- cbind(subject_test, y_test, x_test)
  
  ###Complete part 1 -- Merges the training and validation datasets to create one dataset ###
  #10299 x 563
  full_dataset <- rbind(training_dataset, test_dataset)
  




## Part 2 -- EXTRACT MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT

  #identify which features have to do with mean or standard deviation
  #a lot of the fields have calls to either mean() or std(); look for these function calls
  features_with_mean_or_std <- grep("mean()|std()", features[,2])
  #length(features_with_mean_or_std)  #79 mean() or std()
  
  #match the features to the full dataset; need to offset by 2 columns since ID/ACTIIVTY/FEATURES is the format
  
  features_with_mean_or_std_for_matching <- features_with_mean_or_std + 2
  extracted_mean_and_std <- full_dataset[,c(1,2,features_with_mean_or_std_for_matching)]  #pull out relevant columns
  

## Part 3 -- Name the activities
  #merge full_dataset with activity_labels -- adds column 564;  
  #10299 x 564
  merged_mean_sd_dataset <- merge(extracted_mean_and_std, activity_labels, by.x="activity_number", by.y="activity_number")
  #this shuffles the order of observations a bit.  does it matter?  don't think so
  
  #reorder the columns to be: person| activity # | activity label | features
  merged_mean_sd_dataset <- merged_mean_sd_dataset %>%
    select(subject_number, activity_number, activity_label, everything())
  merged_mean_sd_dataset <- arrange(merged_mean_sd_dataset, subject_number, activity_number)
  

## Part 4 -- Appropriately labels the data set with descriptive variable names.
  head(features)
  new_feature_names <- features$feature_label[features_with_mean_or_std]
  names(merged_mean_sd_dataset)[4:ncol(merged_mean_sd_dataset)] <- new_feature_names

  #from the course discussion board:
  #Adding to Nancy's post, the duplicate features are missing their X, Y, and Z dimension designations. The details on the features are provided in the features_info.txt file. In my project submission, I included the following commentary in my code book.
  
## Part 5 -- From the data set in step 4, creates a second, independent tidy data set with the average 
#  of each variable for each activity and each subject.
  tidy2 <- merged_mean_sd_dataset %>%
    group_by(subject_number, activity_label) %>%
    summarize_all(mean)
  