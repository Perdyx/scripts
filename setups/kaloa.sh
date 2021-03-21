#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "Please run this script as root."
    exit 1
fi

dependencies="aircrack-ng kismet"

function err_exit() {
    echo "Installation failed. Cleaning up..."

    apt --purge remove -y $dependencies

    exit 1
}
trap "err_exit" ERR

export DEBIAN_FRONTEND=noninteractive

echo -e "Installing dependencies..."
apt install -y $dependencies

echo "Installing scripts..."
cat << EOF > start_kismet.sh
#!/bin/bash
set-e

read -r -p "Start Kismet on a virtual interface? [Y/n]" kis
case $kis in
    [yY][eE][sS]|[yY]|'')
        iw phy phy0 interface add kis0 type monitor
        ifconfig kis0 up

        kismet -c kis0
    ;;
    [nN][oO]|[nN])
        airmon-ng start wlan1

        kismet -c wlan1mon
    ;;
esac
EOF
chmod +x start_kismet.sh

read -r -p "Start Kismet now? [y/N]" start
case $start in
    [yY][eE][sS]|[yY])
        echo "Starting Kismet..."

        cd
        ./start_kismet.sh
    ;;
    [nN][oO]|[nN]|'')
        echo -e "To start Kismet, run /root/start_kismet.sh.\nEnjoy!"
    ;;
esac