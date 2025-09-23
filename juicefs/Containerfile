FROM alpine:latest
ARG VERSION
ARG INTERNAL_CA_CERT

RUN set -x \
  \
  && TARGETARCH=$(arch) \
  && TARGETARCH=${TARGETARCH/x86_64/amd64} && TARGETARCH=${TARGETARCH/aarch64/arm64} \
  \
  && apk add --no-cache \
    fuse \
    ca-certificates \
  \
  && wget -O jfs.tar.gz \
    https://github.com/juicedata/juicefs/releases/download/v$VERSION/juicefs-$VERSION-linux-$TARGETARCH.tar.gz \
  && tar xzf jfs.tar.gz -C /usr/local/bin juicefs \
  && rm jfs.tar.gz \
  && echo -e "$INTERNAL_CA_CERT" > /usr/local/share/ca-certificates/ca-cert.pem \
  && update-ca-certificates

ENTRYPOINT ["juicefs"]