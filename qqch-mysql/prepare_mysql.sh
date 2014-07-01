#!/bin/bash
set -e 
set -x

/usr/bin/mysqld_safe > /dev/null 2>&1 &

set +x
echo "Waiting for mysqld to start"
RET=1
while [[ RET -ne 0 ]]; do
	sleep 5
	mysql -uroot -e "status" > /dev/null 2>&1
	RET=$?
done
#set -x


pwgen -N 1 | while read p; do mysql -uroot <<- EOF
        USE mysql;
	UPDATE user SET Password=PASSWORD('$p') WHERE User='root';
        FLUSH PRIVILEGES;
EOF
set +x
echo "
# Automatically generated scripts. DO NOT TOUCH!
[client]
host     = localhost
user     = root
password = $p
socket   = /var/run/mysqld/mysqld.sock
" > /root/my.cnf
done


