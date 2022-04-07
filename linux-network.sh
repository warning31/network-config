#!/bin/bash
clear

echo -e "##########################################################################"
echo -e "#      Avci Internet ve Bilisim Hizmetleri - http://www.avciweb.com      #"
echo -e "#                         OVH Network Config                             #"
echo -e "#                    Contact at info@avciweb.com.tr                      #"
echo -e "#                               www.avciweb.com                          #"
echo -e "##########################################################################"

echo ""
echo -e "Make sure you have internet connection to install packages..."
echo ""
echo -e "Press key enter"
read presskey

# Disable Selinux & Firewall

echo -e "[INFO] : Configuring Firewall & Selinux"
sleep 2
#sed -i s/'SELINUX='/'#SELINUX='/g /etc/selinux/config
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
setenforce 0
service firewalld stop
service iptables stop
service ip6tables stop
systemctl disable firewalld
systemctl disable iptables
systemctl disable ip6tables

# Configuring network, /etc/hosts and resolv.conf

echo ""
echo -e "[INFO] : Configuring /etc/hosts"
echo ""
echo -n "Hostname. Example mail : "
read HOSTNAME
echo -n "Domain name. Example avciweb.com : "
read DOMAIN
echo -n "IP Address : "
read IPADDRESS
echo ""

# /etc/hosts ipv6 kapat
cp /etc/hosts /etc/hosts.backup

echo "$IPADDRESS   $HOSTNAME.$DOMAIN       $HOSTNAME" >> /etc/hosts

# Change Hostname
hostnamectl set-hostname $HOSTNAME.$DOMAIN


# Update repo and install package

yum clean all
yum -y install epel-release
yum update -y

# Insert localhost as the first Nameserver
# 
sed -i 's/^nameserver .*/nameserver 8.8.8.8/g' /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf


echo ""
echo "Configuring Firewall, network, /etc/hosts has been finished."