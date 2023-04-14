#!/bin/bash

sudo useradd -m -s /bin/bash sean && echo "sean:ask your mom" | sudo chpasswd
sudo usermod -aG sudo myusername

sudo mkdir /home/sean/.ssh
sudo cp ~/.ssh/authorized_keys /home/sean/.ssh
sudo chown sean:sean -R /home/sean/.ssh

echo "sean   ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/90-cloud-init-users > /dev/null

sudo iptables --flush
sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo netfilter-persistent save -c
sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure iptables-persistent

sudo apt remove snapd -y && sudo apt autoremove -y
sudo rm -rf /root/snap

sudo usermod -L ubuntu
sudo passwd -l ubuntu
sudo chage -E0 ubuntu
sudo usermod -s /sbin/nologin ubuntu
