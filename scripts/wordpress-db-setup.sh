#!/usr/bin/env bash

SITE_DIR="${1}"
LOCAL_DB_NAME="${2}"
LOCAL_DB_USER="homestead"
LOCAL_DB_PASS="secret"

HOMESTEAD_SITE_URL="${3}"

WP_FOLDER_NAME="${4}"
WP_ENGINE_INSTALL_NAME="${5}"

REMOTE_DB_URL="${WP_ENGINE_INSTALL_NAME}.wpengine.com"
REMOTE_DB_NAME="wp_${WP_ENGINE_INSTALL_NAME}"
REMOTE_DB_USER="${WP_ENGINE_INSTALL_NAME}"
REMOTE_DB_PASS="${6}"

while true;
do
    if (( $# == 6 )) && mysql -u "${REMOTE_DB_USER}" -p"${REMOTE_DB_PASS}" -h "${REMOTE_DB_URL}" "${REMOTE_DB_NAME}" -e ";" ;
    then
        echo "dumpig database from prod to local site folder"
        mysqldump -u ${REMOTE_DB_USER} -p${REMOTE_DB_PASS} -h ${REMOTE_DB_URL} ${REMOTE_DB_NAME} > "${SITE_DIR}/mysql.sql"
    fi

    if [ -f "${SITE_DIR}/mysql.sql" ];
    then
        echo "Copying mysql.sql found in site folder to dump file"
        cp "${SITE_DIR}/mysql.sql" dump.sql
        break
    fi

    break

done

if [ -f "dump.sql" ];
then
    echo "found dump file, importing and erasing"
    mysqladmin -u ${LOCAL_DB_USER} -p${LOCAL_DB_PASS} drop ${LOCAL_DB_NAME} -f
    mysqladmin -u ${LOCAL_DB_USER} -p${LOCAL_DB_PASS} create ${LOCAL_DB_NAME}
    mysql -u ${LOCAL_DB_USER} -p${LOCAL_DB_PASS} ${LOCAL_DB_NAME} < dump.sql
    rm dump.sql
else
    echo "install wp from scratch"
    cd "${SITE_DIR}"    
    wp core install --url="${SITE_URL}" --title=Homestead --admin_user=homestead --admin_password=secret --admin_email=tempemail@email.com --skip-email --path="${WP_FOLDER_NAME}/"
fi

#echo "Reset home urls"
cd "${SITE_DIR}"
wp option update home "${SITE_URL}"
wp option update siteurl "${SITE_URL}/${WP_FOLDER_NAME}"
