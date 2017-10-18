#!/usr/bin/env bash

SITE_DIR="${1}"
DB_NAME="${2}"
SITE_URL="${3}"
WP_FOLDER_NAME="${4}"

WP_DIR="${SITE_DIR}/${WP_FOLDER_NAME}"

if [[ ! -f "${WP_DIR}/wp-load.php" ]];
then

	if [[ ! -d "${WP_DIR}" ]];
    then
		mkdir "${WP_DIR}"
        cd "${SITE_DIR}"
	    wp core download --version="latest" --path="${WP_FOLDER_NAME}/"
	fi

fi
