### WaveShare SpotPear 3.2" and 3.5/4.0" LCD Device Tree Overlays for the Raspberry PI
This is Device Tree Overlays of [WaveShare SpotPear 3.2" TFT LCD](http://www.waveshare.com/product/modules/oleds-lcds/3.2inch-rpi-lcd-b.htm) and [WaveShare SpotPear 3.5" TFT LCD](http://www.waveshare.com/product/modules/oleds-lcds/3.5inch-rpi-lcd-a.htm) for the Raspberry PI and PI 2 using [notro](https://github.com/notro)'s FBTFT driver.

Note that the waveshare 3.5/4.0" lcd's overlay is almost same with [JBTek overlay](https://github.com/acidjazz/jbtekoverlay).

#### Installation
===
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

After then, you have to calibrate touch position as to [FBTFT wiki](https://github.com/notro/fbtft/wiki).
