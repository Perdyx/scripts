#!/usr/bin/env bash

set -euxo pipefail

hostname="kali"
root_password="toor"
gui_enabled="false"
additional_packages="htop" # Separate multiple packages by a single space
address="192.168.230.1"
netmask="255.255.255.0"
network="192.168.230.0"
broadcast="192.168.230.255"
dhcp_range="192.168.230.2,192.168.230.255"
ssid="Pi-AP"
wpa_passphrase="raspberry"
ssid_broadcasting=true
mac_filtering=false # Whitelist stored in /etc/hostapd/whitelist
filtered_macs="" # Only use if $mac_filtering is true. Separate multiple addresses by a single space

hostnamectl set-hostname $hostname

echo -e "$root_password\n$root_password" | passwd root

if [ "$gui_enabled" = true ]; then
    systemctl set-default graphical.target
else
    systemctl set-default multi-user.target
fi

echo "function mon0up() { iw phy phy0 interface add mon0 type managed && ifconfig mon0 up; }
function mon0down() { ifconfig mon0 down && iw dev mon0 del; }" > .bash_aliases
chmod +x ~/.bash_aliases

apt-get install $additional_packages -y

apt-get install hostapd dnsmasq dhcpcd5 -y

echo "denyinterfaces wlan0" >> /etc/dhcpcd.conf

echo "auto lo
iface lo inet loopback

allow-hotplug eth0
iface eth0 inet dhcp

auto wlan0
iface wlan0 inet static
address $address
netmask $netmask
network $network
broadcast $broadcast

allow-hotplug wlan1
iface wlan1 inet dhcp
wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf" > /etc/network/interfaces

echo "interface=wlan0
driver=nl80211

hw_mode=g
channel=6
ieee80211n=1
wmm_enabled=1
ht_capab=[HT40][SHORT-GI-20][DSSS_CCK-40]

auth_algs=1
wpa=2
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP

ssid=$ssid
wpa_passphrase=$wpa_passphrase" > /etc/hostapd/hostapd.conf

sed -i "s/#DAEMON_CONF=\"\"/DAEMON_CONF=\"\/etc\/hostapd\/hostapd.conf\"/g" /etc/default/hostapd

if [ "$ssid_broadcasting" = false ]; then
    echo "ignore_broadcast_ssid=1" >> /etc/hostapd/hostapd.conf
else
    echo "#ignore_broadcast_ssid=1" >> /etc/hostapd/hostapd.conf
fi

if [ "$mac_filtering" = true ]; then
    echo "
macaddr_acl=1
accept_mac_file=/etc/hostapd/whitelist" >> /etc/hostapd/hostapd.conf

else
    echo "
#macaddr_acl=1
#accept_mac_file=/etc/hostapd/whitelist" >> /etc/hostapd/hostapd.conf
fi

echo $filtered_macs | tr ' ' '\n' > /etc/hostapd/whitelist

cp /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
echo "interface=wlan0
listen-address=$address
bind-interfaces
server=8.8.8.8
domain-needed
bogus-priv
dhcp-range=$dhcp_range,12h" > /etc/dnsmasq.conf

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

update-alternatives --set iptables /usr/sbin/iptables-legacy

iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT

iptables -t nat -A POSTROUTING -o mon0 -j MASQUERADE
iptables -A FORWARD -i mon0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i wlan0 -o mon0 -j ACCEPT

iptables -t nat -A POSTROUTING -o wlan1 -j MASQUERADE
iptables -A FORWARD -i wlan1 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i wlan0 -o wlan1 -j ACCEPT

iptables-save > /etc/iptables.conf

echo "#!/bin/sh -e
iptables-restore < /etc/iptables.conf
exit 0" > /etc/rc.local
chmod +x /etc/rc.local

systemctl enable hostapd || systemctl unmask hostapd && systemctl enable hostapd
systemctl enable dnsmasq || systemctl unmask dnsmasq && systemctl enable dnsmasq

cat /dev/null > ~/.bash_history && history -c
