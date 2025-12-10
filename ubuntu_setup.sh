#!/bin/bash

# Must run as root
[ "$(id -u)" != "0" ] && { echo "Bạn phải chạy bằng tài khoản root!"; exit 1; }

apt update -y
apt install -y curl pptpd ppp iptables

clear
printf "
#############################################################
#           PPTP VPN AUTO INSTALLER FOR UBUNTU              #
#############################################################
"

VPN_IP=$(curl -s ipv4.icanhazip.com)

# Random username & password (10 ký tự)
VPN_USER=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 10)
VPN_PASS=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 12)

VPN_LOCAL="192.168.0.1"
VPN_REMOTE="192.168.0.10-100"

clear

echo "► Username: $VPN_USER"
echo "► Password: $VPN_PASS"
echo "Đang tiến hành cài đặt..."
sleep 2

# Enable IP Forwarding
sed -i 's/^#*net.ipv4.ip_forward=.*/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sysctl -p

# Configure pptpd
echo "localip $VPN_LOCAL" >> /etc/pptpd.conf
echo "remoteip $VPN_REMOTE" >> /etc/pptpd.conf

# DNS
cat >> /etc/ppp/pptpd-options << EOF
ms-dns 8.8.8.8
ms-dns 8.8.4.4
ms-dns 1.1.1.1
EOF

# Add user
echo "$VPN_USER pptpd $VPN_PASS *" >> /etc/ppp/chap-secrets

# Detect network interface
ETH=$(ip route | grep default | awk '{print $5}')

# Iptables rules
iptables -A INPUT -p tcp --dport 1723 -j ACCEPT
iptables -A INPUT -p gre -j ACCEPT
iptables -t nat -A POSTROUTING -o $ETH -j MASQUERADE
iptables -A FORWARD -p tcp --syn -i ppp+ -j TCPMSS --set-mss 1356

# Save iptables on reboot
apt install -y iptables-persistent
netfilter-persistent save

systemctl restart pptpd

clear
echo "▶ Cài đặt PPTP VPN thành công!"
echo "▶ IP: $VPN_IP"
echo "▶ Username: $VPN_USER"
echo "▶ Password: $VPN_PASS"
