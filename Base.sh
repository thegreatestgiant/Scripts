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
    alias l='ls -CF'
    alias la='ls -A'
    alias ll='ls -alF'
    alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'
    alias weather='curl wttr.in'
    alias zupdate='sudo apt update && sudo apt upgrade -y'
    alias grep='grep --color=auto'
    alias unmount='fusermount -u Kavita'
    alias remount='fusermount -u Kavita; mount -a'
    HISTTIMEFORMAT='%Y-%m-%d %T '" | sudo tee -a /etc/bash.bashrc > /dev/null

    if ! id "sean" >/dev/null 2>&1; then
        setup_better_user
    fi
    
    sudo groupadd docker
    sudo usermod -aG docker sean
    newgrp docker

    exec bash
}

update() {
    sudo apt update -y && sudo update-initramfs -u && sudo apt upgrade -y
}

install_all_packages() {
  echo "Updating before installing all_packages"
  update
  echo "
  Installing all packages without prompting...
  "
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
  
  echo "
  Updating b4 installing selected packages
  "
  update
  echo "
  Installing selected packages...
  "
  sudo apt install -y "${PACKAGES[@]}"
  echo "Done!"
}

setup_better_user() {
    sudo bash -c "$(curl -sSL https://raw.githubusercontent.com/thegreatestgiant/Scripts/main/users.sh)"
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
  install_all_packages
else
  install_selected_packages
fi

setup_shell
