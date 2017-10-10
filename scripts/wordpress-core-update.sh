#!/usr/bin/env bash

SITE_DIR="${1}"
SITE_URL="${2}"
WP_FOLDER_NAME="${3}"

# Update WP version if possible
echo "update wordpress core to latest version"
cd "${SITE_DIR}"
wp core update --version="latest" --path="${WP_FOLDER_NAME}/"

# flush permalinks
echo "Flushing permalinks"
wp rewrite flush

# Set Home URLS
echo "Reset home urls"
cd "${SITE_DIR}"
echo "${SITE_URL}/${WP_FOLDER_NAME}"
wp option update home "http://${SITE_URL}"
wp option update siteurl "http://${SITE_URL}/${WP_FOLDER_NAME}"
