#!/bin/bash

# Author: per
# Description: Installs a few extra tools to Kali

if [ $EUID -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

echo "  _      ___       "
echo " | |    / _ \      "
echo " | |__ | | | |_  __"
echo " | '_ \| | | \ \/ /"
echo " | |_) | |_| |>  < "
echo " |_.__/ \___//_/\_\\"
echo -e "\nv1.0.0 - https://github.com/Perdyx/scripts/blob/master/b0x.sh\n"

apt update -y
apt upgrade -y
apt autoremove -y

sudo apt install -y python3-pip
git clone https://github.com/SusmithKrishnan/torghost.git $HOME/torghost
cd $HOME/torghost
chmod +x build.sh
sh build.sh
cd
rm -rf $HOME/torghost

echo -e "\n\n💀💀💀 Done. Don't forget your configs! 💀💀💀"
