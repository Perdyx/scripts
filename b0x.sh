#!/bin/bash

# Author: Perdyx
# Description: Sets up a customized Kali box in WSL2

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
echo -e "\nv2.0.0 - https://github.com/Perdyx/scripts/blob/master/b0x.sh\n"

apt update -y
apt full-upgrade -y

apt install -y vim vim-airline htop neofetch nmap metasploit-framework build-essential gcc binutils radare2 gcc-multilib file

apt install -y python3-pip
git clone https://github.com/SusmithKrishnan/torghost.git $HOME/torghost
cd $HOME/torghost
chmod +x build.sh
sh build.sh
cd
rm -rf $HOME/torghost

apt install -y gdb
git clone https://github.com/longld/peda.git ~/peda
echo "source ~/peda/peda.py" >> ~/.gdbinit

apt install python3 python3-pip
pip install pwntools

echo -e "\n\n💀💀💀 Done. Don't forget your configs! 💀💀💀"
