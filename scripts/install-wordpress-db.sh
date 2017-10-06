#!/usr/bin/env bash

SITE_DIR=${1}
DB_NAME=${2}
SITE_URL=${3}
WP_FOLDER_NAME="wordpress"

WP_DIR="${SITE_DIR}/${WP_FOLDER_NAME}"

if [[ ! -f "${WP_DIR}/wp-load.php" ]]; then    
    # Install wp
    wp core install --url=${SITE_URL} --title=temptitle --admin_user=tempuser --admin_password=temppassword --admin_email=temp@temp.com --skip-email --path="${WP_FOLDER_NAME}/"
    wp option update home "${SITE_URL}" --path="${WP_FOLDER_NAME}/"
    wp option update siteurl "${SITE_URL}/${WP_FOLDER_NAME}" --path="${WP_FOLDER_NAME}/"
fi