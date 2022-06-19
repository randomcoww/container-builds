FROM alpine:edge

RUN set -x \
  \
  && apk add --no-cache \
    keepalived \
    nftables

ENTRYPOINT ["/usr/sbin/keepalived", "-l", "-n"]
