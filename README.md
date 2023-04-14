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
curl -sSLO https://raw.githubusercontent.com/thegreatestgiant/Scripts/main/Base.sh; chmod +x Base.sh;sed -i '/^setup_shell() {/,/^}$/ s/^    exec bash$/    rm Base.sh\n&/' Base.sh; ./Base.sh;
```

# Make my User
```bash
sudo bash -c "$(curl -sSL https://raw.githubusercontent.com/thegreatestgiant/Scripts/main/users.sh)"
```

# Calibre
```sh
curl -sSL https://raw.githubusercontent.com/thegreatestgiant/Scripts/main/Calibre.sh | sudo bash
```
