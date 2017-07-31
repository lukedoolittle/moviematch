from collaborative_filtering import CollaborativeFiltering

# define the recommendation algorithm and the hyperparameter ranges
recommender = CollaborativeFiltering()
hyperparameters = {'rank': [15, 20], 'iterations': [15, 20]}

recommender.hyperparameter_search(hyperparameters)
