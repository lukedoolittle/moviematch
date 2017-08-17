#!/bin/bash

echo 'downloading: small movielens dataset'
wget https://s3.amazonaws.com/moviematch/movielens_ratings_small.tar.gz
tar -xzf movielens_ratings_small.tar.gz

echo 'creating: tables in spark'
spark-submit create_tables.py

echo 'cleaning'
rm -f ratings.csv
rm -f movielens_ratings_small.tar.gz