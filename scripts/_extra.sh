#!/bin/bash

# execute something as vagrant user
noroot() {
  sudo -EH -u "vagrant" "$@";
}

# Update apt-get
echo "Updating apt-get"
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes update

# Install phpX.X-ldap
echo "Installing phpX.X-ldap (matches current php version)"
PHPVersion=$(php --version | head -n 1 | cut -d " " -f 2 | cut -c 1,2,3);
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install php${PHPVersion}-ldap


## Local Variables
LOCAL_SITE_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOCAL_SCRIPTS_PATH="${LOCAL_SITE_PATH}/provision-scripts/host-machine"

# execute as vagrant user
noroot() {
  sudo -EH -u "vagrant" "$@";
}

# Need to somehow get these from host machine
# REMOTE_SITE_PATH="/home/vagrant/sites/standard"
# REMOTE_SCRIPTS_PATH="${REMOTE_SITE_PATH}/provision-scripts/guest-machine"
# SITE_DB_NAME="standardpro"
# SITE_URL="http://standardpro.dev"
# WP_DIR="wordpress"

# Update apt-get
echo "Updating apt-get"
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes update

# Install php${PHPVersion}-ldap
PHPVersion=$(php --version | head -n 1 | cut -d " " -f 2 | cut -c 1,2,3);
echo "Installing php${PHPVersion}-ldap (matches current php version)"
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install php${PHPVersion}-ldap

# Download the latest stable version of WordPress
if [[ ! -f "${WP_PATH}/wp-load.php" ]]; then

	if [[ ! -d "${WP_PATH}" ]]; then
		mkdir "${WP_PATH}"
	else
		rm -rf "${WP_PATH}"
		mkdir "${WP_PATH}"
	fi

    cd "${WP_PATH}"
	noroot wp core download --version="latest"

fi

# create the wp-config.php file (relies on infor in wp-cli.yml)
cd "${SITE_DIR}"
noroot wp config create --force

# Import remote db
echo "Copy remote database to dump file"
mysqldump -u standardpro -p5RytVxO3ByHhIcPg -h standardpro.wpengine.com wp_standardpro > dump.sql
echo "Drop local database"
mysqladmin -u homestead -psecret drop standardpro -f
echo "Create empty local database"
mysqladmin -u homestead -psecret create standardpro
echo "Import dumpfile to new database"
mysql -u homestead -psecret standardpro < dump.sql
echo "remove dump file"
rm dump.sql

# Update WP version if possible
echo "update wordpress core to latest version"
noroot wp core update --version="latest"

# Update the site url for wordpress in a sub folder
echo "Running search and replace on old urls to local dev urls"
wp search-replace 'http://standardpro.com' 'http://standardpro.dev' --format=count
wp search-replace 'http://www.standardpro.com' 'http://standardpro.dev' --format=count
wp search-replace 'http://standardpro.staging.wpengine.com' 'http://standardpro.dev' --format=count
wp option update home 'http://standardpro.dev'
wp option update siteurl 'http://standardpro.dev/wordpress'

# move config to root
cd "${SITE_DIR}"
mv "${WP_DIR}/wp-config.php" "${SITE_DIR}/wp-config.php"

# Copy (not move) index.php file to root and edit to point to correct path of wp-blog-header.php
cp "${WP_DIR}/index.php" "${SITE_DIR}/index.php"
sed -i "s/\/wp-blog-header/\/${WP_DIR}\/wp-blog-header/g" "${SITE_DIR}/index.php"

# Clone Jer's plugins repo
if [[ ! -f "${SITE_DIR}/wp-content/plugins/index.php" ]]; then
    echo "Cloning Jer's plugins repo"
    cd ${SITE_DIR}/wp-content
    git clone git@github.com:JerTurowetz/.wp-plugins.git plugins
else
    echo "Updating Jer's plugins repo"
    cd ${SITE_DIR}/wp-content/plugins
    git pull
fi

# Set permissions on plugins folder
echo "Setting file and folder permissions on wordpress folder contents"
cd ${SITE_DIR}
sudo find ./wp-config.php -type f -exec chmod 644 {} +
sudo find ./index.php -type f -exec chmod 644 {} +
sudo find ./wordpress -type d -exec chmod 755 {} +
cd ${SITE_DIR}/wordpress
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

# flush permalinks
echo "Flushing permalinks"
cd "${SITE_DIR}"
wp rewrite flush

# Copy WP engine uploads folder to project
# echo "Copy WP engine uploads folder to project"
#lftp -e 'mirror uploads test --parallel=10 --ignore-time --no-perms;quit' -u standardpro-provision,M8!b6lliPG!Uf6 -p 2222 sftp://standardpro.sftp.wpengine.com --dry-run
#echo -e "\033[0;31mThere is currently no way to copy of the WP Engine hosted uploads folder without a password - do this manually\033[0m"
# sudo apt install sshpass
#then we can scp ?
# sshpass
# echo "Copying the standardpro WP Engine uploads folder - this might take a while, please be patient"
# lftp -e 'mirror uploads test --parallel=10 --ignore-time --no-perms;quit' -u standardpro-provision,M8!b6lliPG!Uf6 -p 2222 sftp://standardpro.sftp.wpengine.com --dry-run
# Unfortunately, this requires a password...
# scp -P 2222 -rp standardpro-provision@standardpro.sftp.wpengine.com:/* ./wp-content/uploads

# export AWS_PROFILE=standard
# aws_access_key_id=`curl http://169.254.169.254/latest/meta-data/iam/security-credentials/${instance_profile} | grep AccessKeyId | cut -d':' -f2 | sed 's/[^0-9A-Z]*//g'`
# aws_secret_access_key=`curl http://169.254.169.254/latest/meta-data/iam/security-credentials/${instance_profile} | grep SecretAccessKey | cut -d':' -f2 | sed 's/[^0-9A-Za-z/+=]*//g'`
# AWS_ACCESS_KEY_ID=
# AWS_SECRET_ACCESS_KEY=
# aws_access_key_id
# aws_secret_access_key
# Sync with AWS uploads folder
# Sync was missing all kinds of stuff, maybe due to windows env, I'm using cp instead to be safe
# echo "AWS bucket sync to windows is a slow and annoying process, you'll need to run a manual copy of the uploads folder"
# export AWS_PROFILE=standard
# aws s3 sync s3://largefs-standardpro/standardpro/wp-content/uploads/ "${SITE_PATH}/wp-content/uploads/"
# aws s3 cp s3://largefs-standardpro/standardpro/wp-content/uploads/ "${SITE_PATH}/wp-content/uploads/" --recursive

# should probably only do this once...
# echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
