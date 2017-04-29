# iAstroHub via Docker

This README outlines how to run iAstroHub inside a Docker container. It is a work in progress and not yet fully functional.

Remaining work to be done towards this ends is:

* Dockerize iAstroHub software
* Validate Dockerized hardware control works on Raspbian
* Enable full iAstroHub deployment via AstroSwarm

## Prerequisites

* MacOS or Linux development environment
* Docker installed and running

## Building

* From the iAstroHub root directory, run `./build`

## Running the container

* For full functionality, you must run the container with the `--cap-add SYS_RAWIO` option, or alternatively, with the --privileged flag. You can test the SYS_RAWIO capability by running `/usr/local/bin/pktriggercord-cli -v`.

### Manual Steps

The following steps are not yet automated, and so must be run by hand on the final image.

#### Skychart

* Launch `skychart`
* Setup > Observatory
* Setup > Chart, coordinate > check Equatorial, Apparent
* Setup > Catalog > Check XHIP
* Setup > Display > uncheck finders, show labels, show mark index
* Click "show pictures" icon to disable
* Exit and save setting

#### Lin_guider

* cd /home/pi/lin_guider_pack/lin_guider/
* ./lin_guider
* Setup > Video Settings > Device
* Setup > Video Settings > Expo
* Setup > Video Settings > Frame
* Setup > Pulse Device Settings > Device
* Setup > General Settings > Check "drift data"
* Setup > General Settings > Dithering timeout = 10 sec
* Processing > Calibration > Check "auto mode" and "two axis" (if guiding both axes)

## Dockerization Notes and Changes

The following changes have been made while Dockerizing iAstroHub:

* /etc/hosts IP address for iAstroHub host is 127.0.0.1, instead of 127.0.1.1.
* Skychart upgraded to version 4.
* Used an x64 compatible fix for chipset detection in sbig module for OpenSkyImager. It is the same one used in this pull request: https://github.com/OpenSkyProject/OpenSkyImager/pull/16/files
* GoQat upgraded from 2.0.0 to 2.1.1; includes native support for INDI removeDevice.
* indi_simple_html_cherrypy_server binds to 0.0.0.0 instead of 10.0.0.1, so it is not dependent on a specific network-available IP address
* max_usb_current no longer set; has no effect on Raspberry Pi 3, which provides 1.2A by default. See: https://www.raspberrypi.org/forums/viewtopic.php?p=930695#p930695

### Docker Run Requirements

* Be sure to run `docker run` with the `--device=/dev/vchiq` flag for `vcgencmd` operations.
 
## Workflow Changes

### Patches

Files that previously lived in "modified_codes", as well as config file changes, are now persisted as patches. This way they remain compatible with other minor changes to the same set of files.

The patch files live in a "patches" directory within the ./build/<tool name> directory. The structure of each "patches" directory mirrors that of the container image, so if you are patching "/home/pi/foo.txt", the patch will live at "./build/<tool name>/home/pi/foo.txt.patch".

Patches are created via `diff -u <old file version> <new file version> > <original filename>.patch`. When patches are applied, the original file is renamed to <original filename>.orig so that it is available for post hoc inspection. If you need to make further changes to these files, make them in the container, and then recreate the patch by running `diff -u <filename> <filename.orig> > <filename>.patch`.

You can then copy your latest patch into this git repository by running: `docker cp <container hash>:<filepath>.patch build/<tool name>/patches/<filepath>.patch`.

## Status

Below is everything in the original README that has not yet been ported to Docker. As features are ported over, they are removed from the text below.

```

1. install Raspbian (2016-05-27-raspbian-jessie-lite)

Log-in via SSH or console
************************
user: pi
password: raspberry

sudo passwd
password: raspberry


sudo nano /etc/ssh/sshd_config
****************************************
#PermitRootLogin without-password
#StrictModes yes
PermitRootLogin yes


sudo raspi-config
************************
Expand filesystem and disable serial in advanced options, exit and reboot.



4. Wifi AP mode

sudo apt-get install dnsmasq hostapd

sudo nano /etc/hostapd/ap.conf
************ ADD ******************
interface=wlan0
hw_mode=g
channel=10
auth_algs=1
wpa=2
wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP
rsn_pairwise=CCMP
wpa_passphrase=1234512345123
ssid=iAstroHub


sudo nano /etc/dnsmasq.conf
******* ADD *******
interface=wlan0
dhcp-range=10.0.0.2,10.0.0.5,255.255.255.0,12h


sudo nano /etc/rc.local
*******************************************************
sudo ifconfig wlan0 down
sudo ifconfig wlan0 10.0.0.1 netmask 255.255.255.0 up
sudo iwconfig wlan0 power off
sudo service dnsmasq restart
sudo hostapd -B /etc/hostapd/ap.conf & > /dev/null 2>&1



17. FTDI modules

mv /lib/modules/4.4.13-v7+/kernel/drivers/usb/serial/ftdi_sio.ko /home/pi/.
sudo depmod -a



25. noVNC

cd /home/pi/www/
git clone https://github.com/kanaka/noVNC.git

Xvfb :1 -screen 0 800x600x16 -ac &
x11vnc -rfbport 5566 -forever -display :1 &
*******************************************
DISPLAY=:1 skychart --unique &
**************** OR ***********************
DISPLAY=:1 /home/pi/lin_guider_pack/lin_guider/./lin_guider -geometry 800x600+0+0 &
*******************************************

/home/pi/www/noVNC/utils/./launch.sh --vnc localhost:5566 --listen 5666 &

http://192.168.1.18/noVNC/vnc.html?autoconnect=true&host=192.168.1.18&port=5666



26. Kernel modules

apt-get install ncurses-dev
sudo wget https://raw.githubusercontent.com/notro/rpi-source/master/rpi-source -O /usr/bin/rpi-source && sudo chmod +x /usr/bin/rpi-source && /usr/bin/rpi-source -q --tag-update

sudo modprobe configs
rpi-source

********* To compile fliusb.ko **************
cd /home/pi/indi/3rdparty/fliusb/
make
sudo cp /home/pi/indi/3rdparty/fliusb/fliusb.ko /lib/modules/$(uname -r)/kernel/drivers
sudo depmod
*********************************************

********** To make mobules ******************
make menuconfig
make modules
*********************************************








A1. Robomask (Yocto-servo and DFrobot DSS-M15 180deg servo motor)
REFERENCE:
https://www.yoctopuce.com/EN/products/usb-actuators/yocto-servo
http://www.dfrobot.com/index.php?route=product/product&product_id=120#.VzadFfl97IU


cd /home/pi/www/
./VirtualHub
******************************
http://10.0.0.1:4444
Assign Logical name: robomask
******************************

root@iAstroHub:~# /home/pi/www/./YServo -s robomask.servo1 set_positionAtPowerOn -1000
OK: robomask.servo1.set_positionAtPowerOn = -1000.
OK: robomask.robomask.saveToFlash executed.

root@iAstroHub:~# /home/pi/www/./YServo -s robomask.servo1 set_range 200
OK: robomask.servo1.set_range = 200.
OK: robomask.robomask.saveToFlash executed.

***** Close ***** 
root@iAstroHub:~# /home/pi/www/./YServo robomask.servo1 move 1000 5000
OK: robomask.servo1.move = 1000 5000.

***** Open ***** 
root@iAstroHub:~# /home/pi/www/./YServo robomask.servo1 move -1000 5000
OK: robomask.servo1.move = -1000 5000.



A2. libftdi for Flip-Flat and other devices
REFERENCE: http://www.intra2net.com/en/developer/libftdi/index.php

sudo apt-get install cmake
wget http://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.1.tar.bz2
tar xvf libftdi1-1.1.tar.bz2
cd libftdi1-1.1
mkdir build
cd build
cmake  -DCMAKE_INSTALL_PREFIX="/usr" ../
make
sudo make install

gcc open.c -o open -lftdi



A3. Preparation

1) delete images in /home/pi/www/images/ and /home/pi/www/tmp_images/ 
2) delete guiding and alert logs 
3) set Null and uncheck debug in Linguider 
```

