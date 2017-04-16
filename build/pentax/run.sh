#!/bin/bash

source build/common.sh

apt-get -y install \
  libgtk2.0-dev \
  ufraw \
  ufraw-batch

wget https://github.com/asalamon74/pktriggercord/releases/download/v0.84.00/pkTriggerCord-0.84.00.src.tar.gz
tar xvf pkTriggerCord-0.84.00.src.tar.gz
cd pktriggercord-0.84.00
make
make install
