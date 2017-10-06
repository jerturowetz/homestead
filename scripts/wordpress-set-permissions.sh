#!/usr/bin/env bash

SITE_DIR="${1}"
WP_FOLDER_NAME="${2}"

# Set permissions on plugins folder
echo "Setting file and folder permissions on wordpress folder contents"
cd ${SITE_DIR}
sudo find ./wp-config.php -type f -exec chmod 644 {} +
sudo find ./index.php -type f -exec chmod 644 {} +
sudo find ./wordpress -type d -exec chmod 755 {} +

cd ${SITE_DIR}/${WP_FOLDER_NAME}
sudo find . -type f -exec chmod 644 {} +
sudo find . -type d -exec chmod 755 {} +

# Set permissions on plugins folder
echo "Setting file and folder permissions on plugins folder"
cd ${SITE_DIR}/wp-content/plugins
sudo find . -type f -exec chmod 644 {} +
sudo find . -type d -exec chmod 755 {} +

# Set permissions on theme folder
echo "Setting file and folder permissions on theme folder"
cd ${SITE_DIR}/wp-content/themes
sudo find . -type f -exec chmod 644 {} +
sudo find . -type d -exec chmod 755 {} +