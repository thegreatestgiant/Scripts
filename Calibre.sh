#!/bin/sh

(curl -sSLO https://raw.githubusercontent.com/thegreatestgiant/Scripts/main/Base.sh && chmod +x Base.sh && ./Base.sh -y) || apk update; apk add nano

docker pull thegreatestgiant/calibre:latest

docker run -d \
  --name=calibre \
  --security-opt seccomp=unconfined \
  -e PUID=0 \
  -e PGID=0 \
  -e TZ=america/new_york \
  -p 80:8080 \
  -p 81:8081 \
  -v /root/calibre:/config \
  --restart unless-stopped \
  thegreatestgiant/calibre:latest

if [[ -f calibre/thinclient_drives/ ]];then
  rm -rf calibre/thinclient_drives/
fi
