#!/bin/bash -i

# Base
curl -sSL https://cdn.jsdelivr.net/gh/thegreatestgiant/cdn@latest/Base.sh | sh -s

# Kill 80, 53
sudo lsof -t -i tcp:80 -s tcp:listen | sudo xargs kill
sudo lsof -t -i tcp:53 -s tcp:listen | sudo xargs kill


echo "Starting docker"
echo "version: '2'
services:
  adguardhome:
    image: adguard/adguardhome
    container_name: adguardhome
    ports:
      - 53:53/tcp
      - 53:53/udp
      - 784:784/udp
      - 853:853/tcp
      - 3000:3000/tcp
      - 80:80/tcp
      - 443:443/tcp
    volumes:
      - ./workdir:/opt/adguardhome/work
      - ./confdir:/opt/adguardhome/conf
    restart: unless-stopped" > docker-compose.yml
    
    echo "Made file"
    
    echo "docker-compose up -d"
    docker-compose up -d
    
    echo "finished"
    
    echo "go to yourip:3000"
    echo "Done!"
