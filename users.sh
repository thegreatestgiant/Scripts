#!/bin/bash

    echo "Creating new user..."
    sudo useradd -m -s /bin/bash sean && echo "sean:ask your mom" | sudo chpasswd
    sudo usermod -aG sudo sean
    echo "Created"

    echo "transfering ssh keys..."
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFm6+eST03I30f2Llr8qnn40HiuH0F4w0wmUL4dOth1o" | sudo tee /root/.ssh/authorized_keys > /dev/null
    sudo mkdir /home/sean/.ssh
    sudo cp /root/.ssh/authorized_keys /home/sean/.ssh/authorized_keys
    sudo chown sean:sean -R /home/sean/.ssh
    echo "transfered"

    echo "%sudo   ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/all-sudo > /dev/null

    echo "flushing iptables"
    sudo iptables --flush
    sudo iptables -P INPUT ACCEPT
    sudo iptables -P OUTPUT ACCEPT
    sudo iptables -P FORWARD ACCEPT
    sudo netfilter-persistent save -c
    sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure iptables-persistent
    echo "Flushed!"

    sudo snap remove oracle-cloud-agent && sudo snap remove lxd && sudo snap remove core18 && sudo snap remove core20 && sudo snap remove snapd 
    sudo apt remove snapd -y && sudo apt autoremove -y
    sudo rm -rf /root/snap && sudo rm -rf /snap
    
    if [ -d /home/ubuntu ];then
        echo "locking ubuntu account"
        sudo usermod -L ubuntu
        sudo passwd -l ubuntu
        sudo chage -E0 ubuntu
        sudo usermod -s /sbin/nologin ubuntu
        echo "locked"
    fi
