#!/bin/bash

set -e

apt-get -y update -q
apt-get -y install software-properties-common python-software-properties
add-apt-repository ppa:nginx/stable
apt-get -y update -q
apt-get -y install nginx

# Change default nginx log rotation to daily, and keep only 1 day
sed -i "s/weekly/daily/;s/rotate 52/rotate 1/" /etc/logrotate.d/nginx

# configure nginx
rm -rf /etc/nginx
cp -r /src/etc/nginx /etc/nginx && chown -R root:root /etc/nginx

# install htpasswd
apt-get -y install apache2-utils

# Use htpasswd to generate a default htpasswd file with user couchdb:couchdb
mkdir /secret
PASS=$(pwgen -s 12 1)
htpasswd -b -c /secret/htpasswd couchdb ${PASS}

echo "========================================================================"
echo "You can now connect to this CouchDB server using:"
echo ""
echo "    curl http://couchdb:$PASS@<host>:<port>"
echo ""
echo "Please remember to change the above password as soon as possible, by setting the /secret volume to a directory containing an alternative htpasswd file"
echo "========================================================================"
