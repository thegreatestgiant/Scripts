#!/bin/sh

if [ -f /etc/apt ]; then
  curl -sSL 'https://raw.githubusercontent.com/thegreatestgiant/Scripts/main/Base.sh' | sudo bash
else
  apt update && apt install -y nano
fi

# Make sure Docker is installed and available in the PATH
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Please install Docker and make sure it's in your PATH." >&2
    exit 1
fi

docker pull thegreatestgiant/calibre:latest

docker run -d \
  --name=calibre \
  --security-opt seccomp=unconfined \
  -e PUID=0 \
  -e PGID=0 \
  -e TZ=America/New_York \  # Fixed typo in timezone
  -p 80:8080 \
  -p 81:8081 \
  -v /out:/config \
  --restart unless-stopped \
  thegreatestgiant/calibre

# Check if symbolic link already exists before creating it
if [ ! -e "/in" ]; then
  ln -s /out/Calibre\ Library/ /in
fi
