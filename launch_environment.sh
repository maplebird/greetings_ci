#!/usr/bin/env bash

# Get environment
if [ -z "$1" ]; then
    echo "Usage: ./launch_environment.sh ENV"
    echo "Example:"
    echo "    ./launch_environment.sh test"
    exit
else
    ENV=$1
fi

echo "Creating ${ENV} ASG on `date`"

# Upload source code to S3

cd ansible
ansible-playbook launch_asg.yml -e "greetings_env=${ENV}"