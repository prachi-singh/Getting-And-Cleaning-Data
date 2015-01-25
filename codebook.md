#Code Book: Tidy Data    



###Prachi Singh    
###January 25, 2015"    


##Raw Data Information:

The UCI Human Activity Recognition data comes from Samsung Galaxy S smartphone accelerometer and gyroscope measurements, which have been processed using various signal processing techniques to measurement vector consisting of 561 features.

**Source** [UCI HAR Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)  

*Find full description of the experiment [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)*   

###In this experiment:
- Subjects: 30 
- Age-range: 19-48 y/o 
- Performed 6 activities: **Walking, Walking-Upstairs, Walking-Downstairs, Sitting, Standing, Laying.**

- Data measured using Samsung Galaxy S smartphone **accelerometer and gyroscope**: <br>
3-axial linear acceleration <br>
3-axial angular velocity at constant rate of 50Hz

###Dataset partitioning
70% of dataset used for training data <br>
30% used for test data

Sensor signals were preprocessed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 seconds and 50% overlap (128 readings/window). Acceleration was separated into body and gravity using low-pass filter.

###Attributes of raw data:
- Triaxial acceleration from the accelerometer and estimated body acceleration
- Triaxial Angular Velocity from gyroscope
- A 561-feature vector with time and frequency domain variables
- Its Activity Labels
- An identifier of the subject who carried out of the experiment

Find more detailed description of measured attributes in `features.txt`  


##Instructions for downloading data, running script and reading file
1. Download the original data (`UCI HAR Dataset.zip`) into your present working directory and unzip it. **Make sure *UCI HAR Dataset* folder is in your working directory before running the script.**    
2. Make sure you have following R packages installed: `data.frame`, `reshape2`, and `tidyr`. Else, install them using `install.packages()`  
3. Run the run_analysis.R script in your console.
4. `uci_har_tidy_data.txt` and `uci_har_tidy_data.csv` files will be written into your working directory. Read files using:
```r
read.table("./uci_har_tidy_data.txt")
```

###Goals of this project are to:  
1. Merge the training and the test sets to create one data set.
2. Extract only the measurements on the mean and standard deviation for each measurement.
3. Use descriptive activity names to name the activities in the data set
4. Appropriately label the data set with descriptive variable names.
5. From the data set in step 4, create a second, independent tidy data set with the
average of each variable for each activity and each subject.

##Study Design

This process of cleaning the data follows Hadley Wickam's Tidy Data principles which requires the data set to be arranged in rows and columns such as:   


1. Each variable forms a column.

2. Each observation forms a row.

3. Each type of observational unit forms a table.

**Principles of Tidy Data***, [(tidy data vignette)](http://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html)  


###Method
First, I used functions such as str(), head(), tail(), dim(), class(), to evaluate the overall architecture of the data we are working with. Doing this allowed me to choose to load only specific part of the datasets which are required for our purpose. 

**Load the data**     

1. Load only 2nd column of `activity_labels.txt` which contains activity labels.    


2. Load only 2nd column of `features.txt` which contains attritube description of each measurement.       

3. Load `X_test.txt`, `y_test.txt`, `X_train.txt`, `y_train.txt`, and `subject_train.txt` and `subject_test.txt`.


**Process data** 

1. Use `gsub()` to rename attributes in `features` to make eventual column names more readable/intuitive.     

2. Select only the segment that is required for our data analysis purposes, i.e. Mean and Standard Deviation data of all measurements. Use `grepl()` function to match `mean` and `std` in column names (`features`) and create a logical vector.    

3. Subset `X_test`, `X_train` data frames with the logical vector from 2 to come up with data frames with only mean and standard deviation attributes.    

4. Add `activity_labels` to `y_train` and `y_test` data frames.    

5. Bind `X_train` and `y_train` data frames and `X_test` and `y_test` data frames using cbind(). At this point, we have 2 data frames, each with Subject ID, Activity ID, Activity Label, and all measurements for each subject and each activity.   

6. Merge the two tables (`test_data` and `train_data`) using rbind() to form one dataset.   


**Analyze data**  

1. Differentiate ID variables (Subject, Activity labels) from the dataset using `setdiff()`.

2. Use `melt()` function from `reshape2` package to "melt" measured values and id values, that is, spread column values over rows so they repeat and isolate each variable/attribute measurement which can then be cast into tidy data set.     

3. Apply mean function to dataset using `dcast()` function to get the average of each variable for each subject and each activity.      

4. The resulting data set is vertically tidy. Write the table into file (CSV and TXT formats) using `write.table()`.   


**Read table**    

Table can be read into the R console using `read.table()`.   









