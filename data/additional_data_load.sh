#!/bin/bash

hdfs dfs -mkdir /user/w205/moviematch/netflix_ratings
hdfs dfs -mkdir /user/w205/moviematch/netflix_titles
hdfs dfs -mkdir /user/w205/moviematch/movie_id_map

echo 'creating: ratings schema in hive'
cd np
hive -f create_schema.sql

echo 'running: netflix prize load script'
./load_np_data.sh

echo 'creating: ratings table in spark'
spark-sql -f create_tables.sql
cd ..