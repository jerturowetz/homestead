#!/usr/bin/env bash

SITE_DIR="${1}"
LOCAL_DB_NAME="${2}"

# # Homestead already copies .my.cnf to the /home/vagrant folder so we shouldn't need the following
# LOCAL_DB_USER="homestead"
# LOCAL_DB_PASS="secret"
# # I've also removed inline user & pass from the scripts below

HOMESTEAD_SITE_URL="${3}"

WP_FOLDER_NAME="${4}"
WP_ENGINE_INSTALL_NAME="${5}"

REMOTE_DB_URL="${WP_ENGINE_INSTALL_NAME}.wpengine.com"
REMOTE_DB_NAME="wp_${WP_ENGINE_INSTALL_NAME}"
REMOTE_DB_USER="${WP_ENGINE_INSTALL_NAME}"
REMOTE_DB_PASS="${6}"


if (( $# == 6 )) && mysql -u "${REMOTE_DB_USER}" -p"${REMOTE_DB_PASS}" -h "${REMOTE_DB_URL}" "${REMOTE_DB_NAME}" -e ";" ;
then
    echo "Mysql connection looks good :: dumping database from prod to local site folder"
    mysqldump -u ${REMOTE_DB_USER} -p${REMOTE_DB_PASS} -h ${REMOTE_DB_URL} ${REMOTE_DB_NAME} > "${SITE_DIR}/mysql.sql"
fi


if [ -f "${SITE_DIR}/mysql.sql" ];
then
    echo "mysql.sql found in site folder: copying to dump file"
    cp "${SITE_DIR}/mysql.sql" dump.sql
fi

if [ -f "dump.sql" ];
then
    echo "found dump.sql file, going to drop current db and import dump file"
    mysqladmin drop ${LOCAL_DB_NAME} -f
    mysqladmin create ${LOCAL_DB_NAME}
    mysql ${LOCAL_DB_NAME} < dump.sql
    echo "erasing dump file so it wont screw up the next install"
    rm dump.sql
else
    echo "install wp db from scratch - migh cause errors if db doesn't exist? dropping is important if db doesn exist"
    cd "${SITE_DIR}"
    mysqladmin drop ${LOCAL_DB_NAME} -f
    mysqladmin create ${LOCAL_DB_NAME}
    wp core install --url="${SITE_URL}" --title=Homestead --admin_user=homestead --admin_password=secret --admin_email=tempemail@email.com --skip-email --path="${WP_FOLDER_NAME}/"
fi
