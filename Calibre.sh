#!/bin/sh

(curl -sSLO https://raw.githubusercontent.com/thegreatestgiant/Scripts/main/Base.sh && chmod +x Base.sh && ./Base.sh -y) || apk update; apk add nano

docker pull lscr.io/linuxserver/calibre:latest

docker run -d \
  --name=calibre \
  --security-opt seccomp=unconfined \
  -e PUID=0 \
  -e PGID=0 \
  -e TZ=america/new_york \
  -p 8080:8080 \
  -p 8081:8081 \
  -v /calibre:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/calibre:latest
