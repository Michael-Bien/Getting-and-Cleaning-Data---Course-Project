# Getting-and-Cleaning-Data---Course-Project
Assembles a tidy dataset from source data

Files in the repo:

----

run_analysis.r - This r script contains code that performs the analysis in the assignment.  Starting from separate, independent datasets, it compiles a single dataset and performs individual analyses.  It is broken into 5 segments:
  1. Merges the training and the test sets to create one data set.
  2. Extracts only the measurements on the mean and standard deviation for each measurement. 
  3. Uses descriptive activity names to name the activities in the data set
  4. Appropriately labels the data set with descriptive variable names. 
  5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  
Overview of the script:

Data assembly:

run.analysis.r assembles the data into a full dataset by column-binding SUBJECT | Y [activity] | X [features] for both training and test, and then row-binding training and test to result in a full dataset.

Processed data:

run.analysis.r subsets the data to features containing either "mean()" or "std()", variables pertaining to the mean or standard deviation. Joining to the activity labels, run_analysis.r derives descriptions for the activity code in the dataset. Finally, it renames the feature columns based on the relevant measurement features.

Calculations:

The script summarizes the datset by subject and by activity, computing mean values for each column in a final, tidy dataset.
----

Codebook.md - codebook that explains the datasets and analysis.  The codebook contains descriptions from the original Samsung documentation where applicable, but also describes changes to the variables during compilation.

