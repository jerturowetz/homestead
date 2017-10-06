#!/usr/bin/env bash

SITE_DIR=${1}
WP_FOLDER_NAME="wordpress"

# Update WP version if possible
echo "update wordpress core to latest version"
cd "${SITE_DIR}"
wp core update --version="latest" --path="${WP_FOLDER_NAME}/"

# flush permalinks
echo "Flushing permalinks"
wp rewrite flush