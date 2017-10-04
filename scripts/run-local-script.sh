#!/usr/bin/env bash

#argument count
if [ ${#} != 2 ]
then
    echo "${#} arguments supplied, expecting 2 arguments"
    exit 1
fi

cd ${1}
${2}
echo "all done"
