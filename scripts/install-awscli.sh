#!/usr/bin/env bash

# Check if aws command exists
awsexists() {
    if hash aws 2>/dev/null
    then
        echo "status of aws false"
        return 1 # 1 = false
    else
        echo "status of aws true"
        return 0 # 0 = true
    fi
}

# install aws cli if it exists, update if not
awscli() {
    if awsexists
    then
        echo "this one"
        pip install awscli --upgrade --user
    else
        echo "tat one"
        pip install awscli --upgrade --user
        complete -C aws_completer aws
    fi
}

awscli
