#!/bin/bash

PACKAGES=("nano" "net-tools" "docker" "docker.io" "docker-compose" "nautilus" "bat" "nginx" "sshfs" "zip" "unzip" "cmatrix" "tree")

setup_shell() {
    echo "
    alias bat='batcat'
    alias cmatrix='cmatrix -sb'
    alias i='sudo apt install -y'
    alias cd..='cd ..'
    alias ip='curl icanhazip.com'
    alias ls='ls --color=auto -h'
    alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'
    alias weather='curl wttr.in'
    alias zupdate='sudo apt update && sudo apt upgrade -y'
    alias grep='grep --color=auto'
    alias unmount='fusermount -u Kavita'
    alias remount='fusermount -u Kavita; mount -a'
    HISTTIMEFORMAT='%Y-%m-%d %T '" | sudo tee -a /etc/bash.bashrc

    rm Base.sh

    if ! id "sean" >/dev/null 2>&1; then
        setup_better_user
    fi

    exec bash
}

update() {
    sudo apt update -y && sudo update-initramfs -u -y && sudo apt upgrade -y
}

install_all_packages() {
  echo "Installing all packages without prompting..."
  sudo apt install -y "${PACKAGES[@]}"
  echo "Done!"
}

install_selected_packages() {
  echo "Please select which packages you don't want to install (enter the numbers separated by spaces):"
  for i in "${!PACKAGES[@]}"; do
    echo "[$i] ${PACKAGES[$i]}"
  done

  read -r -a choices
  for choice in "${choices[@]}"; do
    if [[ "$choice" =~ ^[0-9]+$ ]]; then
      unset PACKAGES[$choice]
    fi
  done

  echo "Installing selected packages..."
  sudo apt install -y "${PACKAGES[@]}"
  echo "Done!"
}

setup_better_user() {
    echo "Creating new user..."
    sudo useradd -m -s /bin/bash sean && echo "sean:ask your mom" | sudo chpasswd
    sudo usermod -aG sudo sean
    echo "Created"

    echo "transfering ssh keys..."
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFm6+eST03I30f2Llr8qnn40HiuH0F4w0wmUL4dOth1o sean@Home" | sudo tee /root/.ssh/authorized_keys > /dev/null
    sudo mkdir /home/sean/.ssh
    sudo cp /root/.ssh/authorized_keys /home/sean/.ssh/authorized_keys
    sudo chown sean:sean -R /home/sean/.ssh
    echo "transfered"

    echo "sean   ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/90-cloud-init-users > /dev/null

    echo "flushing iptables"
    sudo iptables --flush
    sudo iptables -P INPUT ACCEPT
    sudo iptables -P OUTPUT ACCEPT
    sudo iptables -P FORWARD ACCEPT
    sudo netfilter-persistent save -c
    sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure iptables-persistent

    sudo apt remove snapd -y && sudo apt autoremove -y
    sudo rm -rf /root/snap

    echo "locking ubuntu account"
    sudo usermod -L ubuntu
    sudo passwd -l ubuntu
    sudo chage -E0 ubuntu
    sudo usermod -s /sbin/nologin ubuntu
    echo "locked"
}

# Process command-line options
while getopts ":hy" opt; do
  case $opt in
    h)
      echo "Usage: $0 [-y]"
      echo "  -y: automatically install all packages without prompting"
      echo "  -h: display this help message"
      exit 0
      ;;
    y)
      update
      install_all_packages
      setup_shell
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

echo -n "Do you want to install all packages? [Y/n] "
read choice_all
choice_all="${choice_all:-y}"
if [[ "$choice_all" =~ ^[Yy]$ ]]; then
  update
  install_all_packages
else
  update
  install_selected_packages
fi

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

setup_shell
