from pyspark import SparkConf, SparkContext
from pyspark import HiveContext

sc = SparkContext(conf=SparkConf().setAppName("modelGeneration"))
sqlContext = HiveContext(sc)

print('creating temporary netflix table')
ratings = sqlContext.read.load('file:///home/ec2-user/moviematch/data/np/netflix_ratings.csv', 
                               format='com.databricks.spark.csv',
                               header='true',
                               inferSchema='true')
ratings.createOrReplaceTempView('netflix_ratings')

print('creating temporary movie id mapping table')
ratings = sqlContext.read.load('file:///home/ec2-user/moviematch/data/np/movie_ids.csv', 
                               format='com.databricks.spark.csv',
                               header='true',
                               inferSchema='true')
ratings.createOrReplaceTempView('movie_id_mapping')

print('creating temporary movielens table')
ratings = sqlContext.read.load('file:///home/ec2-user/moviematch/data/np/movielens_ratings.csv', 
                               format='com.databricks.spark.csv',
                               header='true',
                               inferSchema='true')
ratings.createOrReplaceTempView('movielens_ratings')

print('creating movie_ratings table')
sqlContext.sql('drop table if exists movie_ratings')
sqlContext.sql("""create table movie_ratings as select
userId user_id,
movieId movie_id,
rating
from movielens_ratings
union
select
user_id,
movie_id,
rating
from netflix_ratings
join movie_id_mapping
on netflix_id = movie_id""")
