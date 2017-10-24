#!/usr/bin/env bash
SITE_DIR="${1}"
SFTP_SERVER="${2}"
SFTP_USER="${3}"
SFTP_PASS="${4}"

UPLOADS_DIR="${SITE_DIR}/wp-content/uploads"

# Install ssh pass
echo "installing sshpass"
sudo apt install sshpass

# Copy contents of sftp server /wp-content/uploads
if [[ ! -d "${UPLOADS_DIR}" ]];
then
    mkdir "${UPLOADS_DIR}"
fi

cd ${UPLOADS_DIR}
export SSHPASS=EJ69jSpAndmOTpeB

sshpass -e sftp -oPort=2222 -o StrictHostKeyChecking=no shaktigym-provision@shaktigym.sftp.wpengine.com:/wp-content/uploads <<EOF
echo "copying contents of WP Engine wp-content/uploads folder, this can take a minute"
get -r *
exit
EOF
