#!/bin/bash

sudo apt update -y
sudo apt full-upgrade -y

sudo apt install gdb
git clone https://github.com/longld/peda.git ~/peda
echo "source ~/peda/peda.py" >> ~/.gdbinit

sudo apt install python3 python3-pip
sudo pip install pwntools