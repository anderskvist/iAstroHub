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
* Astrometry compiled with updated gcc 4.9 suite rather than 4.4 suite.
* Used an x64 compatible fix for chipset detection in sbig module for OpenSkyImager. It is the same one used in this pull request: https://github.com/OpenSkyProject/OpenSkyImager/pull/16/files 
 
## Workflow Changes

### Patches

Files that previously lived in "modified_codes", as well as config file changes, are now persisted as patches. This way they remain compatible with other minor changes to the same set of files.

The patch files live in a top level "patches" directory, whose structure mirrors the patch file locations in the container image.

Patches are created via `diff -u <old file version> <new file version> > <original filename>.patch`. When patches are applied, the original file is renamed to <original filename>.orig so that it is available for post hoc inspection. If you need to make further changes to these files, make them in the container, and then recreate the patch by running `diff -u <filename> <filename.orig> > <filename>.patch`.

You can then copy your latest patch into this git repository by running: `docker cp <container hash>:<filepath>.patch patches<filepath>.patch`.

## Status

Below is everything in the original README that has not yet been ported to Docker. As features are ported over, they are removed from the text below.

```

1. install Raspbian (2016-05-27-raspbian-jessie-lite)

Edit /boot/config.txt
******** ADD ***********
max_usb_current=1


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



6. CPU and Temp

time echo "scale=2000; a(1)*4" | bc -l
******************** RPi3 ****************
real    0m7.877s
user    0m7.870s
sys     0m0.000s


******************** RPi2 ****************
real    0m15.194s
user    0m15.180s
sys     0m0.000s


sudo apt-get install cpufrequtils

********************************************************
pi@raspberrypi:~ $ cpufreq-info
cpufrequtils 008: cpufreq-info (C) Dominik Brodowski 2004-2009
Report errors and bugs to cpufreq@vger.kernel.org, please.
analyzing CPU 0:
  driver: BCM2835 CPUFreq
  CPUs which run at the same hardware frequency: 0 1 2 3
  CPUs which need to have their frequency coordinated by software: 0 1 2 3
  maximum transition latency: 355 us.
  hardware limits: 600 MHz - 1.20 GHz
  available frequency steps: 600 MHz, 1.20 GHz
  available cpufreq governors: conservative, ondemand, userspace, powersave, performance
  current policy: frequency should be within 600 MHz and 1.20 GHz.
                  The governor "ondemand" may decide which speed to use
                  within this range.
  current CPU frequency is 1.20 GHz.
  cpufreq stats: 600 MHz:53.18%, 1.20 GHz:46.82%  (10)
analyzing CPU 1:
  driver: BCM2835 CPUFreq
  CPUs which run at the same hardware frequency: 0 1 2 3
  CPUs which need to have their frequency coordinated by software: 0 1 2 3
  maximum transition latency: 355 us.
  hardware limits: 600 MHz - 1.20 GHz
  available frequency steps: 600 MHz, 1.20 GHz
  available cpufreq governors: conservative, ondemand, userspace, powersave, performance
  current policy: frequency should be within 600 MHz and 1.20 GHz.
                  The governor "ondemand" may decide which speed to use
                  within this range.
  current CPU frequency is 1.20 GHz.
  cpufreq stats: 600 MHz:53.18%, 1.20 GHz:46.82%  (10)
analyzing CPU 2:
  driver: BCM2835 CPUFreq
  CPUs which run at the same hardware frequency: 0 1 2 3
  CPUs which need to have their frequency coordinated by software: 0 1 2 3
  maximum transition latency: 355 us.
  hardware limits: 600 MHz - 1.20 GHz
  available frequency steps: 600 MHz, 1.20 GHz
  available cpufreq governors: conservative, ondemand, userspace, powersave, performance
  current policy: frequency should be within 600 MHz and 1.20 GHz.
                  The governor "ondemand" may decide which speed to use
                  within this range.
  current CPU frequency is 1.20 GHz.
  cpufreq stats: 600 MHz:53.18%, 1.20 GHz:46.82%  (10)
analyzing CPU 3:
  driver: BCM2835 CPUFreq
  CPUs which run at the same hardware frequency: 0 1 2 3
  CPUs which need to have their frequency coordinated by software: 0 1 2 3
  maximum transition latency: 355 us.
  hardware limits: 600 MHz - 1.20 GHz
  available frequency steps: 600 MHz, 1.20 GHz
  available cpufreq governors: conservative, ondemand, userspace, powersave, performance
  current policy: frequency should be within 600 MHz and 1.20 GHz.
                  The governor "ondemand" may decide which speed to use
                  within this range.
  current CPU frequency is 1.20 GHz.
  cpufreq stats: 600 MHz:53.18%, 1.20 GHz:46.82%  (10)
pi@raspberrypi:~ $ 
********************************************************

root@raspberrypi:/home/pi# vcgencmd measure_temp
temp=47.2'C

root@raspberrypi:/home/pi# cat /sys/class/thermal/thermal_zone0/temp
47236



17. FTDI modules

mv /lib/modules/4.4.13-v7+/kernel/drivers/usb/serial/ftdi_sio.ko /home/pi/.
sudo depmod -a



21. GoQat

sudo apt-get install libgtk-3-0 libgtk-3-dev grace

cd /home/pi/
wget https://launchpad.net/ubuntu/+archive/primary/+files/goocanvas-2.0_2.0.2.orig.tar.xz
tar xvf goocanvas-2.0_2.0.2.orig.tar.xz
cd goocanvas-2.0.2/
./configure
sudo make
sudo make install
sudo ldconfig


################## EDIT GOQAT 2.1.0 ##################

nano /home/pi/goqat-2.1.0/src/indi_client.cpp
************************************
    virtual void serverConnected ();
    virtual void serverDisconnected (int exit_code);
    virtual void newDevice (INDI::BaseDevice *dp);
    virtual void removeDevice (INDI::BaseDevice *dp);
    virtual void newProperty (INDI::Property *property);
    virtual void removeProperty (INDI::Property *property);
	

************************************	
void INDIClient::newDevice (INDI::BaseDevice *dp)
{
	/* Add a new device */
	
    client->setBLOBMode (B_ALSO, dp->getDeviceName(), NULL);
    indi_new_device (dp->getDeviceName ());
}

void INDIClient::removeDevice (INDI::BaseDevice *dp)
{
	/* Remove a device */
}

void INDIClient::newProperty (INDI::Property *property)
{	


nano /home/pi/goqat-2.1.0/src/qsi.c
************************************
int qsi_get_state (struct ccd_state *state, int AllSettings, ...)
{
...
				default:
					strcpy (state->status, "Unknown ");
					break;
			}
		} else
			return TRUE;  //********** Was 'return FALSE'
...
		
get_error:
	pthread_mutex_unlock (&get_mutex);
	return TRUE;  //********** Was 'return FALSE'
}


nano /home/pi/goqat-2.1.0/src/interface.c
************************************
void on_txtCCDExposure_activate (GtkEditable *editable, gpointer data)
{
	/* Start the exposure if the user presses the Return key in the
	 * Exposure field.
	 */
	
	// gtk_widget_activate (xml_get_widget (xml_app, "btnCCDStart"));
}


************************************
void set_fits_data (struct cam_img *img, gboolean UseDateobs, 
                    enum CamType camtype, gboolean QueryHardware)
{
...

	if (QueryHardware) {
	
		/* Get RA and Dec from telescope controller.  This routine prints a
		 * warning and sets the values to zero if the link is not open.
		 */
/*		
		telescope_get_RA_Dec (menu.Precess, &img->fits.epoch, 
						      img->fits.RA, img->fits.Dec, 
							  &ignore1, &ignore2, &ignore3, &ignore4);
*/		
		/* No need to warn if focuser not open/available.  Just set values
		 * silently to zero.
		 */

		if (focus_comms->user & PU_FOCUS) {
			f.cmd = FC_VERSION;
			focus_comms->focus (&f);
			if (f.version >= 3.0)
				f.cmd = FC_CUR_POS_GET | FC_TEMP_GET;
			else
				f.cmd = FC_CUR_POS_GET;
			focus_comms->focus (&f);
			if (!f.Error) {
				img->fits.focus_pos = f.cur_pos;
				if (f.version >= 3.0)
					img->fits.focus_temp = f.temp;
			    else
					img->fits.focus_temp = 0.0;
			}
		} else {
			img->fits.focus_pos = 0;
			img->fits.focus_temp = 0.0;
		}
	} else {
	//	sprintf (img->fits.RA, "00:00:00");
	//	sprintf (img->fits.Dec, "+00:00:00");
		img->fits.focus_pos = 0;
		img->fits.focus_temp = 0.0;
	}

}


************************************
void check_focuser_temp (void)
{
	/* Query the focuser temperature and display on Focus tab.  Make focus
	 * adjustments if the user has requested it.
	 */

	FILE * pFile;
...


		pFile = fopen ("/home/pi/www/FC_CUR_POS.txt","w");
		fprintf (pFile, "%d\n", f.cur_pos);
		fclose(pFile);
		
		pFile = fopen ("/home/pi/www/FC_TEMP.txt","w");
		fprintf (pFile, "%.1f\n", f.temp);
		fclose(pFile);
		
	} else
		L_print ("{r}Error reading focuser temperature\n");
}

################################################

cd /home/pi/goqat-2.1.0/
./configure
sudo make
sudo make install











22. TTS

sudo amixer set PCM -- 400


22.1 Install Festival 

sudo apt-get install festival

echo  "good morning"| festival --tts

echo  "good morning" > speak
festival --tts speak


22.2 Voice file

cd /home/pi/
mkdir hts_tmp
cd hts_tmp/
wget -c http://hts.sp.nitech.ac.jp/archives/2.1/festvox_nitech_us_bdl_arctic_hts-2.1.tar.bz2
tar xvf festvox_nitech_us_bdl_arctic_hts-2.1.tar.bz2

sudo mkdir -p /usr/share/festival/voices/us
sudo mv lib/voices/us/* /usr/share/festival/voices/us/
sudo mv lib/hts.scm /usr/share/festival/hts.scm

nano /usr/share/festival/voices/us/nitech_us_bdl_arctic_hts/festvox/nitech_us_bdl_arctic_hts.scm
*******************************************
(require 'hts)
(require_module 'hts_engine)
change to
(require 'hts21compat)
(require_module 'hts21_engine)
*******************************************
(Parameter.set 'Synth_Method 'HTS)
change to
(Parameter.set 'Synth_Method 'HTS21)
*******************************************



23. nano /etc/rc.local
*******************************************************************************
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

# Print the IP address
#_IP=$(hostname -I) || true
#if [ "$_IP" ]; then
#  printf "My IP address is %s\n" "$_IP"
#fi

sudo echo "0 " > /home/pi/www/hist_L.txt
sudo echo "65535 " > /home/pi/www/hist_U.txt
sudo echo " " > /home/pi/www/image.txt
sudo echo " " > /home/pi/www/photo.txt

file="/home/pi/www/status_app"
if [ -f "$file" ]; then
sudo rm /home/pi/www/status_app
fi

file="/home/pi/www/status_connect"
if [ -f "$file" ]; then
sudo rm /home/pi/www/status_connect
fi

file="/home/pi/www/status_skychart"
if [ -f "$file" ]; then
sudo rm /home/pi/www/status_skychart
fi

file="/home/pi/www/status_guiding"
if [ -f "$file" ]; then
sudo rm /home/pi/www/status_guiding
fi

file="/home/pi/www/status_capture"
if [ -f "$file" ]; then
sudo rm /home/pi/www/status_capture
fi

file="/home/pi/www/status_ccd"
if [ -f "$file" ]; then
sudo rm /home/pi/www/status_ccd
fi

file="/home/pi/www/status_focus"
if [ -f "$file" ]; then
sudo rm /home/pi/www/status_focus
fi

file="/home/pi/www/status_dslr"
if [ -f "$file" ]; then
sudo rm /home/pi/www/status_dslr
fi

file="/home/pi/www/status_loading"
if [ -f "$file" ]; then
sudo rm /home/pi/www/status_loading
fi

file="/home/pi/www/status_processing"
if [ -f "$file" ]; then
sudo rm /home/pi/www/status_processing
fi

file="/home/pi/www/prepare_ccd"
if [ -f "$file" ]; then
sudo rm /home/pi/www/prepare_ccd
fi

sudo /home/pi/www/./sound > /dev/null 2>&1 &

sudo /home/pi/www/./monitor_camera > /dev/null 2>&1 &

sudo /home/pi/www/./monitor_pty > /dev/null 2>&1 &

perl /home/pi/www/event_monitor4.pl &

Xvfb :1 -screen 0 800x600x16 -ac &
Xvfb :2 -screen 0 800x600x16 -ac &
Xvfb :3 -screen 0 960x720x16 -ac &

# Setup Wifi AP mode
sudo ifconfig wlan0 down
sudo ifconfig wlan0 10.0.0.1 netmask 255.255.255.0 up
sudo iwconfig wlan0 power off
sudo service dnsmasq restart
sudo hostapd -B /etc/hostapd/ap.conf & > /dev/null 2>&1

# Pushover notification
file1="/home/pi/www/notify_imaging"
file2="/home/pi/www/notify_guiding"
if [ -f "$file1" ] || [ -f "$file2" ]; then
perl /home/pi/www/notify_IP.pl
fi

exit 0



24. INDI

24.1 INDI server (Compiled from source codes)
REFERENCE: https://github.com/indilib/indi

sudo apt-get install libgps-dev dcraw libnova-dev libcfitsio3-dev libusb-1.0-0-dev zlib1g-dev libgsl0-dev build-essential cmake git libjpeg-dev libcurl4-gnutls-dev libboost-regex-dev

cd /home/pi/
git clone https://github.com/indilib/indi.git
cd indi


nano /home/pi/indi/libindi/drivers/agent/agent_imager.cpp
***************************************************
IUFillText(&ImageNameT[0], "IMAGE_FOLDER", "Image folder", "/home/pi/www/images");
IUFillText(&ImageNameT[1], "IMAGE_PREFIX", "Image prefix", "IMG");
***************************************************


mkdir -p build/libindi
cd build/libindi
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug ../../libindi
make
sudo make install


nano /home/pi/indi/3rdparty/indi-qsi/qsi_ccd.cpp
*******************************************
    IUFillSwitch(&GainS[0], "High", "High", ISS_OFF);
    IUFillSwitch(&GainS[1], "Low", "Low", ISS_OFF);
    IUFillSwitch(&GainS[2], "Auto", "Auto", ISS_ON);
    IUFillSwitchVector(&GainSP, GainS, 3, getDeviceName(), "Gain", "Gain", OPTIONS_TAB, IP_RW, ISR_1OFMANY, 60, IPS_IDLE);

    IUFillSwitch(&FanS[0], "Off", "Off", ISS_OFF);
    IUFillSwitch(&FanS[1], "Quiet", "Quiet", ISS_OFF);
    IUFillSwitch(&FanS[2], "Full", "Full", ISS_ON);
    IUFillSwitchVector(&FanSP, FanS, 3, getDeviceName(), "Fan", "Fan", MAIN_CONTROL_TAB, IP_RW, ISR_1OFMANY, 60, IPS_IDLE);

    IUFillSwitch(&ABS[0], "Normal", "Normal", ISS_ON);
    IUFillSwitch(&ABS[1], "High", "High", ISS_OFF);
    IUFillSwitchVector(&ABSP, ABS, 2, getDeviceName(), "AntiBlooming", "AntiBlooming", OPTIONS_TAB, IP_RW, ISR_1OFMANY, 60, IPS_IDLE);
*******************************************

***************************************************
mv /usr/include/sbigudrv.h /home/pi/.
cp /home/pi/indi/3rdparty/libsbig/sbigudrv.h /usr/include/.
***************************************************

cd /home/pi/indi/build/
mkdir 3rdparty
cd 3rdparty
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug ../../3rdparty
make
sudo make install
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug ../../3rdparty
make
sudo make install


cd /home/pi/indi/3rdparty/indi-mi/
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug
make
sudo make install


cd /home/pi/indi/3rdparty/
wget http://download.cloudmakers.eu/atikccd-1.5-armhf.deb
dpkg -i --force-overwrite atikccd-1.5-armhf.deb
wget http://download.cloudmakers.eu/atikccdsdk-1.5-armhf.deb
dpkg -i --force-overwrite atikccdsdk-1.5-armhf.deb


########################## UNSTABLE (To be installed by users) ################################

cd /home/pi/indi/3rdparty/libqhy/
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug
make
sudo make install

cd /home/pi/indi/3rdparty/indi-qhy/
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug
make
sudo make install

###############################################################################################


24.2 INDI client (web interface)

24.2.1 INDI web manager

sudo apt-get install python-dev python-pip
sudo pip install psutil
sudo pip install bottle

cd /home/pi/indi/
git clone https://github.com/knro/indiwebmanager.git


-------------------------- CHANGE TO DARK THEME ------------------------------
cd /home/pi/indi/indiwebmanager/servermanager/views/css/
curl -O http://bootswatch.com/cyborg/bootstrap.css
curl -O http://bootswatch.com/cyborg/bootstrap.min.css

nano /home/pi/indi/indiwebmanager/servermanager/views/css/bootstrap.css
nano /home/pi/indi/indiwebmanager/servermanager/views/css/bootstrap.min.css
********************************************
Comment the first line to prevent accessing internet
********************************************

nano /home/pi/indi/indiwebmanager/servermanager/views/form.tpl
********************************************
<!--  <link rel="stylesheet" type="text/css" href="/static/css/schoolhouse.css">  -->
********************************************
------------------------------------------------------------------------------


python /home/pi/indi/indiwebmanager/servermanager/drivermanager.py &


24.2.2 pyindi-ws

# install swig-indi-python
apt-get install swig2.0 subversion
cd /home/pi/indi/
svn co -r 36 svn://svn.code.sf.net/p/pyindi-client/code/trunk/swig-indi/swig-indi-python/
mkdir libindipython
cd libindipython
cmake ../swig-indi-python
make
sudo make install

# install cherrypy version 3
sudo apt-get install python-cherrypy3

# install ws4py
sudo mkdir /home/pi/indi/ws4py
chown root.root /home/pi/indi/ws4py
cd /home/pi/indi/ws4py
git clone https://github.com/Lawouach/WebSocket-for-Python.git
cd /home/pi/indi/ws4py/WebSocket-for-Python
python setup.py install

# install and run the websocket server
cd /home/pi/indi/
svn co svn://svn.code.sf.net/p/pyindi-client/code/trunk/pyindi-ws
cd /home/pi/indi/pyindi-ws/
python indi_simple_html_cherrypy_server.py --host 10.0.0.1 --port 8888


nano /home/pi/indi/pyindi-ws/static/index_simple_html.html
*********************************************************************
<html>
<title>INDI Control Panel</title>
    <head>

<body bgcolor="#000000" TEXT="#FF0000" LINK="#FF0000" VLINK="#FF0000">

<textarea id='message' rows='10' style="width:100%; background-color:#000000; color:#FF0000"></textarea>
*********************************************************************


nano /home/pi/indi/pyindi-ws/static/indi_simple_html.html
*********************************************************************
          <!--<form action='#' id='serverform' method='get'>-->
<!--      <fieldset> -->
        <!--    <legend></legend>
            <label for='server'>Server: </label><input type='text' id='server' size='15' list='knownindiservers'/>
            <label for='port'>Port: </label><input type='number' id='port' max='65535' size='5' list='knownindiports'/> -->
            <input style="visibility:hidden;" id='connect' type='button' value='Connect' />
<!--      </fieldset> -->
          <!--</form>-->
*********************************************************************


nano /home/pi/indi/pyindi-ws/static/js/indi_simple_html.js
*********************************************************************
	before.parent().on('click', '#connect', {context: this}, function(evt) { 
	    var server = "localhost";
	    var port =  "7624";
*********************************************************************


nano /home/pi/indi/pyindi-ws/static/js/indi_simple_html.js
*********************************************************************
            if (jsonmsg.type == 'setKey') {
                this.key = jsonmsg.data;
                result = 'MANAGER: Setting key to ' + this.key;

                $('#connect').trigger("click");  // ADDED
*********************************************************************


nano /home/pi/indi/pyindi-ws.sh
*********************************************************************
while true
do
if ! pgrep -f "indi_simple_html_cherrypy_server" > /dev/null
then
    echo "************ Restarting ************"
	cd /home/pi/indi/pyindi-ws/
	python indi_simple_html_cherrypy_server.py --host 10.0.0.1 --port 8888 &
fi
sleep 4
done
*********************************************************************


sh /home/pi/indi/pyindi-ws.sh &



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

