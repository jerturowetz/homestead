#!/usr/bin/env bash

# Check if aws command exists
awsexists() {
    #command -v aws >/dev/null 2>&1 || { echo >&2 "I require aws but it's not installed.  Aborting."; }
    #type aws >/dev/null 2>&1 || { echo >&2 "I require aws but it's not installed.  Aborting."; }
    #hash aws 2>/dev/null || { echo >&2 "I require aws but it's not installed.  Aborting."; }
    if command -v aws >/dev/null 2>&1;
    then
        return 0 # 0 = true
    else
        return 1 # 1 = false
    fi
}

# install aws cli if it exists, update if not
awscli() {
    if awsexists
    then
        pip install awscli --upgrade --user
    else
        pip install awscli --upgrade --user
        complete -C aws_completer aws
    fi
}

awscli
