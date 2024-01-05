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
    openssl \
    coreutils \
  \
  && git clone -b $VERSION https://github.com/ipxe/ipxe /ipxe

WORKDIR /ipxe/src
COPY config/ config/local/

RUN set -x \
  \
  && wget -O ca.crt https://ipxe.org/_media/certs/ca.crt \
  && CERT=ca.crt TRUST=ca.crt make -j "$(getconf _NPROCESSORS_ONLN)" \
    bin-x86_64-efi/ipxe.efi \
    bin-x86_64-efi/snp.efi \
    bin-x86_64-efi/snponly.efi

FROM alpine:latest

WORKDIR /var/tftpboot
COPY --from=BUILD --chown=nobody:nogroup \
  /ipxe/src/bin-x86_64-efi/*.efi .

RUN set -x \
  \
  && apk add --no-cache \
    tftp-hpa

ENTRYPOINT [ "in.tftpd", "--foreground", "--user", "nobody", "--secure", "/var/tftpboot" ]
