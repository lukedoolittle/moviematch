#!/bin/bash

# install dependencies for api server
cd apiserver
npm i

# install dependencies for webserver
cd ../webserver
npm i

# build and start webserver
npm run build
npm run start