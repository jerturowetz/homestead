#!/usr/bin/env bash

if [ ${#} != 2 ]
then
    echo "${#} arguments supplied, expecting 2 arguments"
    exit 1
fi

cd ${1}
${2}
