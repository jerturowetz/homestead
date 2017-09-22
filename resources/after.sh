#!/bin/bash

# execute something as vagrant user
noroot() {
  sudo -EH -u "vagrant" "$@";
}

# do wp cli stuff
wp_cli() {
  # WP-CLI Install
  local exists_wpcli

  # Remove old wp-cli symlink, if it exists.
  if [[ -L "/usr/local/bin/wp" ]]; then
    echo "Removing old wp-cli"
    rm -f /usr/local/bin/wp
  fi

  exists_wpcli="$(which wp)"
  if [[ "/usr/local/bin/wp" != "${exists_wpcli}" ]]; then
    echo -e "Downloading wp-cli, see http://wp-cli.org"
    sudo curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli-nightly.phar
    sudo chmod +x wp-cli-nightly.phar
    sudo mv wp-cli-nightly.phar /usr/local/bin/wp

    # Install bash completions
    sudo curl -s https://raw.githubusercontent.com/wp-cli/wp-cli/master/utils/wp-completion.bash -o /srv/config/wp-cli/wp-completion.bash
  else
    echo -e "Updating wp-cli..."
    sudo wp --allow-root cli update --nightly --yes
  fi
}

# Check if aws command exists
awsexists() {
    if hash aws 2>/dev/null;
    then
        return 0 # 0 = true
    else
        return 1 # 1 = false
    fi
}

# install aws cli if it exists, update if not
awscli() {
    if awsexists
    then
        noroot pip install awscli --upgrade --user
    else
        noroot pip install awscli --upgrade --user
        complete -C aws_completer aws
    fi
}

# Update apt-get
echo "Updating apt-get"
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes update

# Install phpX.X-ldap
echo "Installing phpX.X-ldap (matches current php version)"
PHPVersion=$(php --version | head -n 1 | cut -d " " -f 2 | cut -c 1,2,3);
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install php${PHPVersion}-ldap

# install/update wp cli
echo "Installing/updating wp-cli"
wp_cli

# install/update aws cli
echo "Installing/updating aws cli"
awscli

echo ""
echo "Last line here! next step should be hitting up the individual installs"
