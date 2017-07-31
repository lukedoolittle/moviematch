import sys
from pyspark import SparkConf, SparkContext
from pyspark import HiveContext

# an alternative method of creating tables directly in Spark

if len(sys.argv) != 2:
    raise ValueError('Must specify a file path')

sc = SparkContext(conf=SparkConf().setAppName("dataLoading"))
sqlContext = HiveContext(sc)

sqlContext.sql('drop table if exists movie_ratings')
ratings = sqlContext.read.load('file:///{0}'.format(sys.argv[1]), 
                               format='com.databricks.spark.csv',
                               header='true',
                               inferSchema='true')

ratings.createOrReplaceTempView('movie_ratings_temp')
sqlContext.sql('create table movie_ratings as select userId as user_id, movieId as movie_id, rating, timestamp from movie_ratings_temp')
