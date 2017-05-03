#!/bin/bash


# Get branch
if [ -z "$1" ]; then
    echo "Usage: ./upload_code_to_s3.sh ENV BRANCH"
    echo "Example: ./upload_code_to_s3.sh test release_1.1"
    echo "Using environment defaults"
else
    ENV=$1
fi

if [ -z "$2" ]; then
    echo "Using environment defaults for branches"
    case "$2" in
        dev)
        BRANCH=master
        ;;
        test)
        BRANCH=master
        ;;
        demo)
        BRANCH=production
        ;;
        prod)
        BRANCH=production
        ;;
    esac
else
    BRANCH=$2
fi

# Force clean checkout
if [ ! -d "src" ]; then
    mkdir src
else
    rm -rf src
    mkdir src
fi

# Check out project
cd src
git clone "https://github.com/maplebird/greetings_src.git"
cd greetings_src
git checkout ${BRANCH}
git pull
cd ..

# Clean upload to an S3 bucket... aws s3 sync usually ignores files with same size
export AWS_ACCESS_KEY_ID=$(cat /root/aws_access_key)
export AWS_SECRET_ACCESS_KEY=$(cat /root/aws_secret_key)
aws s3 rm s3://maplebird-greetings-project/${ENV} --recursive
aws s3 cp greetings_src s3://maplebird-greetings-project/${ENV}/ --recursive --exclude .git*
