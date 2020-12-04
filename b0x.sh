#!/bin/bash

# Author: per
# Description: Set up a functional Kali machine for webapp pentesting

if [ $EUID -ne 0 ]; then
    echo "Running this script as root will have unintended consequences. Aborting..."
    exit 1
fi

sudo echo "62 30 78"

echo "  _      ___       "
echo " | |    / _ \      "
echo " | |__ | | | |_  __"
echo " | '_ \| | | \ \/ /"
echo " | |_) | |_| |>  < "
echo " |_.__/ \___//_/\_\\"
echo -e "\nv1.0.0 - https://github.com/Perdyx/scripts/blob/master/b0x.sh\n\n"

sudo apt update -y

sudo apt install -y amass \
    burpsuite \
    metasploit-framework \
    nmap \
    tmux \
    vim

wget https://dl.google.com/go/go1.13.4.linux-amd64.tar.gz
tar -xvf go1.13.4.linux-amd64.tar.gz
sudo mv go /usr/local
rm go1.13.4.linux-amd64.tar.gz
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
echo "export GOROOT=/usr/local/go" >> $HOME/.profile
echo "export GOPATH=$HOME/go" >> $HOME/.profile
echo "export PATH=$GOPATH/bin:$GOROOT/bin:$PATH" >> $HOME/.profile
source $HOME/.profile

go get -u github.com/tomnomnom/httprobe

apt install -y python3-pip
git clone https://github.com/SusmithKrishnan/torghost.git $HOME
chmod +x $HOME/torghost/build.sh
sh $HOME/build.sh
rm -rf $HOME/torghost

systemctl enable ssh
systemctl start ssh
systemctl status ssh

chsh -s $(which bash)

echo -e "\n\n💀💀💀 Done. Don't forget your configs! 💀💀💀"
