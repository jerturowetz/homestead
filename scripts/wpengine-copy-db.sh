#!/usr/bin/env bash

SITE_DIR=${1}
SITE_URL=${3}
REMOTE_URL="${4}"
WP_FOLDER_NAME="${7}"
WP_ENGINE_INSTALL_NAME="${5}"

LOCAL_DB_NAME="${2}"
LOCAL_DB_USER="homestead"
LOCAL_DB_PASS="secret"

REMOTE_DB_URL="${WP_ENGINE_INSTALL_NAME}.wpengine.com"
REMOTE_DB_NAME="wp_${WP_ENGINE_INSTALL_NAME}"
REMOTE_DB_USER="${WP_ENGINE_INSTALL_NAME}"
REMOTE_DB_PASS="${6}"

# Import remote db
mysqldump -u ${REMOTE_DB_USER} -p${REMOTE_DB_PASS} -h ${REMOTE_DB_URL} ${REMOTE_DB_NAME} > dump.sql
mysqladmin -u ${LOCAL_DB_USER} -p${LOCAL_DB_PASS} drop ${LOCAL_DB_NAME} -f
mysqladmin -u ${LOCAL_DB_USER} -p${LOCAL_DB_PASS} create ${LOCAL_DB_NAME}
mysql -u ${LOCAL_DB_USER} -p${LOCAL_DB_PASS} ${LOCAL_DB_NAME} < dump.sql
rm dump.sql

# Search replace old url to new url on db
cd "${SITE_DIR}"
echo "Running search & replace tasks"
wp search-replace "${REMOTE_URL}" "${SITE_URL}" --format=count

cd "${SITE_DIR}"
echo "Reset home urls"
wp option update home "${SITE_URL}"
wp option update siteurl "${SITE_URL}/${WP_FOLDER_NAME}"

