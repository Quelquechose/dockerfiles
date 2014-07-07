#!/bin/bash
set -x
set -e

# create quelquechose's standards users
groupadd admin
useradd -m -U -u 1337 -Gadmin,www-data -s /bin/bash  qqch

# Install a docker key for ssh connection
cat /build/keys/docker.key >> /root/.ssh/authorized_keys
mkdir -p /home/qqch/.ssh/
chown qqch:qqch /home/qqch/.ssh
chmod 700 /home/qqch/.ssh
cat /build/keys/docker.key >> /home/qqch/.ssh/authorized_keys


pwgen -N 1 | while read p; do 
    echo $p > /home/qqch/.secret
    echo qqch:$p | chpasswd
done
