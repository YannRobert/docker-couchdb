#!/bin/bash

set -e

apt-get -y update -q
apt-get -y install software-properties-common python-software-properties
add-apt-repository ppa:nginx/stable
apt-get -y update -q
apt-get -y install nginx

# install htpasswd
apt-get -y install apache2-utils
