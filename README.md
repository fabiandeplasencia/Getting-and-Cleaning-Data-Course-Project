Getting-and-Cleaning-Data-Course-Project
========================================

# Introduction
This repository contains my project for the Getting and Cleaning Data course. Includes the script run_analysis.R, a codebook, the result file tidy.txt (on 22/08/2014), and this readme.md.

# Requirements
This project first requires to download the data from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones , and unzip the "UCI HAR Dataset" directory into the working directory of R.
It also requires the installation of the sqldf, reshape an reshape2 packages in R.

# Script and tidy dataset
The script, run_analysis.R, will load the needed files (ignoring the 'Inertial Signals' subdirectory), take both X_train and X_test measure files, and join them with the correspondent subjects and activities. 
Then it will simplify the variables names, and process is subsequently into a wide and a narrow dataframes. This narrow dataframe will include just the variables containing 'mean' and 'std' in it's name, the subjectid and the activiy. 
Finally, it will process this narrow df melting and unmelting it to obtain a tidy dataframe with subject, activity, and the mean of each of the variables, and will create a tab separated txt file, 'tidy.txt', in the working directory.

