FROM alpine:latest

RUN set -x \
  \
  && wget -O - \
    'https://dl.cloudsmith.io/public/isc/kea-dev/rsa.74BF45C5BC52B8DD.key' > /etc/apk/keys/kea-dev@isc-74BF45C5BC52B8DD.rsa.pub \
  && wget -O - \
    "https://dl.cloudsmith.io/public/isc/kea-dev/config.alpine.txt?distro=alpine&arch=$(arch)&version=$(cat /etc/alpine-release)" >> /etc/apk/repositories \
  && apk add --no-cache \
    isc-kea-dhcp4 \
    isc-kea-dhcp6 \
    isc-kea-hooks \
    isc-kea-dhcp-ddns \
    isc-kea-ctrl-agent \
    envsubst