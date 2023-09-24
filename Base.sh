#!/bin/bash

PACKAGES=("nano" "net-tools" "docker" "docker.io" "docker-compose" "nautilus" "bat" "sshfs" "zip" "unzip" "tree" "git" "fuse3" "curl" "wget")

setup_shell() {
echo "
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
HISTTIMEFORMAT='%Y-%m-%d %T '" | sudo tee -a /etc/bash.bashrc > /dev/null

if ! id "sean" >/dev/null 2>&1; then
    setup_better_user
fi

if ! grep -q "^docker:" /etc/group; then
    sudo groupadd docker
fi
sudo usermod -aG docker sean
newgrp docker
exec bash
}

update() {
    DEBIAN_FRONTEND=noninteractive apt update && DEBIAN_FRONTEND=noninteractive apt upgrade -y

}

install_all_packages() {
  echo "Updating before installing all_packages"
  update
  ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
  echo "
  Installing all packages
  "
  sudo apt install --no-install-recommends -y "${PACKAGES[@]}"
  echo "Done!"
}

setup_better_user() {
    sudo bash -c "$(curl -sSL https://raw.githubusercontent.com/thegreatestgiant/Scripts/main/users.sh)"
}

install_all_packages

setup_shell
