#!/bin/bash

cd data

echo 'creating: ratings directory in hdfs'
hdfs dfs -mkdir /user/w205/moviematch
hdfs dfs -mkdir /user/w205/moviematch/movielens_ratings
hdfs dfs -mkdir /user/w205/moviematch/movie_id_map

echo 'creating: ratings schema in hive'
cd movielens
hive -f create_schema.sql

echo 'running: movielens load script'
./quick_load_movielens_data.sh

echo 'creating: ratings table in spark'
spark-submit create_tables.py
cd ..

echo 'running: movie metadata load script'
cd metadata
./load_movie_metadata.sh
cd ..

cd ..