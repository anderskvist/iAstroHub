#!/bin/bash

source build/common.sh

if [ "$CPU" == "arm" ] ; then
  ln -s /lib/modules/$(uname -r)/kernel/drivers/usb/serial/ftdi_sio.ko /home/pi/ftdi_sio.ko
fi
