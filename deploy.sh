#!/usr/bin/env bash
set -x
set -e

cp -r filesystem/opt /
cp -r filesystem/boot /
cp -r filesystem/home /
cp -r filesystem/etc /

apt-get update

apt-get install -y fbi
systemctl enable splashscreen.service
systemctl disable getty@tty1


apt-get remove -y --purge  scratch squeak-plugins-scratch squeak-vm python-minecraftpi minecraft-pi sonic-pi oracle-java8-jdk bluej greenfoot libreoffice-common libreoffice-core freepats

apt-get autoremove -y

#apt-get tools
apt-get -y install git screen checkinstall avahi-daemon libavahi-compat-libdnssd1 xterm xdotool vim expect feh pulseaudio chromium x11vnc unclutter-xfixes mc htop

sed -i 's@%BROWSER_START_SCRIPT%@/opt/custompios/scripts/start_chromium_browser@g' /opt/custompios/scripts/run_onepageos

mkdir -p /opt/custompios/vnc
chown kiosk:kiosk /opt/custompios/vnc

echo "Please provide vnc password:"
read line

sudo -u pi /opt/custompios/scripts/setX11vncPass $line
sync

systemctl enable x11vnc.service

apt-get clean
apt-get autoremove -y

chromium --app="https://extensions.gnome.org/extension/4099/no-overview/" &