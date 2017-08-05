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
where user_id <> 'userId'
UNION
SELECT 
CAST(user_id AS INT) user_id,
CAST(movielens_id AS INT) movie_id,
CAST(rating AS DECIMAL(2,1)) rating
FROM NP_RATINGS_RAW
JOIN movie_id_mapping
ON movie_id_mapping.netflix_id = NP_RATINGS_RAW.movie_id
where user_id <> 'userId'""")
