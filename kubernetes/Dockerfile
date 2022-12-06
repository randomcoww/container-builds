ARG VERSION
FROM ghcr.io/randomcoww/kubernetes:base-$VERSION AS BASE

## kube-master
FROM scratch AS kube-master

COPY --from=BASE /usr/local/bin/kube-apiserver /usr/local/bin/
COPY --from=BASE /usr/local/bin/kube-controller-manager /usr/local/bin/
COPY --from=BASE /usr/local/bin/kube-scheduler /usr/local/bin/

## kube-proxy
## https://github.com/kubernetes/kubernetes/blob/master/build/debian-iptables/Dockerfile
# There is bug with iptables-nft-restore on alpine:edge. Use 3.11.
FROM alpine:edge AS kube-proxy

COPY --from=BASE /usr/local/bin/kube-proxy /usr/local/bin/
RUN set -x \
  \
  && apk add --no-cache \
    conntrack-tools \
    iptables \
    ipset \
    kmod \
  \
  # use nftables backend for iptables
  && cd /sbin \
  && ln -sf xtables-nft-multi iptables \
  && ln -sf xtables-nft-multi iptables-restore \
  && ln -sf xtables-nft-multi iptables-save \
  \
  # kubelet expects some binaries at /usr/sbin
  && ln -s /sbin/* /usr/sbin/ || true \
  && ln -s /bin/* /usr/bin/ || true