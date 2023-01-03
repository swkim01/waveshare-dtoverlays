## WaveShare SpotPear 3.2" and 3.5/4.0" LCD Device Tree Overlays for the Raspberry PI
This is Device Tree Overlays of [WaveShare SpotPear 3.2" TFT LCD](http://www.waveshare.com/product/modules/oleds-lcds/3.2inch-rpi-lcd-b.htm) and [WaveShare SpotPear 3.5" TFT LCD](http://www.waveshare.com/product/modules/oleds-lcds/3.5inch-rpi-lcd-a.htm) for the Raspberry PI and PI 2 using [notro](https://github.com/notro)'s FBTFT driver.

Note that the waveshare 3.5/4.0" lcd's overlay is almost same with [JBTek overlay](https://github.com/acidjazz/jbtekoverlay).

### Requirements

- GNU Coreutils
- GNU Make
- dvc (device tree compiler)

### Installation

*_Update:_* The fbtft drivers have been absorbed into the official linux kernel tree. Step 1 can be skipped.

1.) Follow the steps on [notro's wiki](https://github.com/notro/fbtft/wiki#install) for installing the fbtft driver on your pi/pi2 (Your PI will not boot with the LCD attached until the right overlay is specified in /boot/config.txt)

2.) Clone my repo onto your pi
```shell
git clone https://github.com/swkim01/waveshare-dtoverlays.git
cd waveshare-dtoverlays
```

3.) Compile the device tree overlay binary objects:
```shell
make
```

4.) Install the device tree overlay binary files to /boot/overlays using:
```shell
sudo make install
```

Or, if you are using a Linux kernel older than version 4.4, install
the correct file manually, according to your LCD type:

In case of waveshare 3.2" LCD
```shell
sudo cp waveshare32b.dtbo /boot/overlays/waveshare32b-overlay.dtb
```
In case of waveshare 3.5/4" LCD
```shell
sudo cp waveshare35a.dtbo /boot/overlays/waveshare35a-overlay.dtb
```

5.) Specify this overlay file in your `/boot/config.txt`
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

6.) Reboot your raspberry pi


7.) In case of using X windows on raspbian buster, you have to create
a fbdev conf file. Create /usr/share/X11/xorg.conf.d/99-fbdev.conf.
```
Section "Device"
        Identifier "touchscreen"
        Driver "fbdev"
        Option "fbdev" "/dev/fb1"
EndSection
```

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
- To calibrate in detail, you can build a modified source of [xinput-calibrator](https://github.com/kreijack/xinput_calibrator/tree/libinput)
```
$ sudo apt-get install git build-essential libx11-dev libxext-dev libxi-dev x11proto-input-dev
$ git clone https://github.com/kreijack/xinput_calibrator -b libinput
$ cd xinput_calibrator
$ ./autogen.sh
$ ./configure
$ make
$ sudo make install
```
Configure xinput_calibrator to autostart with X windows.
```
$ sudo cp -a scripts/xinput_calibrator_pointercal.sh /etc/X11/Xsession.d
$ echo "sudo /bin/sh /etc/X11/Xsession.d/xinput_calibrator_pointercal.sh" | sudo tee -a /etc/xdg/lxsession/LXDE-pi/autostart
```
On first start of X windows a calibration window will be displayed.
```
startx
```
After calibration, the calibration file `/etc/pointercal.xinput` will be createdautomatically. 
Or instead you can create `/usr/share/X11/xorg.conf.d/99-calibration.conf` by executing `xinput_calibrator` or copy from `/etc/pointercal.xinput`.
```
Section "InputClass"
        Identifier "calibration"
        MatchProduct "ADS7846 Touchscreen"
        Option "TransformationMatrix" "0.016152 -1.137751 1.062519 1.126908 -0.005470 -0.064818 0.0 0.0 1.0"
EndSection
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
- Calibrate touchscreen as to [FBTFT wiki](https://github.com/notro/fbtft/wiki/FBTFT-on-Raspian) and/or make /usr/share/X11/xorg.conf.d/99-calibration.conf.

