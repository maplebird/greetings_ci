#!/usr/bin/env bash

# Get environment
if [ -z "$1" ]; then
    echo "Usage: ./deploy.sh ENV BRANCH (if branch is not specified, will deploy default for the environment"
    echo "Example:"
    echo "    ./deploy.sh test release_1.0"
    exit
else
    ENV=$1
fi

if [ -z "$2" ]; then
    echo "Deploying ${ENV} on `date`"
    BRANCH_ANSIBLE_ARG=""
else
    BRANCH_ANSIBLE_ARG="-e \"code_branch=$2\""
    echo "Deploying ${BRANCH} on ${ENV} on `date`"
fi

ansible-playbook remote_deploy.yml -e "greetings_env=${ENV}" ${BRANCH_ANSIBLE_ARG}