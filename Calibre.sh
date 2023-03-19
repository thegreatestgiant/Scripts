#!/bin/sh

(curl -sSLO https://cdn.jsdelivr.net/gh/thegreatestgiant/cdn/Base.sh && chmod +x Base.sh && ./Base.sh -y) || apk update; apk add nano
