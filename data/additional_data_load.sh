#!/bin/bash

cd data

echo 'running: netflix prize load script'
cd np
./load_np_data.sh
cd ..

cd ..