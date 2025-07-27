#!/usr/bin/env bash

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
WHITE="\e[97m"
RED_BG="\e[41m"
GREEN_BG="\e[42m"
BLUE_BG="\e[44m"
WHITE_BG="\e[107m"
ENDCOLOR="\e[0m"


if [[ $EUID -ne 0 ]]; then
   echo "${RED_BG}${WHITE}This script must be run as root${ENDCOLOR}" 
   exit 1
fi

echo "${BLUE}Please provide vnc password:${ENDCOLOR}"
read vnc_password

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

apt-get remove -y --purge  scratch squeak-plugins-scratch squeak-vm libreoffice-common libreoffice-core freepats

apt-get autoremove -y

#apt-get tools
apt-get -y install git screen checkinstall avahi-daemon libavahi-compat-libdnssd1 xterm xdotool vim expect feh pulseaudio chromium x11vnc unclutter-xfixes mc htop

mkdir -p /opt/kiosk/vnc
chown ${USER}:${USER} /opt/kiosk/vnc

sudo -u ${USER} /opt/kiosk/scripts/setX11vncPass $vnc_password
sync

systemctl enable x11vnc.service

apt-get clean
apt-get autoremove -y

sed -i "s/#type=local/autologin-user=${USER}\nautologin-user-timeout=0\n#type=local/g" /etc/lightdm/lightdm.conf 

sed -i "s/kiosk/${USER}/g" /etc/sudoers.d/kiosk

sed -i '/wallpaper=/d' /home/${USER}/.config/pcmanfm/LXDE/desktop-items-0.conf
echo 'wallpaper=/opt/kiosk/background.png' >> /home/${USER}/.config/pcmanfm/LXDE/desktop-items-0.conf

echo 'export DISPLAY=:0.0' >> /home/${USER}/.profile
echo '/opt/kiosk/scripts/start_chromium_browser' >> /home/${USER}/.config/lxsession/LXDE/autostart

sed -i '/GRUB_TIMEOUT=/d' /etc/default/grub
echo 'GRUB_TIMEOUT=1' >> /etc/default/grub
update-grub

echo "${GREEN_BG}Everything done, rebooting in 10 seconds...${ENDCOLOR}"

sleep 10
sudo reboot now