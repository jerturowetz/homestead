#!/usr/bin/env bash

# Copy WP engine uploads folder to project
echo "Copy WP engine uploads folder to project"
lftp -e 'mirror uploads test --parallel=10 --ignore-time --no-perms;quit' -u standardpro-provision,M8!b6lliPG!Uf6 -p 2222 sftp://standardpro.sftp.wpengine.com --dry-run
echo -e "\033[0;31mThere is currently no way to copy of the WP Engine hosted uploads folder without a password - do this manually\033[0m"
sudo apt install sshpass
sshpass
echo "Copying the standardpro WP Engine uploads folder - this might take a while, please be patient"
lftp -e 'mirror uploads test --parallel=10 --ignore-time --no-perms;quit' -u standardpro-provision,M8!b6lliPG!Uf6 -p 2222 sftp://standardpro.sftp.wpengine.com --dry-run
Unfortunately, this requires a password...
scp -P 2222 -rp standardpro-provision@standardpro.sftp.wpengine.com:/* ./wp-content/uploads


"wpackagist-plugin/akismet":"*",