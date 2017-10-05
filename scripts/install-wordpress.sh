#!/usr/bin/env bash

SITE_DIR=${1}
DB_NAME=${2}
SITE_URL=${3}
WP_FOLDER_NAME=${4}

WP_DIR="${SITE_DIR}/${WP_FOLDER_NAME}"

if [[ ! -f "${WP_DIR}/wp-load.php" ]]; then

	if [[ ! -d "${WP_DIR}" ]]; then
		mkdir "${WP_DIR}"
	else
		rm -rf "${WP_DIR}"
		mkdir "${WP_DIR}"
	fi

    cd "${SITE_DIR}"
	wp core download --version="latest" --path="${WP_FOLDER_NAME}/"

    cd "${SITE_DIR}"
    wp config create --dbuser=homestead --dbname="${DB_NAME}" --dbpass=secret --dbhost='127.0.0.1' --force --path="${WP_FOLDER_NAME}/" --extra-php <<PHP

    define( 'WP_DEBUG', true );
    define( 'WP_DEBUG_DISPLAY', true );
    @ini_set('display_errors', 1 );
    define( 'WP_DEBUG_LOG', false );

    define( 'WP_POST_REVISIONS', false );
    define( 'AUTOMATIC_UPDATER_DISABLED', true );
    define( 'WP_AUTO_UPDATE_CORE', false );

    # define( 'WP_MEMORY_LIMIT', '256M' );
    # define('AUTOSAVE_INTERVAL', 300 ); // seconds

    define( 'WP_CONTENT_DIR', dirname( __FILE__ ) . '/wp-content' );
    define( 'WP_CONTENT_URL', 'http://${SITE_URL}/wp-content' );

PHP

    # move config to root
    mv "${WP_DIR}/wp-config.php" "${SITE_DIR}/wp-config.php"

    # Copy (not move) index.php file to root and edit to point to correct path of wp-blog-header.php
    cp "${WP_DIR}/index.php" "${SITE_DIR}/index.php"
    sed -i "s/\/wp-blog-header/\/${WP_FOLDER_NAME}\/wp-blog-header/g" "${SITE_DIR}/index.php"

fi