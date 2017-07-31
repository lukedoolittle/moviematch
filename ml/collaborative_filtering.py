import time
from pyspark import SparkConf, SparkContext
from pyspark import HiveContext
from pyspark.mllib.recommendation import ALS, MatrixFactorizationModel, Rating

class CollaborativeFiltering:
    def __init__(self):
        self.sc = SparkContext(conf=SparkConf().setAppName("modelGeneration"))
        self.sqlContext = HiveContext(self.sc)

    def _get_ratings(self):
        # get ratings from spark movie_ratings table
        return (self
                .sqlContext
                .sql('select * from movie_ratings')
                .rdd
                .map(lambda l: (l.user_id, l.movie_id, l.rating)))

    def recommend(self,
                  given_ratings,
                  hyperparameters):
        user_ratings = self.sc.parallelize(given_ratings)
        ratings = self._get_ratings()
        complete_ratings = ratings.union(user_ratings)

        # train the model on ALL ratings
        model = ALS.train(complete_ratings,
                          rank=hyperparameters['rank'],
                          iterations=hyperparameters['iterations'])
        unrated_movies = (ratings
                          .map(lambda x: x[1])
                          .distinct()
                          .filter(lambda x: x not in map(lambda y: y[1], given_ratings))
                          .map(lambda x: (0, x)))

        # predict the ratings of all movies the user has not rated and print
        # a json formatted version of the results to the console
        predictions = model.predictAll(unrated_movies)
        return predictions.sortBy(lambda x: -x.rating).toDF()

    def _calculate_performance(self,
                               rank,
                               iterations):
        ratings = self._get_ratings()
        testdata = ratings.map(lambda p: (p[0], p[1]))

        # train on all the data and then predict over every datapoint
        time1 = time.time()
        model = ALS.train(ratings,
                          rank=rank,
                          iterations=iterations)
        predictions = (model
                       .predictAll(testdata)
                       .map(lambda r: ((r[0], r[1]), r[2])))
        time2 = time.time()

        # calculate the MSE and time to train and predict
        rates_and_predictions = (ratings
                                 .map(lambda r: ((r[0], r[1]), r[2]))
                                 .join(predictions))
        mean_square_error = (rates_and_predictions
                             .map(lambda r: (r[1][0] - r[1][1])**2)
                             .mean())
        print('Rank: {0} Iterations: {1} Mean Squared Error: {2:.3f} Time: {3:.3f} sec'.format(
            rank,
            iterations,
            mean_square_error,
            time2-time1))

    def hyperparameter_search(self,
                              hyperparameters):
        for itr in hyperparameters['iterations']:
            for rnk in hyperparameters['rank']:
                self._calculate_performance(rnk,
                                            itr)
