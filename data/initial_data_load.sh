#!/bin/bash

echo 'creating: ratings directory in hdfs'
hdfs dfs -mkdir /user/w205/moviematch
hdfs dfs -mkdir /user/w205/moviematch/movielens_ratings

echo 'creating: ratings schema in hive'
cd movielens
hive -f create_schema.sql

echo 'running: movielens load script'
./load_movielens_data.sh

echo 'creating: ratings table in spark'
spark-sql -f create_tables.sql
cd ..

echo 'running: movie metadata load script'
cd metadata
./load_movie_data.sh
cd ..
