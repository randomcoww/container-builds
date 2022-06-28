FROM alpine:latest as BUILD

ARG VERSION

RUN set -x \
  \
  && apk add --no-cache \
    g++ \
    xz-dev \
    make \
    perl \
    bash \
    cdrkit \
    git \
    ca-certificates \
  \
  && git clone -b $VERSION https://github.com/ipxe/ipxe /ipxe

WORKDIR /ipxe/src
COPY config/ config/local/

RUN set -x \
  \
  && make -j "$(getconf _NPROCESSORS_ONLN)" \
    bin-x86_64-efi/ipxe.efi \
    bin/undionly.kpxe

FROM alpine:latest

WORKDIR /var/tftpboot
COPY --from=BUILD --chown=nobody:nogroup \
  /ipxe/src/bin-x86_64-efi/ipxe.efi .
COPY --from=BUILD --chown=nobody:nogroup \
  /ipxe/src/bin/undionly.kpxe .

RUN set -x \
  \
  && apk add --no-cache \
    tftp-hpa

ENTRYPOINT [ "in.tftpd", "--foreground", "--user", "nobody", "--secure", "/var/tftpboot" ]
