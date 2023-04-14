#!/bin/bash

sudo useradd -m -s /bin/bash sean && echo "sean:ask your mom" | sudo chpasswd
sudo usermod -aG sudo sean

sudo mkdir /home/sean/.ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFm6+eST03I30f2Llr8qnn40HiuH0F4w0wmUL4dOth1o sean@Home" > ~/authorized_keys
sudo chmod 600 ~/authorized_keys
sudo chown sean:sean ~/authorized_keys
sudo mv ~/authorized_keys /home/sean/.ssh

echo "sean   ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/90-cloud-init-users > /dev/null

sudo iptables --flush
sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo netfilter-persistent save -c
sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure iptables-persistent

sudo apt remove snapd -y && sudo apt autoremove -y
sudo rm -rf /root/snap

sudo apt update && sudo apt upgrade -y

sudo rm -rf Start.sh

sudo usermod -L ubuntu
sudo passwd -l ubuntu
sudo chage -E0 ubuntu
sudo usermod -s /sbin/nologin ubuntu
