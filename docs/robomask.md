# Using Robomask (Yocto-servo and DFrobot DSS-M15 180deg servo motor)

## References

* https://www.yoctopuce.com/EN/products/usb-actuators/yocto-servo
* http://www.dfrobot.com/index.php?route=product/product&product_id=120#.VzadFfl97IU

## Getting Started

```
cd /home/pi/www/
./VirtualHub
```

* Visit `http://localhost:4444`
* Assign Logical name: `robomask`

Verify I/O operations:

```
root@iAstroHub:~# /home/pi/www/./YServo -s robomask.servo1 set_positionAtPowerOn -1000
OK: robomask.servo1.set_positionAtPowerOn = -1000.
OK: robomask.robomask.saveToFlash executed.

root@iAstroHub:~# /home/pi/www/./YServo -s robomask.servo1 set_range 200
OK: robomask.servo1.set_range = 200.
OK: robomask.robomask.saveToFlash executed.
```

Close:

```
root@iAstroHub:~# /home/pi/www/./YServo robomask.servo1 move 1000 5000
OK: robomask.servo1.move = 1000 5000.
```

Open:
```
root@iAstroHub:~# /home/pi/www/./YServo robomask.servo1 move -1000 5000
OK: robomask.servo1.move = -1000 5000.
```
