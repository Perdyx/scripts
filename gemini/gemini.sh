#!/bin/bash

set -e

home="/home/$(logname)"

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit
fi

deps="dconf-editor git nodejs npm terminator vim"
echo "Installing dependencies ($deps)..."
apt-get update > /dev/null
apt-get install -y $deps > /dev/null
npm install --global --no-progress gtop > /dev/null

read -r -p "Install personal configs? (WARNING: This will overwrite any existing configs!) [y/N] " pconf
case $pconf in
    [yY][eE][sS]|[yY])
        echo "Installing personal configs..."
        curl -s https://raw.githubusercontent.com/Perdyx/configs/master/git/.gitconfig > $home/.gitconfig
        curl -s https://raw.githubusercontent.com/Perdyx/configs/master/tmux/.tmux.conf $home/.tmux.conf
	curl -s https://raw.githubusercontent.com/Perdyx/configs/master/terminator/config > $home/.config/terminator/config
        curl -s https://raw.githubusercontent.com/Perdyx/configs/master/vim/.vimrc > $home/.vimrc
    ;;
    [nN][oO]|[nN]|"")
        echo "Skipping."
    ;;
esac

echo "Restoring dconf backup..."
curl -s https://raw.githubusercontent.com/Perdyx/gemini/master/gemini.dconf > /tmp/gemini.dconf
sleep 1
dconf load / < /tmp/gemini.dconf
sleep 1
rm -f /tmp/gemini.dconf

echo "Done!"
