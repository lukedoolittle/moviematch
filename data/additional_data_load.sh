#!/bin/bash

cd data

hdfs dfs -mkdir /user/w205/moviematch/netflix_ratings
hdfs dfs -mkdir /user/w205/moviematch/netflix_titles

echo 'creating: ratings schema in hive'
cd np
hive -f create_schema.sql

echo 'running: netflix prize load script'
./quick_load_np_data.sh

echo 'creating: ratings table in spark'
spark-sql -f create_tables.sql
cd ..

cd ..