import pandas
import requests
import math
from io import open as iopen

print('reading in file...')
movies = pandas.read_csv('movies.dat',
                     sep='\t',
                     skiprows=0,
                     header=0,
                     encoding = 'iso-8859-1')

start_index = 142

for index, movie in movies.iterrows():
    if (not isinstance(movie.imdbPictureURL, str)):
        print('invalid url found')
    elif (movie.id < start_index):
        pass
    else:
        print('fetching image for \'{0}\''.format(movie.title))
        response = requests.get(movie.imdbPictureURL)

        with iopen('img/{0}.jpg'.format(movie.id), 'wb') as file:
            file.write(response.content)