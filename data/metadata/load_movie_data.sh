#!/bin/bash

# get and unzip the metadata files
echo 'downloading: movie data'
wget https://s3.amazonaws.com/moviematch/movies.tar.gz
tar -xzf movies.tar.gz && mv movie_data movies

# load the movie data into mongo
echo 'moving: movie data into mongodb'
python load_movie_data.py

# clean up the files left behind
echo 'cleaning: movie data'
rm -r movies
rm -r movies.tar.gz