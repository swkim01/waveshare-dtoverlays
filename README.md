## WaveShare SpotPear 3.2" and 3.5/4.0" LCD Device Tree Overlays for the Raspberry PI
This is Device Tree Overlays of [WaveShare SpotPear 3.2" TFT LCD](http://www.waveshare.com/product/modules/oleds-lcds/3.2inch-rpi-lcd-b.htm) and [WaveShare SpotPear 3.5" TFT LCD](http://www.waveshare.com/product/modules/oleds-lcds/3.5inch-rpi-lcd-a.htm) for the Raspberry PI and PI 2 using [notro](https://github.com/notro)'s FBTFT driver.

Note that the waveshare 3.5/4.0" lcd's overlay is almost same with [JBTek overlay](https://github.com/acidjazz/jbtekoverlay).

### Installation

*_Update:_* The fbtft drivers have been absorbed into the official linux kernel tree. Step 1 can be skipped.

1.) Follow the steps on [notro's wiki](https://github.com/notro/fbtft/wiki#install) for installing the fbtft driver on your pi/pi2 (Your PI will not boot with the LCD attached until the right overlay is specified in /boot/config.txt)

2.) Clone my repo onto your pi
```shell
git clone https://github.com/swkim01/waveshare-dtoverlays.git
```

3.) According to your LCD's type, copy the overlay file waveshare32b-overlay.dtb or waveshare35b-overlay.dtb to `/boot/overlays` as root

In case of waveshare 3.2" LCD
```shell
sudo cp waveshare-dtoverlays/waveshare32b-overlay.dtb /boot/overlays/
```
or if linux 4.4 kernel or newer,
```shell
sudo cp waveshare-dtoverlays/waveshare32b-overlay.dtb /boot/overlays/waveshare32b.dtbo
```
In case of waveshare 3.5/4" LCD
```shell
sudo cp waveshare-dtoverlays/waveshare35a-overlay.dtb /boot/overlays/
```
or if linux 4.4 kernel or newer,
```shell
sudo cp waveshare-dtoverlays/waveshare35a-overlay.dtb /boot/overlays/waveshare35a.dtbo
```

4.) Specify this overlay file in your `/boot/config.txt`
```ini
dtoverlay=waveshare32b
```
or
```ini
dtoverlay=waveshare35a
```
You can configure some parameters of the lcd module like this:
```ini
dtoverlay=waveshare32b:rotate=270
dtoverlay=waveshare35a:rotate=90,swapxy=1
```

5.) reboot your raspberry pi


After then, you need to calibrate touch position.

### Touch Calibration

Since now x server uses libinput to handle input devices instead of evdev, there are two method to calibrate/coordinate touch screen.

1.) One is to use [coordination transformation matrix](https://wiki.ubuntu.com/X/InputCoordinateTransformation).  You can confirm the transformation matrix property of the input device by following commands.
```
$ xinput list
$ xinput list-props "ADS7846 Touchscreen"
```
This is coordinate transformation matrix that transform from input coordinate(x, y, z) to output coordinate(X, Y, Z).

	⎡ 1 0 0 ⎤
	⎜ 0 1 0 ⎥
	⎣ 0 0 1 ⎦

Thus to convert coordinates, you have to add the following code within the section of touchscreen in /usr/share/X11/xorg.conf.d/99-callibration.conf or 40-libinput.conf.
- in case of rotating left (counterclockwise 90 degree),

		⎡ 0 -1 1 ⎤ 
		⎜ 1  0 0 ⎥ 
		⎣ 0  0 1 ⎦ 
	```
	Option "TransformationMatrix" "0 -1 1 1 0 0 0 0 1"
	```
	or execute the following code.
	```
	xinput set-prop 'ADS7846 Touchscreen' 'Coordinate Transformation Matrix' 0 -1 1 1 0 0 0 0 1
	```
- in case of rotating right (clockwise 90 degree),

		⎡ 0 1 0 ⎤ 
		⎜-1 0 1 ⎥ 
		⎣ 0 0 1 ⎦ 
	```
	Option "TransformationMatrix" "0 1 0 -1 0 1 0 0 1"
	```
	or execute the following code.
	```
	xinput set-prop 'ADS7846 Touchscreen' 'Coordinate Transformation Matrix' 0 1 0 -1 0 1 0 0 1
	```
- in case of inverting rotate (clockwise 180 degree),

		⎡-1  0 1 ⎤ 
		⎜ 0 -1 1 ⎥ 
		⎣ 0  0 1 ⎦ 
	```
	Option "TransformationMatrix" "-1 0 1 0 -1 1 0 0 1"
	```
	or execute the following code.
	```
	xinput set-prop 'ADS7846 Touchscreen' 'Coordinate Transformation Matrix' -1 0 1 0 -1 1 0 0 1
	```
- in case of inverting x,

		⎡-1 0 1 ⎤ 
		⎜ 0 1 1 ⎥ 
		⎣ 0 0 1 ⎦ 
	```
	Option "TransformationMatrix" "-1 0 1 0 1 0 0 0 1"
	```
	or execute the following code.
	```
	xinput set-prop 'ADS7846 Touchscreen' 'Coordinate Transformation Matrix' -1 0 1 0 1 0 0 0 1
	```
- in case of inverting y,

		⎡ 1  0 0 ⎤ 
		⎜ 0 -1 1 ⎥ 
		⎣ 0  0 1 ⎦ 
	```
	Option "TransformationMatrix" "1 0 0 0 -1 1 0 0 1"
	```
	or execute the following code.
	```
	xinput set-prop 'ADS7846 Touchscreen' 'Coordinate Transformation Matrix' 1 0 0 0 -1 1 0 0 1
	```
- in case of swapping x and y,

		⎡ 0 1 0 ⎤ 
		⎜ 1 0 0 ⎥ 
		⎣ 0 0 1 ⎦ 
	```
	Option "TransformationMatrix" "0 1 0 1 0 0 0 0 1"
	```
	or execute the following code.
	```
	xinput set-prop 'ADS7846 Touchscreen' 'Coordinate Transformation Matrix' 0 1 0 1 0 0 0 0 1
	```

2.) The other method is to reuse evdev. The detailed step is as follows.

- Install evdev package.
```
$ sudo apt-get install xserver-xorg-input-evdev
```
- Make sure that /etc/X11/xorg.conf.d is empty.
- Modify /usr/share/X11/xorg.conf.d/40-libinput.conf in the last section change the driver to evdev.
```
Section "InputClass"
        Identifier "libinput touchscreen catchall"
        MatchIsTouchscreen "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection
```
- Calibrate touchscreen as to [FBTFT wiki](https://github.com/notro/fbtft/wiki/FBTFT-on-Raspian) and/or make /usr/share/X11/xorg.conf.d/99-ads7846-cal.conf.
