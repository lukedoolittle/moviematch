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
rm -f movielens_ratings.csv
rm -f movielens_ratings.tar.gz
rm -f ratings.csv
rm -f movielens_ratings_small.tar.gz