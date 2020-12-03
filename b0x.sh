#!/bin/bash

# Author: per
# Description: Set up a functional Kali machine for webapp pentesting

if [ $EUID -ne 0 ]; then
    echo "Run as root"
    exit 1
fi

echo "62 30 78"
echo "  _      ___       "
echo " | |    / _ \      "
echo " | |__ | | | |_  __"
echo " | '_ \| | | \ \/ /"
echo " | |_) | |_| |>  < "
echo " |_.__/ \___//_/\_\\"
echo -e " v1.0.0 - https://github.com/Perdyx/scripts/blob/master/b0x.sh\n\n"

apt update -y
apt upgrade -y

apt install -y amass \
    burpsuite \
    metasploit \
    nmap \
    tmux \
    vim

wget https://dl.google.com/go/go1.13.4.linux-amd64.tar.gz
tar -xvf go1.13.4.linux-amd64.tar.gz
mv go /usr/local
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
echo 'export GOROOT=/usr/local/go' >> ~/.bash_profile
echo 'export GOPATH=$HOME/go'	>> ~/.bash_profile			
echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> ~/.bash_profile	
source ~/.bash_profile

go get -u github.com/tomnomnom/httprobe

apt install -y python3-pip
git clone https://github.com/SusmithKrishnan/torghost.git
chmod +x torghost/build.sh
./torghost/build.sh
rm -rf torghost

systemctl enable ssh
systemctl start ssh
systemctl status ssh

echo -e "\n\n💀💀💀 Done. Don't forget your configs! 💀💀💀"
