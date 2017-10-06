#!/usr/bin/env bash

LOCAL_DB_NAME="${1}"
LOCAL_DB_USER="homestead"
LOCAL_DB_PASS="secret"

WP_ENGINE_INSTALL_NAME="${2}"

REMOTE_DB_URL="${WP_ENGINE_INSTALL_NAME}.wpengine.com"
REMOTE_DB_NAME="wp_${WP_ENGINE_INSTALL_NAME}"
REMOTE_DB_USER="${WP_ENGINE_INSTALL_NAME}"
REMOTE_DB_PASS="${3}"

LOCAL_URL="${4}"
REMOTE_URL="${5}"

# Import remote db
mysqldump -u ${REMOTE_DB_USER} -p${REMOTE_DB_PASS} -h ${REMOTE_DB_URL} ${REMOTE_DB_NAME} > dump.sql
mysqladmin -u ${LOCAL_DB_USER} -p${LOCAL_DB_PASS} drop ${LOCAL_DB_NAME} -f
mysqladmin -u ${LOCAL_DB_USER} -p${LOCAL_DB_PASS} create ${LOCAL_DB_NAME}
mysql -u ${LOCAL_DB_USER} -p${LOCAL_DB_PASS} ${LOCAL_DB_NAME} < dump.sql
rm dump.sql

# Update the site url for wordpress in a sub folder
echo "Running search and replace on old urls to local dev urls"

wp search-replace "http://${REMOTE_URL}" "http://${LOCAL_URL}" --format=count
wp search-replace "http://www.${REMOTE_URL}" "http://${LOCAL_URL}" --format=count
wp search-replace "http://${WP_ENGINE_INSTALL_NAME}.staging.wpengine.com" "http://${LOCAL_URL}" --format=count

wp option update home "http://${LOCAL_URL}"
wp option update siteurl "http://${LOCAL_URL}/wordpress"