#!/bin/bash

# create the directory structure in hdfs
echo 'creating: ratings directory in hdfs'
hdfs dfs -mkdir /user/w205/moviematch
hdfs dfs -mkdir /user/w205/moviematch/ratings

# create the schema in hive
echo 'creating: ratings schema in hive'
hive -f create_schema.sql

# load the movielens dataset into hdfs
echo 'running: movielens load script'
cd movielens
./load_movielens_data.sh
cd ..

# create the tables in spark
echo 'creating: ratings table in spark'
spark-sql -f create_tables.sql

# load the movie metadata into mongo
echo 'running: movie metadata load script'
cd metadata
./load_movie_data.sh
cd ..