from pyspark import SparkConf, SparkContext
from pyspark import HiveContext
from pyspark.mllib.recommendation import ALS, MatrixFactorizationModel, Rating
import json
import sys
import decimal

if len(sys.argv) != 2:
    print('Actual argument count is {0}'.format(len(sys.argv)))
    raise ValueError('Must specify user ratings as an argument')

# load the users ratings into tuples, noting that 0 is the 
# sentinal value for the current user
given_ratings = [(0, int(rating['movie_id']), decimal.Decimal(str(rating['rating'])))
                 for rating 
                 in json.loads(sys.argv[1])]

# create the spark contexts
sc = SparkContext(conf=SparkConf().setAppName("modelGeneration"))
sqlContext = HiveContext(sc)

# combine the given user ratings with the ratings in the database
user_ratings = sc.parallelize(given_ratings)
ratings = sqlContext.sql('select * from movie_ratings').map(lambda l: (l.user_id, l.movie_id, l.rating))
complete_ratings = ratings.union(user_ratings)

# train the model on ALL ratings
model = ALS.train(complete_ratings, rank=10, iterations=10) 

# get a list of all the movies the user HAS NOT rated
unrated_movies = ratings.map(lambda x: x[1]).distinct().filter(lambda x: x not in map(lambda y: y[1], given_ratings)).map(lambda x: (0, x))

# predict the ratings of all movies the user has not rated and print
# a json formatted version of the results to the console
predictions = model.predictAll(unrated_movies)
recommendations = predictions.sortBy(lambda x: -x.rating)
print(str(recommendations.toDF().selectExpr("product as movie_id", "rating as rating").toJSON().take(20)).replace("u'", "").replace("'",""))