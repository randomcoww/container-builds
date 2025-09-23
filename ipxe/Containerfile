FROM alpine:latest as build
ARG COMMIT

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
  && git clone -b master https://github.com/ipxe/ipxe /ipxe \
  && cd /ipxe \
  && git reset --hard $COMMIT

WORKDIR /ipxe/src
COPY config/ config/local/

ARG INTERNAL_CA_CERT

RUN set -x \
  \
  && echo -e "$INTERNAL_CA_CERT" > ca-cert.pem \
  && make \
    bin-$(arch)-efi/ipxe.efi \
    CERT=ca-cert.pem \
    TRUST=ca-cert.pem \
    DEBUG=x509,certstore \
  \
  && mkdir -p /build \
  && mv bin-$(arch)-efi/*.efi /build/

FROM busybox:stable-musl

WORKDIR /var/www
COPY --from=build --chown=www-data:www-data /build/ .
USER www-data

ENTRYPOINT [ "httpd", "-f", "-v" ]
# busybox also includes tftpd and may be started like this:
# ENTRYPOINT [ "udpsvd", "-vE", "0.0.0.0", "69", "tftpd", "-r", "-u", "www-data", "/var/www" ]