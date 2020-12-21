Based on.

Experimental design and background: 

  This project assembles data from subjects whose activities were recorded with a smartphone device.  Measurements based on the smartphone devices were assigned to different         features. 

  Per the assignment's readme.txt: "Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung     Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz."

Raw data: 
  
  The original (once compiled) dataset arrived in several files.  There were training and test versions of Subject, Y, and X, which contained the ID of the subject, the activity being measured, and the associated feature variables.  Features.txt and Activity_labels.txt contained feature descriptions and activity descriptions associated with the indexed columns. 

Data assembly:

  I assembled the data into a full dataset by column-binding SUBJECT | Y [activity] | X [features] for both training and test, and then row-binding training and test to result in a full dataset.

Processed data: 

  I subset the data to features containing either "mean()" or "std()", variables pertaining to the mean or standard deviation.  Joining to the activity labels, I derived descriptions for the activity code in the dataset.  I renamed the feature columns based on the relevant measurement features.  

Calculations: 

  Finally, I summarized the datset by subject and by activity, computing mean values for each column in a final, tidy dataset.
