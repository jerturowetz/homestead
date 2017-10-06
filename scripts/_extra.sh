#!/bin/bash

# Global parameter defaults
path: wordpress/
url: http://standardpro.dev

core install:
    url: 'http://standardpro.dev'
    title: 'STANDARD Products'
    admin_user: TempUser
    admin_email: TempEmail@domain.com
    admin_password: TempPass

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
