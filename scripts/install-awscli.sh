#!/usr/bin/env bash

# Check if aws command exists
awsexists() {
    if hash aws 2>/dev/null;
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
        noroot pip install awscli --upgrade --user
    else
        noroot pip install awscli --upgrade --user
        complete -C aws_completer aws
    fi
}


# make an uploads folder if it doesn't exist
#if [ ! -d "${SITE_PATH}/wp-content/uploads" ]; then
#	mkdir "${SITE_PATH}/wp-content/uploads"
#fi

#cd "${SITE_PATH}/wp-content/"
