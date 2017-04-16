#!/bin/bash

source build/common.sh

mkdir -p /home/pi
cd /home/pi
wget https://raw.githubusercontent.com/gonzalo/gphoto2-updater/master/gphoto2-updater.sh
chmod +x ./gphoto2-updater.sh
./gphoto2-updater.sh --stable
