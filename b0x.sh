#!/bin/bash

# Author: per
# Description: Set up a functional Kali machine for webapp pentesting

echo -e "DISCLAIMER: Due to the nature of some of applications installed with this script, running the entire script as root may have unintended consequences. Certain parts of this script do require root, however, so you will be prompted for your password.\n"

if [ $EUID -eq 0 ]; then
    echo "Root detected. Exiting..."
    exit 1
fi

sudo echo "62 30 78"

echo "  _      ___       "
echo " | |    / _ \      "
echo " | |__ | | | |_  __"
echo " | '_ \| | | \ \/ /"
echo " | |_) | |_| |>  < "
echo " |_.__/ \___//_/\_\\"
echo -e " v1.0.0 - https://github.com/Perdyx/scripts/blob/master/b0x.sh\n\n"

sudo apt update -y

sudo apt install -y amass \
    burpsuite \
    metasploit-framework \
    nmap \
    tmux \
    vim

wget https://dl.google.com/go/go1.13.4.linux-amd64.tar.gz
tar -xvf go1.13.4.linux-amd64.tar.gz
mv go /usr/local
rm go1.13.4.linux-amd64.tar.gz
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
echo 'export GOROOT=/usr/local/go' >> $HOME/.bash_profile
echo 'export GOPATH=$HOME/go'	>> $HOME/.bash_profile
echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> $HOME/.bash_profile
source $HOME/.bash_profile

go get -u github.com/tomnomnom/httprobe

apt install -y python3-pip
git clone https://github.com/SusmithKrishnan/torghost.git
chmod +x torghost/build.sh
cd torghost
./build.sh
cd
rm -rf torghost

systemctl enable ssh
systemctl start ssh
systemctl status ssh

chsh -s $(which bash)

echo -e "\n\n💀💀💀 Done. Don't forget your configs! 💀💀💀"
