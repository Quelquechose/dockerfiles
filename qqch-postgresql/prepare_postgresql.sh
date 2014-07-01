#!/bin/bash
CLUSTER_VERSION=`pg_lsclusters -h|awk '{print $1}'`

set -e 
set -x

sudo -u postgres service postgresql stop

echo "Dropping current cluster"
sudo -u postgres pg_dropcluster $CLUSTER_VERSION main

echo "Creating new cluster with UTF8 encoding"
sudo -u postgres pg_createcluster --locale=fr_FR.UTF8 $CLUSTER_VERSION main

# Allow connections from anywhere.
sed -i -e"s/^#listen_addresses =.*$/listen_addresses = '*'/" /etc/postgresql/$CLUSTER_VERSION/main/postgresql.conf
echo "host    all    all    0.0.0.0/0    md5" >> /etc/postgresql/$CLUSTER_VERSION/main/pg_hba.conf

sudo -u postgres service postgresql start


pwgen -N 1 | while read p; do sudo -u postgres psql -q <<- EOF
	DROP ROLE IF EXISTS admin;
	CREATE ROLE admin WITH ENCRYPTED PASSWORD '$p';
	ALTER ROLE admin WITH SUPERUSER;
	ALTER ROLE admin WITH LOGIN;
EOF
echo "admin $p" > /root/postgresql.readme
done

sudo -u postgres service postgresql stop

