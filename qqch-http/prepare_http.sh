#!/bin/bash

set -e 
set -x


echo "Update the munin-node configuration"
echo "
#qqch/http munin

[nginx*]
env.url http://localhost/nginx-status

[apache_*]
env.url   http://localhost:%d/server-status?auto
env.ports 8080

" >> /etc/munin/plugin-conf.d/munin-node

echo "Enable some apache stuff"
a2enmod status
a2enmod headers
a2enmod deflate
a2enmod rewrite
a2enmod rpaf
cp /build/overrides/etc/apache2/conf-available/* /etc/apache2/conf-available/
a2enconf globale-servername
a2enconf data-access

echo "Enable stub-status for nginx"
ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/
unlink /etc/nginx/sites-enabled/default

mkdir -p /data/www
chown -R www-data:www-data /data/www
