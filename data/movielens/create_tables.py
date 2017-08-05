from pyspark import SparkConf, SparkContext
from pyspark import HiveContext

sc = SparkContext(conf=SparkConf().setAppName("modelGeneration"))
sqlContext = HiveContext(sc)

sqlContext.sql('DROP TABLE IF EXISTS movie_ratings')
sqlContext.sql("""CREATE TABLE movie_ratings AS SELECT 
                CAST(user_id AS INT) user_id,
                CAST(movie_id AS INT) movie_id,
                CAST(rating AS DECIMAL(2,1)) rating
                FROM movielens_ratings_raw
                where user_id <> 'userId'""")

sqlContext.sql('DROP TABLE IF EXISTS movie_ratings_small')
sqlContext.sql("""CREATE TABLE movie_ratings_small AS SELECT 
                CAST(user_id AS INT) user_id,
                CAST(movie_id AS INT) movie_id,
                CAST(rating AS DECIMAL(2,1)) rating
                FROM movielens_ratings_small_raw
                where user_id <> 'userId'""")
