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

cd
touch $HOME/.hushlogin

apt update -y
apt full-upgrade -y

apt install -y vim vim-airline htop neofetch nmap metasploit-framework build-essential gcc binutils radare2 gcc-multilib file python3 python3-pip

apt install -y zsh
chsh -s $(which zsh)

apt install -y gdb
git clone https://github.com/longld/peda.git $HOME/peda
echo "source ~/peda/peda.py" >> $HOME/.gdbinit

pip install pwntools

echo -e "\n\n💀💀💀 Done. Don't forget your configs! 💀💀💀"
