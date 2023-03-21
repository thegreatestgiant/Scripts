# Scripts

### Here is the code to run them
---
# Home linux server 
```bash
curl -sSLo startup.sh https://raw.githubusercontent.com/thegreatestgiant/Scripts/main/startup.sh?token=GHSAT0AAAAAAB7BMODRE4IKQNOT6UJH3PUEZASTA4Q; chmod +x startup.sh; ./startup.sh
```

# Base file
```bash
curl -sSLO https://cdn.jsdelivr.net/gh/thegreatestgiant/cdn/Base.sh; chmod +x Base.sh; ./Base.sh -y
```
edit through [this](https://github.com/thegreatestgiant/cdn/edit/main/Base.sh) link

# Calibre
```sh
curl -sSL https://raw.githubusercontent.com/thegreatestgiant/Scripts/main/Calibre.sh?token=GHSAT0AAAAAAB7BMODRIB3M2QM4UZEUMVU2ZAXQQSA | bash
```

```sh
for file in *.epub; do mv "$file" "${file/ (*)/}"; done
```
