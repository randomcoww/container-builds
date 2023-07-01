FROM alpine:latest

RUN set -x \
  \
  && apk add --no-cache \
    wireguard-tools \
    nftables

ENTRYPOINT ["wg-quick"]