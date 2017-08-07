#!/bin/bash

cd data

echo 'running: movielens load script'
cd movielens
./load_movielens_data.sh
cd ..

cd ..