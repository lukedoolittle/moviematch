#!/bin/bash

# create the directory structure in hdfs
hdfs dfs -mkdir /user/w205/moviematch
hdfs dfs -mkdir /user/w205/moviematch/ratings

# create the schema in hive
hive -f create_schema.sql

# load the movielens dataset into hdfs
./movielens/load_movielens_data.sh

# create the tables in spark
spark-sql -f create_tables.sql