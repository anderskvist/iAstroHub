# Using libftdi for Flip-Flat and other devices

## References

* http://www.intra2net.com/en/developer/libftdi/index.php

## Getting Started

```
apt-get install cmake
wget http://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.1.tar.bz2
tar xvf libftdi1-1.1.tar.bz2
cd libftdi1-1.1
mkdir build
cd build
cmake  -DCMAKE_INSTALL_PREFIX="/usr" ../
make
make install

gcc open.c -o open -lftdi
```
