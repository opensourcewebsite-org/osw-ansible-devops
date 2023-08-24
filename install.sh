#!/usr/bin/env bash

set -euo pipefail

UBUNTU_VERSION=$(grep -F VERSION_ID /etc/os-release | cut -d\" -f2)
UBUNTU_CODENAME=$(grep -F VERSION_CODENAME /etc/os-release | cut -d= -f2)

apt-get update
apt-get install -y ansible
apt-get install -y mc

cd /srv
git clone git@github.com:opensourcewebsite-org/osw-ansible-devops.git
cd /srv/osw-ansible-devops

# Copy a file with user-passwords
echo 'PleaseChangeThisVerySecretPassword12' > /srv/user-passwords.txt
