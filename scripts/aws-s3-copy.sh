#!/usr/bin/env bash

SITE_DIR="${1}"

export AWS_ACCESS_KEY_ID="${2}"
export AWS_SECRET_ACCESS_KEY="${3}"

# Sync was missing all kinds of stuff, maybe due to windows env, I'm using cp instead to be safe
# aws s3 cp s3://largefs-standardpro/standardpro/wp-content/uploads/ "${SITE_DIR}/wp-content/uploads/" --recursive
aws s3 sync s3://largefs-standardpro/standardpro/wp-content/uploads/ "${SITE_DIR}/wp-content/uploads/"
