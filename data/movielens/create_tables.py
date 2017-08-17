from pyspark import SparkConf, SparkContext
from pyspark import HiveContext

sc = SparkContext(conf=SparkConf().setAppName("modelGeneration"))
sqlContext = HiveContext(sc)

sqlContext.sql('drop table if exists movie_ratings')
ratings = sqlContext.read.load('file:///home/ec2-user/moviematch/data/movielens/movielens_ratings.csv', 
                               format='com.databricks.spark.csv',
                               header='true',
                               inferSchema='true')
ratings.createOrReplaceTempView('movie_ratings_temp')
sqlContext.sql('create table movie_ratings as select userId as user_id, movieId as movie_id, rating, timestamp from movie_ratings_temp')

sqlContext.sql('drop table if exists movie_ratings_small')
ratings = sqlContext.read.load('file:///home/ec2-user/moviematch/data/movielens/ratings.csv', 
                               format='com.databricks.spark.csv',
                               header='true',
                               inferSchema='true')
ratings.createOrReplaceTempView('movie_ratings_small_temp')
sqlContext.sql('create table movie_ratings_small as select userId as user_id, movieId as movie_id, rating, timestamp from movie_ratings_small_temp')