import time
from math import sqrt
from pyspark import SparkConf, SparkContext
from pyspark import HiveContext
from pyspark.mllib.recommendation import ALS, MatrixFactorizationModel, Rating

class CollaborativeFiltering:
    def __init__(
            self,
            ratings_table):
        self._sc = SparkContext(conf=SparkConf().setAppName("modelGeneration"))
        self._sqlContext = HiveContext(self._sc)
        self._ratings_table_name = ratings_table

    def _get_ratings(self):
        # get ratings from spark movie_ratings table
        return (self
                ._sqlContext
                .sql('select * from {0}'.format(self._ratings_table_name))
                .rdd
                .map(lambda l: (l.user_id, l.movie_id, l.rating)))

    def recommend(self,
                  given_ratings,
                  user_id,
                  hyperparameters):
        # combine given ratings with all static ratings
        user_ratings = self._sc.parallelize(given_ratings)
        ratings = self._get_ratings()
        complete_ratings = ratings.union(user_ratings)

        # train the model on ALL ratings
        model = ALS.train(complete_ratings,
                          rank=hyperparameters['rank'],
                          iterations=hyperparameters['iterations'],
                          lambda_=hyperparameters['lambda'])

        # should be filtering out rated movies here but we're not
        '''
        .filter(lambda x: x not in map(lambda y: y[1], given_ratings))
        '''
        recomendations = model.recommendProducts(user_id, 20)
        return [{'movie_id': l.product, 'rating': l.rating} for l in recomendations]

    def _calculate_performance(self,
                               rank,
                               iterations,
                               lam):
        # (user_id, movie_id, rating)
        ratings = self._get_ratings()
        training, test = ratings.randomSplit([.8, .2], seed=0)
        test_for_prediction = test.map(lambda t: (t[0], t[1]))

        # train on all the data and then predict over every datapoint
        time1 = time.time()
        model = ALS.train(training,
                          rank=rank,
                          iterations=iterations,
                          lambda_=lam)
        predictions = model.predictAll(test_for_prediction)
        time2 = time.time()

        # calculate the MSE and time to train and predict
        true_reorg = test.map(lambda x: ((x[0], x[1]), x[2]))
        pred_reorg = predictions.map(lambda x: ((x[0], x[1]), x[2]))
        true_pred = true_reorg.join(pred_reorg)
        error = sqrt(true_pred.map(lambda r: (r[1][0] - r[1][1])**2).mean())

        print('Rank: {0} Iterations: {1} Lambda: {2} Mean Squared Error: {3:.3f} Time: {4:.3f} sec'.format(
            rank,
            iterations,
            lam,
            error,
            time2-time1))

    def hyperparameter_search(self,
                              hyperparameters):
        for itr in hyperparameters['iterations']:
            for rnk in hyperparameters['rank']:
                for lmb in hyperparameters['lambda']:
                    self._calculate_performance(rnk,
                                                itr,
                                                lmb)
