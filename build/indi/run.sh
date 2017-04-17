#!/bin/bash

source build/common.sh

patch_file() {
  patch -b -i /build/indi/patches/$1.patch $1
}

apt-get -y install \
  build-essential \
  cmake \
  dcraw \
  git \
  libboost-regex-dev \
  libcfitsio3-dev \
  libcurl4-gnutls-dev \
  libgps-dev \
  libgsl0-dev \
  libindi-dev \
  libjpeg-dev \
  libnova-dev \
  libraw-dev \
  libusb-1.0-0-dev \
  python-cherrypy3 \
  python-dev \
  python-pip \
  subversion \
  swig2.0 \
  zlib1g-dev

mkdir -p /home/pi
git clone https://github.com/indilib/indi.git /home/pi/indi
cd /home/pi/indi
git reset --hard 2e4a73a030422f801d0396f79cff5014d783e5ce
patch_file /home/pi/indi/libindi/drivers/agent/agent_imager.cpp
patch_file /home/pi/indi/3rdparty/indi-qsi/qsi_ccd.cpp
mkdir -p /home/pi/indi/build/libindi
cd /home/pi/indi/build/libindi
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug ../../libindi
make
make install

cp /home/pi/indi/3rdparty/libsbig/sbigudrv.h /usr/include/

mkdir -p /home/pi/indi/build/3rdparty
cd /home/pi/indi/build/3rdparty
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug ../../3rdparty
make
make install

cd /home/pi/indi/3rdparty/indi-mi
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug ../../3rdparty
make
make install

if [ "$CPU" == "arm" ] ; then
  wget http://download.cloudmakers.eu/atikccd-1.22-armhf.deb
  dpkg -i --force-all atikccd-1.22-armhf.deb
  wget http://download.cloudmakers.eu/atikccdsdk-1.22-armhf.deb
  dpkg -i --force-all atikccdsdk-1.22-armhf.deb
elif [ "$CPU" == "x86_64" ] ; then
  wget http://download.cloudmakers.eu/atikccd-1.22-amd64.deb
  dpkg -i --force-all atikccd-1.22-amd64.deb
  wget http://download.cloudmakers.eu/atikccdsdk-1.22-amd64.deb
  dpkg -i --force-all atikccdsdk-1.22-amd64.deb
else
  exit 1
fi

cd /home/pi/indi/3rdparty/libqhy
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug ../../3rdparty
make
make install

cd /home/pi/indi/3rdparty/indi-qhy
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug ../../3rdparty
make
make install

pip install psutil
pip install bottle
git clone https://github.com/knro/indiwebmanager.git /home/pi/indi/indiwebmanager
cd /home/pi/indi/indiwebmanager
git reset --hard 62fbace889e07bf70d401b09ab0ec21bca247d91
patch_file /home/pi/indi/indiwebmanager/servermanager/views/form.tpl
cd /home/pi/indi/indiwebmanager/servermanager/views/css/
curl -O http://bootswatch.com/cyborg/bootstrap.css
curl -O http://bootswatch.com/cyborg/bootstrap.min.css

cd /home/pi/indi/
svn co -r 36 svn://svn.code.sf.net/p/pyindi-client/code/trunk/swig-indi/swig-indi-python/
mkdir libindipython
cd libindipython
cmake ../swig-indi-python
make
make install

mkdir -p /home/pi/indi/ws4py
chown root:root /home/pi/indi/ws4py
git clone --depth 1 https://github.com/Lawouach/WebSocket-for-Python.git /home/pi/indi/ws4py/WebSocket-for-Python
cd /home/pi/indi/ws4py/WebSocket-for-Python
python setup.py install

cd /home/pi/indi/
svn co -r 42 svn://svn.code.sf.net/p/pyindi-client/code/trunk/pyindi-ws
patch_file /home/pi/indi/pyindi-ws/static/index_simple_html.html
patch_file /home/pi/indi/pyindi-ws/static/indi_simple_html.html
patch_file /home/pi/indi/pyindi-ws/static/js/indi_simple_html.js

echo "#!/bin/sh" > /home/pi/indi/pyindi-ws.sh
echo "while true" >> /home/pi/indi/pyindi-ws.sh
echo "do" >> /home/pi/indi/pyindi-ws.sh
echo "if ! pgrep -f "indi_simple_html_cherrypy_server" > /dev/null" >> /home/pi/indi/pyindi-ws.sh
echo "then" >> /home/pi/indi/pyindi-ws.sh
echo "    echo '************ Restarting ************'" >> /home/pi/indi/pyindi-ws.sh
echo "cd /home/pi/indi/pyindi-ws/" >> /home/pi/indi/pyindi-ws.sh
echo "python indi_simple_html_cherrypy_server.py --host 0.0.0.0 --port 8888 &" >> /home/pi/indi/pyindi-ws.sh
echo "fi" >> /home/pi/indi/pyindi-ws.sh
echo "sleep 4" >> /home/pi/indi/pyindi-ws.sh
echo "done" >> /home/pi/indi/pyindi-ws.sh
chmod +x /home/pi/indi/pyindi-ws.sh
