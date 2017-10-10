#!/usr/bin/env bash
SITE_DIR="${1}"
SFTP_SERVER="${2}"
SFTP_USER="${3}"
SFTP_PASS="${4}"

LOCAL_UPLOADS_FOLDER="wp-content/uploads"

# Install ssh pass
echo "installing sshpass"
sudo apt install sshpass

# Copy contents of sftp server /wp-content/uploads
if [[ ! -d "${SITE_DIR}/${LOCAL_UPLOADS_FOLDER}" ]];
then
    mkdir "${SITE_DIR}/${LOCAL_UPLOADS_FOLDER}"
fi

echo "copying contents of WP Engine wp-content/uploads folder, this can take a minute"
sshpass -p "${SFTP_PASS}" scp -P 2222 -o StrictHostKeyChecking=no -r "${SFTP_USER}@${SFTP_SERVER}:/wp-content/uploads/." "${SITE_DIR}/${LOCAL_UPLOADS_FOLDER}/"
