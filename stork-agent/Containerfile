FROM alpine:latest

RUN set -x \
  \
  && wget -O - \
    'https://dl.cloudsmith.io/public/isc/stork-dev/rsa.BF2C56ECBA97B498.key' > /etc/apk/keys/stork-dev@isc-BF2C56ECBA97B498.rsa.pub \
  && wget -O - \
    "https://dl.cloudsmith.io/public/isc/stork-dev/config.alpine.txt?distro=alpine&arch=$(arch)&version=$(cat /etc/alpine-release)" >> /etc/apk/repositories \
  && apk add --no-cache \
    isc-stork-agent

ENTRYPOINT ["stork-agent"]