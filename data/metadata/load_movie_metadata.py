import os
import json
import pymongo

def load_movies():
    collection = pymongo.MongoClient().moviematch.movies
    movies = []

    os.chdir('movies')

    # foreach file in the movies directory convert into json
    # object, add movielens id and then append to list
    for filename in os.listdir(os.getcwd()):
        file = open(filename, 'r')
        movie = json.loads(file.read())
        movie['movielens_id'] = filename.split('.')[0]
        movies.append(movie)

    # insert all the json objects into the database and create an
    # index on the movielens id
    collection.insert_many(movies)
    collection.create_index([('movielens_id', pymongo.TEXT)],
                            name='search_index',
                            default_language='english')
    print('added {0} movies to the database'.format(len(movies)))

load_movies()
