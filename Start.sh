#!/bin/bash

sudo useradd sean && echo "sean:ask your mom" | sudo chpasswd
sudo adduser sean sudo

sudo mkdir /home/sean/.ssh
sudo cp ~/.ssh/authorized_keys /home/sean/.ssh
sudo chown sean:sean -R /home/sean/.ssh

sudo iptables --flush
sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo netfilter-persistent save -y
sudo dpkg-reconfigure iptables-persistent -y

sudo apt remove snapd -y && sudo apt autoremove -y
sudo rm -rf /root/snap

sudo usermod -L ubuntu
sudo passwd -l ubuntu
sudo chage -E0 ubuntu
sudo usermod -s /sbin/nologin ubuntu
