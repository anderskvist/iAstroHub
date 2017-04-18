#!/bin/bash

source build/common.sh

patch_file() {
  patch -b -i /build/run_control/patches/$1.patch $1
}

patch_file /etc/rc.local
