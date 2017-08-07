#!/bin/bash

cd data

echo 'running: movielens load script'
cd movielens
./load_movielens_data.sh
cd ..

echo 'running: movie metadata load script'
cd metadata
./load_movie_metadata.sh
cd ..

cd ..