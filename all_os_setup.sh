#!/bin/bash

# ==============================
#  MUST RUN AS ROOT
# ==============================
[ "$(id -u)" != "0" ] && { echo "Bạn phải chạy bằng tài khoản root!"; exit 1; }

# ==============================
#  RANDOM USERNAME & PASSWORD
# ==============================
VPN_USER=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 10)
VPN_PASS=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 12)

VPN_LOCAL="192.168.0.1"
VPN_REMOTE="192.168.0.10-100"

# Detect OS
if [ -f /etc/redhat-release ]; then
    OS="centos"
elif grep -qi ubuntu /etc/os-release; then
    OS="ubuntu"
elif grep -qi debian /etc/os-release; then
    OS="ubuntu"
else
    echo "Hệ điều hành không được hỗ trợ!"
    exit 1
fi

clear
echo "#############################################################"
echo "#           PPTP VPN AUTO INSTALLER (ALL IN ONE)            #"
echo "#############################################################"
sleep 1

VPN_IP=$(curl -s ipv4.icanhazip.com)

echo "► Username: $VPN_USER"
echo "► Password: $VPN_PASS"
sleep 2
clear

# ==============================
#  UBUNTU / DEBIAN
# ==============================
if [ "$OS" = "ubuntu" ]; then

    apt update -y
    apt install -y curl pptpd ppp iptables

    sed -i 's/^#*net.ipv4.ip_forward=.*/net.ipv4.ip_forward=1/' /etc/sysctl.conf
    sysctl -p

    echo "localip $VPN_LOCAL" >> /etc/pptpd.conf
    echo "remoteip $VPN_REMOTE" >> /etc/pptpd.conf

    cat >> /etc/ppp/pptpd-options << EOF
ms-dns 8.8.8.8
ms-dns 8.8.4.4
ms-dns 1.1.1.1
EOF

    echo "$VPN_USER pptpd $VPN_PASS *" >> /etc/ppp/chap-secrets

    ETH=$(ip route | grep default | awk '{print $5}')

    iptables -A INPUT -p tcp --dport 1723 -j ACCEPT
    iptables -A INPUT -p gre -j ACCEPT
    iptables -t nat -A POSTROUTING -o $ETH -j MASQUERADE
    iptables -A FORWARD -p tcp --syn -i ppp+ -j TCPMSS --set-mss 1356

    apt install -y iptables-persistent
    netfilter-persistent save

    systemctl restart pptpd


# ==============================
#  CENTOS 6 / 7 / 8 / ROCKY / ALMA
# ==============================
elif [ "$OS" = "centos" ]; then

    yum install -y epel-release || dnf install -y epel-release
    yum install -y curl wget make gcc-c++ ppp pptpd iptables iptables-services || \
    dnf install -y curl wget make gcc-c++ ppp pptpd iptables iptables-services

    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
    sysctl -p

    echo "localip $VPN_LOCAL" >> /etc/pptpd.conf
    echo "remoteip $VPN_REMOTE" >> /etc/pptpd.conf

    cat >> /etc/ppp/options.pptpd << EOF
ms-dns 8.8.8.8
ms-dns 8.8.4.4
ms-dns 1.1.1.1
EOF

    echo "$VPN_USER pptpd $VPN_PASS *" >> /etc/ppp/chap-secrets

    ETH=$(ip route | grep default | awk '{print $5}')

    iptables -I INPUT -p tcp --dport 1723 -j ACCEPT
    iptables -I INPUT -p gre -j ACCEPT
    iptables -t nat -A POSTROUTING -o $ETH -j MASQUERADE
    iptables -I FORWARD -p tcp --syn -i ppp+ -j TCPMSS --set-mss 1356

    service iptables save || systemctl restart iptables

    systemctl restart pptpd
    systemctl enable pptpd

fi

clear
echo "=============================================================="
echo "▶ Cài đặt PPTP VPN thành công!"
echo "=============================================================="
echo "▶ IP: $VPN_IP"
echo "▶ Username: $VPN_USER"
echo "▶ Password: $VPN_PASS"
echo "=============================================================="
