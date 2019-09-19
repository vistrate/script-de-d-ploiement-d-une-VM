#! /bin/sh
#this script has to be executed in root
cp /etc/netplan/01-network-manager-all.yaml  /etc/netplan/01-network-manager-all.yaml.bkp

echo "
network:
   version: 2
   renderer:  networkd
   ethernets: 
        enp0s3:
            #addresses:[10.165.8.55/23]
            dhcp4: true
            #gateway4: 10.165.8.1
            nameservers:
                addresses:  [10.165.8.10,10.165.8.143]
                search:
                - knet.intra" > /etc/netplan/01-network-manager-all.yaml  

netplan apply



cd /etc/apt/apt.conf.d
echo "Acquire::http::Proxy \"http://login:mot de passe@hostname_proxy:port proxy\";" > proxy.conf
echo "Acquire::https::Proxy \"http://login:mot de passe@hostname_proxy:port proxy\";" >> proxy.conf
echo "Acquire::ftp::Proxy \"http://login:mot de passe@hostname_proxy:port proxy\";" >> proxy.conf

netplan apply

apt-get update 
apt-get upgrade

#Ici les variables globales seront mises pour tous les utilisateurs
#à rajouter dans /etc/environment.
#Il faut mettre le nom des variables en minuscule et majuscule
export http_proxy="http://login:mot de passe@hostname_proxy:port proxy"
export https_proxy="http://login:mot de passe@hostname_proxy:port proxy"
export RSYNC_PROXY="http://login:mot de passe@hostname_proxy:port proxy"
export ftp_proxy="http://login:mot de passe@hostname_proxy:port proxy"

echo "ftp_proxy=\"http://login:mot de passe@hostname_proxy:port proxy\"" >> /etc/environment
echo "https_proxy=\"http://login:mot de passe@hostname_proxy:port proxy\"" >> /etc/environment
echo "http_proxy=\"http://login:mot de passe@hostname_proxy:port proxy\"" >> /etc/environment
echo "RSYNC_PROXY=\"http://login:mot de passe@hostname_proxy:port proxy\"" >> /etc/environment


# Sinon wget fonctionne avec ces lignes de conf.
# You can set the default proxies for Wget to use for http, https, and ftp.
echo "use_proxy = on" >> /etc/wgetrc
echo "ftp_proxy=http://login:mot de passe@hostname_proxy:port proxy" >> /etc/wgetrc
echo "https_proxy=http://login:mot de passe@hostname_proxy:port proxy" >> /etc/wgetrc
echo "http_proxy=http://login:mot de passe@hostname_proxy:port proxy" >> /etc/wgetrc


#on s'assurer que la date du proc et du système sont les mêmes
hwclock --systohc

#réglage du fuseau horaire
rm /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime


reboot

