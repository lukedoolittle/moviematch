from pyspark import SparkContext
from pyspark import HiveContext
from pyspark.mllib.recommendation import ALS, MatrixFactorizationModel, Rating

sc = SparkContext(conf=SparkConf().setAppName("modelGeneration"))
sqlContext = HiveContext(sc)

# create a Ratings array from the movie_ratings table and train an ALS model
ratings = sqlContext.sql('select * from movie_ratings').map(lambda l: Rating(l.user_id, l.movie_id, l.rating))
model = ALS.train(ratings, rank=10, iterations=10) 

model.save(sc, "alsModel")

# output the MSE of the data
testdata = ratings.map(lambda p: (p[0], p[1]))
predictions = model.predictAll(testdata).map(lambda r: ((r[0], r[1]), r[2]))
ratesAndPreds = ratings.map(lambda r: ((r[0], r[1]), r[2])).join(predictions)
MSE = ratesAndPreds.map(lambda r: (r[1][0] - r[1][1])**2).mean()
print("Mean Squared Error = " + str(MSE))