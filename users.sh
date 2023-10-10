#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root."
    exit 69
fi

# Create a new user 'sean'
if ! id "sean" &>/dev/null; then
    echo "Creating new user..."
    useradd -m -s /bin/bash sean
    echo "sean:ask your mom" | chpasswd
    usermod -aG sudo sean
    echo "User 'sean' created."
fi

# Transfer SSH keys
if [ ! -f /home/sean/.ssh/authorized_keys ]; then
    echo "Transferring SSH keys..."
    mkdir -p /root/.ssh
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFm6+eST03I30f2Llr8qnn40HiuH0F4w0wmUL4dOth1o" > /root/.ssh/authorized_keys
    mkdir -p /home/sean/.ssh
    cp /root/.ssh/authorized_keys /home/sean/.ssh/authorized_keys
    chown sean:sean -R /home/sean/.ssh
    echo "SSH keys transferred."
fi

# Add sudo configurations
echo "sean ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-user-sean

# Flush iptables rules
echo "Flushing iptables..."
iptables --flush
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
netfilter-persistent save -c
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure iptables-persistent
echo "Iptables flushed."

 # Remove Snapd
if dpkg -l | grep -q snapd; then
    # Remove all Snap packages
    snap_list=$(snap list | awk '{print $1}')
    for package in $snap_list; do
        snap remove "$package"
    done
    
    echo "Removing Snapd..."
    apt remove snapd -y
    apt autoremove -y
    rm -rf /root/snap
    rm -rf /snap
fi

if id "ubuntu" &>/dev/null; then
    echo "Locking ubuntu account..."
    usermod -L ubuntu
    passwd -l ubuntu
    chage -E0 ubuntu
    usermod -s /sbin/nologin ubuntu
    echo "ubuntu account locked."
fi

echo "Script execution completed."
