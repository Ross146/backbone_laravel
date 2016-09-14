#!/usr/bin/env bash

#== Import script args ==

github_token=$(echo "$1")

#== Bash helpers ==

function info {
  echo " "
  echo "--> $1"
  echo " "
}

#== Provision script ==

info "Provision-script user: `whoami`"

info "Add bitbacket to known hosts"
ssh-keyscan -t rsa -H bitbucket.org >> ~/.ssh/known_hosts
echo "Done!"
#
#info "Configure composer"
composer config --global github-oauth.github.com ${github_token}
echo "Done!"

#info "Install plugins for composer"
composer global require "fxp/composer-asset-plugin:~1.1.1" --no-progress

#info "Install laravel"
composer global require "laravel/installer"

#info "Install project dependencies"
cd /app
composer --no-progress --prefer-dist install

#info "Create bash-alias 'app' for vagrant user"
echo 'alias app="cd /app"' | tee /home/vagrant/.bash_aliases
echo 'alias laravel="/home/vagrant/.config/composer/vendor/bin/laravel"' | tee /home/vagrant/.bash_aliases

#info "create laravel project"
app laravel new

info "Enabling colorized prompt for guest console"
sed -i "s/#force_color_prompt=yes/force_color_prompt=yes/" /home/vagrant/.bashrc
