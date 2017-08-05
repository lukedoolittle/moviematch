import json
import sys
import decimal
from collaborative_filtering import CollaborativeFiltering

# define the recommendation algorithm and the hyperparameters
recommender = CollaborativeFiltering('movie_ratings_small')
hyperparameters = {'rank': 10, 'iterations': 10, 'lambda': .1}
user_id = 0

if len(sys.argv) != 2:
    print('Actual argument count is {0}'.format(len(sys.argv)))
    raise ValueError('Must specify user ratings as an argument')

# load the users ratings into tuples, noting that 0 is the
# sentinal value for the current user
given_ratings = [(user_id, int(rating['movie_id']), decimal.Decimal(str(rating['rating'])))
                 for rating
                 in json.loads(sys.argv[1])]

recommendations = recommender.recommend(given_ratings, 
                                        user_id,
                                        hyperparameters)

# print a json formatted version of the results to the console
print(str(json.dumps(recommendations)).replace("u'", "").replace("'", ""))
