#!/usr/bin/env bash

# export AWS_PROFILE=standard
# aws_access_key_id=`curl http://169.254.169.254/latest/meta-data/iam/security-credentials/${instance_profile} | grep AccessKeyId | cut -d':' -f2 | sed 's/[^0-9A-Z]*//g'`
# aws_secret_access_key=`curl http://169.254.169.254/latest/meta-data/iam/security-credentials/${instance_profile} | grep SecretAccessKey | cut -d':' -f2 | sed 's/[^0-9A-Za-z/+=]*//g'`
# AWS_ACCESS_KEY_ID=
# AWS_SECRET_ACCESS_KEY=
# aws_access_key_id
# aws_secret_access_key
# Sync with AWS uploads folder
# Sync was missing all kinds of stuff, maybe due to windows env, I'm using cp instead to be safe
# echo "AWS bucket sync to windows is a slow and annoying process, you'll need to run a manual copy of the uploads folder"
# export AWS_PROFILE=standard
# aws s3 sync s3://largefs-standardpro/standardpro/wp-content/uploads/ "${SITE_PATH}/wp-content/uploads/"
# aws s3 cp s3://largefs-standardpro/standardpro/wp-content/uploads/ "${SITE_PATH}/wp-content/uploads/" --recursive
