#!/usr/bin/env bash

SITE_DIR="${1}"
SITE_URL="${2}"
WP_FOLDER_NAME="${3}"

cd "${SITE_DIR}"
wp core install --url="${SITE_URL}" --title=Homestead --admin_user=homestead --admin_password=secret --admin_email=tempemail@email.com --skip-email --path="${WP_FOLDER_NAME}/"

