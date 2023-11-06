#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root."
    exit 69
fi

PACKAGES=("nano" "net-tools" "docker" "docker.io" "docker-compose" "nautilus" "bat" "sshfs" "zip" "unzip" "tree" "git" "fuse3" "curl" "wget")

setup_shell() {
    local bashrc_file="/etc/bash.bashrc"

    # Check if aliases are already in /etc/bash.bashrc
    if ! grep -q "alias bat='batcat'" "$bashrc_file"; then
        echo "Adding aliases to $bashrc_file"
        cat <<EOL >> "$bashrc_file"
alias bat='batcat'
alias cmatrix='cmatrix -sb'
alias i='sudo apt install -y'
alias cd..='cd ..'
alias ip='curl icanhazip.com'
alias ls='ls --color=auto -h'
alias l='ls -CFh'
alias la='ls -Ah'
alias ll='ls -alhF'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'
alias weather='curl wttr.in'
alias zupdate='sudo apt update && sudo apt upgrade -y'
alias grep='grep --color=auto'
HISTTIMEFORMAT='%Y-%m-%d %T '
alias ncdir="cd ~/.config/nvim"
alias ncf="nvim ~/.config/nvim/init.lua"
alias brc="nvim ~/.bashrc"
alias nv="nvim"
EOL
    echo "In order for alias to take effect you must restart shell"
    fi

    if ! id "sean" >/dev/null 2>&1; then
        setup_better_user
    fi

    # Check if "sean" is already a member of the "docker" group
    if ! groups sean | grep -q "\bdocker\b"; then
        echo "Adding 'sean' to the 'docker' group"
        usermod -aG docker sean
        echo "Please run 'newgrp docker' or restart your shell for group changes to take effect."
    fi
}


update() {
    DEBIAN_FRONTEND=noninteractive apt update && DEBIAN_FRONTEND=noninteractive apt upgrade -y
}

remove_installed_from_list() {
    local installed_packages=()
    for package in "${PACKAGES[@]}"; do
        if ! dpkg -l | grep -q "ii  $package "; then
            installed_packages+=("$package")
        fi
    done
    PACKAGES=("${installed_packages[@]}")
}

install_all_packages() {
  echo "Updating before installing all_packages"
  update
  ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
  echo "
  Installing all packages
  "
  remove_installed_from_list
  apt install --no-install-recommends -y "${PACKAGES[@]}"
  echo "Done!"
}

setup_better_user() {
    bash -c "$(curl -sSL https://raw.githubusercontent.com/thegreatestgiant/Scripts/main/users.sh)"
}

install_all_packages

setup_shell
