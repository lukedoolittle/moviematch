from pyspark import SparkConf, SparkContext
from pyspark import HiveContext

sc = SparkContext(conf=SparkConf().setAppName("dataLoading"))
sqlContext = HiveContext(sc)

#sqlContext.sql('drop table movie_ratings')
df = sqlContext.read.load('file:////Users/lukedoolittle/Spark/ratings.csv', 
                          format='com.databricks.spark.csv', 
                          header='true', 
                          inferSchema='true')

df.createOrReplaceTempView('movie_ratings_temp')
sqlContext.sql('create table movie_ratings as select userId as user_id, movieId as movie_id, rating, timestamp from movie_ratings_temp')