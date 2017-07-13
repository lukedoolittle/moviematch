from pyspark import SparkContext
from pyspark import HiveContext
from pyspark.mllib.recommendation import ALS, MatrixFactorizationModel, Rating


sc = SparkContext(conf=SparkConf().setAppName("modelGeneration"))
sqlContext = HiveContext(sc)

userdata = # get something from the command line

# create a Ratings array from the movie_ratings table and train an ALS model
# here you will need to join the received user data with the ratings from the database
# perform traing on that combined dataset and then do prediction on all movies for
# the given user
ratings = sqlContext.sql('select * from movie_ratings').map(lambda l: Rating(l.user_id, l.movie_id, l.rating))
model = ALS.train(ratings, rank=10, iterations=10) 
