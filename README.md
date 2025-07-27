# kiosk
 
## 1. Install Debian
- 10GB Disk should be sufficient
- don't set a root password
- created user will be used as the main user for kiosk
- Select LXDE as desktop environment
- Install SSH Server

## 2. Clone git repository and deploy
    sudo apt install mc git
    git clone https://github.com/theleiko/kiosk.git
    cd kiosk
    sudo ./deploy.sh

## 3. Set target website
Target website can be set in /boot/firmware/kiosk.txt

    sudo echo 'https://time.is/' > /boot/firmware/kiosk.txt

You can use {hostname} in the link, it will be replaced by the set hostname