#!/bin/bash

echo "alias bat=\"batcat\"
alias ip=\"curl icanhazip.com\"
alias i=\"sudo apt install\"
alias zupdate=\"sudo apt update && sudo apt upgrade -y\"
alias speedtest=\"curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -\"" >> ~/.bashrc

source ~/.bashrc

sudo apt update && sudo apt upgrade -y

sudo apt install -y nano net-tools docker docker.io docker-compose nautilus bat nginx sshfs zip unzip cmatrix tree

echo "Done!"
