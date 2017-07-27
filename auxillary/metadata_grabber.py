import http.client
import pandas
import json
import time
import os

conn = http.client.HTTPSConnection("api.themoviedb.org")
api_key = '<YOUR THEMOVIEDB API KEY HERE>'

movies = pandas.read_csv('links.csv')

completed_movies = [int(x.split('.')[0]) for x in os.listdir('data')]

for index, row in movies.iterrows():
    movie_id = int(row['movieId'])
    if movie_id in completed_movies:
        print('skipping movie id {0}'.format(movie_id))
        continue
    tmdb_id = row['tmdbId']

    conn.request(
        'GET',
        '/3/movie/{0}?language=en-US&api_key={1}'.format(tmdb_id, api_key),
        '{}')
    res = conn.getresponse()

    remaining = res.getheader('X-RateLimit-Remaining')
    print('fetching movie id {0} ({1} request left in timeblock)'.format(movie_id, remaining))
    movie_info = res.read().decode('utf-8')
    text_file = open(
        'data/{0}.blob'.format(movie_id),
        'w',
        encoding='utf-8')
    text_file.write(movie_info)
    text_file.close()

    if int(remaining) == 0:
        reset_time = int(res.getheader('X-RateLimit-Reset'))
        current_time = int(time.time())
        sleep_time = reset_time - current_time + 1
        print('sleeping for {0} seconds'.format(sleep_time))
        time.sleep(sleep_time)
