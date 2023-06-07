# Scripts

### Here is the code to run them
---
# Base file
### To auto-download-all
```bash
curl -sSL 'https://raw.githubusercontent.com/thegreatestgiant/Scripts/main/Base.sh' | sudo bash -s - -y
```

### Interactive
```bash
curl -sSLO https://raw.githubusercontent.com/thegreatestgiant/Scripts/main/Base.sh; chmod +x Base.sh;sudo ./Base.sh || ./Base.sh
```

# Make my User
```bash
sudo bash -c "$(curl -sSL https://raw.githubusercontent.com/thegreatestgiant/Scripts/main/users.sh)"
```

# Calibre
```sh
curl -sSL https://raw.githubusercontent.com/thegreatestgiant/Scripts/main/Calibre.sh | sudo bash
```
*In order to edit the Calibre docker image, you have to do this*
```sh
docker cp calibre:/config . && docker cp calibre:/docker-mods .
tar -czvf config.tar.gz config/
echo "tar -xzf /tmp/config.tar.gz -C /config --strip-components=1" >> docker-mods 
FROM lscr.io/linuxserver/calibre:latest
COPY config.tar.gz /tmp/
COPY docker-mods /
```
