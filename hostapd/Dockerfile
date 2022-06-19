FROM alpine:edge

RUN set -x \
  \
  && apk add --no-cache \
    hostapd

ENTRYPOINT ["/usr/sbin/hostapd"]