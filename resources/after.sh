#!/bin/bash

# Update apt-get
echo "Updating apt-get"
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes update

# Install phpX.X-ldap
echo "Installing phpX.X-ldap (matches current php version)"
PHPVersion=$(php --version | head -n 1 | cut -d " " -f 2 | cut -c 1,2,3);
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install php${PHPVersion}-ldap
