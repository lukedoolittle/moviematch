#!/bin/bash

# get and unzip the metadata files
echo 'downloading: movie metadata'
wget https://s3.amazonaws.com/moviematch/movies.tar.gz
tar -xzf movies.tar.gz && mv movie_data movies

# load the movie data into mongo
echo 'moving: movie metadata into mongodb'
python load_movie_metadata.py

# clean up the files left behind
echo 'cleaning: movie metadata'
rm -r movies
rm -r movies.tar.gz