#!/bin/bash

source build/common.sh

patch_file() {
  patch -b -i /build/webserver/patches/$1.patch $1
}

apt-get -y install \
  curl \
  libwww-perl \
  nginx \
  php5-cgi \
  php5-cli \
  php5-common \
  php5-fpm \
  x11vnc \
  xfonts-75dpi \
  xfonts-cyrillic \
  xfonts-scalable \
  xvfb

chmod -R 777 /home/pi/www
patch_file /etc/php5/cgi/php.ini
patch_file /etc/php5/cli/php.ini
patch_file /etc/php5/fpm/php.ini
patch_file /etc/nginx/sites-available/default
