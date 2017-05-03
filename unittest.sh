#!/bin/bash

DIR=$(pwd)

# Get branch
if [ -z "$1" ]; then
    echo "Usage: ./unittest.sh BRANCH"
    echo "Example: ./unittest.sh release_1.0"
    echo "Using master branch as default"
    BRANCH=master
else
    BRANCH=$1
fi

# Force clean checkout
if [ ! -d "unittest" ]; then
    mkdir unittest
else
    rm -rf unittest
    mkdir unittest
fi

# Check out project
cd unittest
git clone "https://github.com/maplebird/greetings_src.git"
cd greetings_src
git checkout ${BRANCH}
git pull

# Make sure node isn't running
kill -9 $(ps -ef | grep 'node server.js' | grep -v grep | awk '{print $2}')

# Install project
cd ${DIR}/unittest/greetings_src && npm install
cd ${DIR}/unittest/greetings_src && npm start &

# Run unit tests
sleep 3
python unittest/tests.py -u localhost -p 8080