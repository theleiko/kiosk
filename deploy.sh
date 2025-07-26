#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

set -x
set -e

USER=$(id -nu 1000)


cp -r filesystem/opt /
cp -r filesystem/boot /
cp -r filesystem/etc /

apt-get update

apt-get install -y fbi
systemctl enable splashscreen.service
systemctl disable getty@tty1

sudo -u ${USER} pcmanfm --set-wallpaper="/opt/custompios/background.png"


apt-get remove -y --purge  scratch squeak-plugins-scratch squeak-vm libreoffice-common libreoffice-core freepats

apt-get autoremove -y

#apt-get tools
apt-get -y install git screen checkinstall avahi-daemon libavahi-compat-libdnssd1 xterm xdotool vim expect feh pulseaudio chromium x11vnc unclutter-xfixes mc htop

sed -i 's@%BROWSER_START_SCRIPT%@/opt/custompios/scripts/start_chromium_browser@g' /opt/custompios/scripts/run_onepageos

mkdir -p /opt/custompios/vnc
chown ${USER}:${USER} /opt/custompios/vnc

echo "Please provide vnc password:"
read line

sudo -u ${USER} /opt/custompios/scripts/setX11vncPass $line
sync

systemctl enable x11vnc.service

apt-get clean
apt-get autoremove -y

sed -i 's/#type=local/autologin-user=${USER}\nautologin-user-timeout=0\n#type=local/g' /etc/lightdm/lightdm.conf 

sed -i 's/kiosk/${USER}/g' /etc/sudoers.d/kiosk 

echo 'export DISPLAY=:0.0' >> /home/${USER}/.profile
echo '/opt/custompios/scripts/start_chromium_browser' >> /home/${USER}/.config/lxsession/LXDE/autostart