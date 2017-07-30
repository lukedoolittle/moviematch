#!/bin/bash

# Load the data into hdfs
hdfs dfs -mkdir netflix_prize
hdfs dfs -mkdir netflix_prize/ratings
hdfs dfs -mkdir netflix_prize/titles

hdfs dfs -put /data/npdata/ratings/ratings.csv netflix_prize/ratings
echo "Training data loaded into HDFS."
hdfs dfs -put /data/npdata/titles/titles.csv netflix_prize/titles
echo "Movie titles loaded into HDFS."

# Remove the storage-heavy files that were just put into hdfs
echo 'cleaning: netflix prize dataset'
rm -r /data/npdata


