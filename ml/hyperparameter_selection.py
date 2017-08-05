from collaborative_filtering import CollaborativeFiltering

# define the recommendation algorithm and the hyperparameter ranges
recommender = CollaborativeFiltering('movie_ratings_small')
hyperparameters = {'rank': [8, 10, 12], 'iterations': [10, 15, 20], 'lambda': [.01, .05, .1, .5, 1.0]}

recommender.hyperparameter_search(hyperparameters)
