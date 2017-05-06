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

* From the iAstroHub root directory, run `./make`

### Releasing

To release a new version of iAstroHub to the AstroSwarm container registry, use:

```
git pull
./make
docker login
docker tag iastrohub astroswarm/iastrohub:latest
docker push astroswarm/iastrohub:latest
```

## Running the container

* You must run the container with the `--cap-add=ALL` option and with the `--privileged` flag.
* You must mount kernel modules via `-v /lib/modules:/lib/modules:ro`

The recommended `docker run` syntax is:

```
docker run \
  -p 0.0.0.0:80:80 \
  -p 0.0.0.0:5551:5551 \
  -p 0.0.0.0:5552:5552 \
  -p 0.0.0.0:5553:5553 \
  -p 0.0.0.0:7624:7624 \
  -p 0.0.0.0:8624:8624 \
  -p 0.0.0.0:8888:8888 \
  --cap-add ALL \
  --privileged \
  -v /lib/modules:/lib/modules:ro \
  iastrohub
```

If you are developing or testing iAstroHub, you may want to use the following additional flags:

```
--rm \ # Delete the container after it exits
-it \ # Keep an interactive session; you can use ctrl+c to exit
```

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

* The FTDI module is copied to /home/pi, but ftdi_load.php and ftdi_unload.php will error if the kernel versions do not match up. My advice is to ensure FTDI is stable and always keep it loaded at the host level.
* fliusb kernel module is not built in the container. If needed, this should live on the host.
* /etc/hosts IP address for iAstroHub host is 127.0.0.1, instead of 127.0.1.1.
* Skychart upgraded to version 4.
* Used an x64 compatible fix for chipset detection in sbig module for OpenSkyImager. It is the same one used in this pull request: https://github.com/OpenSkyProject/OpenSkyImager/pull/16/files
* GoQat upgraded from 2.0.0 to 2.1.1; includes native support for INDI removeDevice.
* indi_simple_html_cherrypy_server binds to 0.0.0.0 instead of 10.0.0.1, so it is not dependent on a specific network-available IP address
* max_usb_current no longer set; has no effect on Raspberry Pi 3, which provides 1.2A by default. See: https://www.raspberrypi.org/forums/viewtopic.php?p=930695#p930695
* User no longer expected to change password or grant root login access; those are responsibilities of a host, not a docker image.
* Wifi instructions and procedure removed; setup is assumed to be handled by the host. 
* Remove instructions to expand file system; assumed to be handled by host.

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
