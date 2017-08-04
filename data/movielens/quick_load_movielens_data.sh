#!/bin/bash

echo 'downloading: movielens dataset'
wget https://s3.amazonaws.com/moviematch/movielens_ratings.tar.gz
tar -xzf movielens_ratings.tar.gz

echo 'moving: movielens dataset into hdfs'
hdfs dfs -put movielens_ratings.csv /user/w205/moviematch/movielens_ratings

echo 'cleaning: movielens dataset'
rm movielens_ratings.csv
rm movielens_ratings.tar.gz