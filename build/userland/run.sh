#!/bin/bash

source build/common.sh

if [ "$CPU" == "arm" ] ; then
  apt-get -y install \
    build-essential \
    cmake \
    git

  git clone https://github.com/raspberrypi/userland.git /home/pi/userland
  cd /home/pi/userland
  git reset --hard f0642e3b58d8a140a3f7621630c15fbfa794b19d
  export CXX=g++
  export CC=gcc
  ./buildme

  echo "/opt/vc/lib" > /etc/ld.so.conf.d/00-vcms.conf
  ldconfig
fi
