#!/bin/bash

# get and unzip the movielens dataset
echo 'downloading: movielens dataset'
wget https://s3.amazonaws.com/moviematch/movielens_dataset.tar.gz
tar -xzf movielens_dataset.tar.gz && mv ml-latest movielens_dataset

# put the ratings from the dataset into hdfs
echo 'moving: movielens dataset into hdfs'
hdfs dfs -put movielens_dataset/ratings.csv /user/w205/moviematch/ratings

# clean up
echo 'cleaning: movielens dataset'
rm movielens_dataset.tar.gz
rm -r movielens_dataset