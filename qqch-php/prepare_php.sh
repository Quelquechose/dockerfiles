#!/bin/bash

set -e 
set -x

#install upload progress from pecl for filez
pecl install uploadprogress

# enable some apache stuff
sudo a2enmod php5
