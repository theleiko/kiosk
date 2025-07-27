# kiosk
 
## 1. Install Debian with LXDE (!) & SSH
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