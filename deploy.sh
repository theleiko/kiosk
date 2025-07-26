#!/usr/bin/env bash
set -x
set -e

cp -r filesystem/opt /
cp -r filesystem/boot /
cp -r filesystem/etc /

apt-get update

apt-get install -y fbi
systemctl enable splashscreen.service
systemctl disable getty@tty1

pcmanfm --set-wallpaper="/opt/custompios/background.png"


apt-get remove -y --purge  scratch squeak-plugins-scratch squeak-vm libreoffice-common libreoffice-core freepats

apt-get autoremove -y

#apt-get tools
apt-get -y install git screen checkinstall avahi-daemon libavahi-compat-libdnssd1 xterm xdotool vim expect feh pulseaudio chromium x11vnc unclutter-xfixes mc htop

sed -i 's@%BROWSER_START_SCRIPT%@/opt/custompios/scripts/start_chromium_browser@g' /opt/custompios/scripts/run_onepageos

mkdir -p /opt/custompios/vnc
chown kiosk:kiosk /opt/custompios/vnc

echo "Please provide vnc password:"
read line

sudo -u kiosk /opt/custompios/scripts/setX11vncPass $line
sync

systemctl enable x11vnc.service

apt-get clean
apt-get autoremove -y

sed -i 's/#type=local/autologin-user=kiosk\nautologin-user-timeout=0\n#type=local/g' /etc/lightdm/lightdm.conf 

echo 'export DISPLAY=:0.0' >> /home/kiosk/.profile