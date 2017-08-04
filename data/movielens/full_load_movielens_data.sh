#!/bin/bash

echo 'downloading: movielens dataset'
wget https://s3.amazonaws.com/moviematch/movielens_dataset.tar.gz
tar -xzf movielens_dataset.tar.gz && mv ml-latest movielens_dataset

echo 'moving: movielens dataset into hdfs'
hdfs dfs -put movielens_dataset/ratings.csv /user/w205/moviematch/movielens_ratings

echo 'cleaning: movielens dataset'
rm movielens_dataset.tar.gz
rm -r movielens_dataset