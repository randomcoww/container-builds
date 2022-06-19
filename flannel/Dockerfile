FROM golang:alpine as BUILD

ARG VERSION

WORKDIR /go/src/github.com/coreos

RUN set -x \
  \
  && apk add --no-cache \
    git \
    g++ \
    linux-headers \
  \
  && git clone -b $VERSION \
    https://github.com/coreos/flannel.git \
  && cd flannel \
  && mkdir bin \
  && CGO_ENABLED=1 GOOS=linux \
    go build -v -ldflags '-s -w' -o bin/flanneld

# There is bug with iptables-nft-restore on alpine:edge. Use 3.11.
FROM alpine:edge

COPY --from=BUILD /go/src/github.com/coreos/flannel/bin/ /opt/bin/
RUN set -x \
  \
  && apk add --no-cache \
    iproute2 \
    net-tools \
    ca-certificates \
    iptables \
    strongswan \
  \
  # use nftables backend for iptables
  && cd /sbin \
  && ln -sf xtables-nft-multi iptables \
  && ln -sf xtables-nft-multi iptables-restore \
  && ln -sf xtables-nft-multi iptables-save

ENTRYPOINT ["/opt/bin/flanneld"]
