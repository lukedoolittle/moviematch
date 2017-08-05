#!/bin/bash

echo 'downloading: movielens dataset'
wget https://s3.amazonaws.com/moviematch/movielens_ratings.tar.gz
tar -xzf movielens_ratings.tar.gz

echo 'downloading: small movielens dataset'
wget https://s3.amazonaws.com/moviematch/movielens_ratings_small.tar.gz
tar -xzf movielens_ratings_small.tar.gz

echo 'creating: tables in spark'
spark-submit create_tables.py

echo 'cleaning'
rm movielens_ratings.csv
rm movielens_ratings.tar.gz
rm ratings.csv
rm movielens_ratings_small.tar.gz