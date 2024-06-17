# add s6 overlay
# https://github.com/linuxserver/docker-baseimage-fedora/blob/master/Dockerfile
FROM alpine:edge AS rootfs-stage

ARG S6_OVERLAY_VERSION
RUN set -x \
  \
  && mkdir -p /root-out src \
  && wget -O src/s6-overlay-noarch.tar.xz \
    https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz \
  && wget -O src/s6-overlay-arch.tar.xz \
    https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-$(arch).tar.xz \
  && wget -O src/s6-overlay-symlinks-noarch.tar.xz \
    https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz \
  && wget -O src/s6-overlay-symlinks-arch.tar.xz \
    https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz \
  && tar -C /root-out -Jxpf src/s6-overlay-noarch.tar.xz \
  && tar -C /root-out -Jxpf src/s6-overlay-arch.tar.xz \
  && tar -C /root-out -Jxpf src/s6-overlay-symlinks-noarch.tar.xz \
  && tar -C /root-out -Jxpf src/s6-overlay-symlinks-arch.tar.xz \
  && rm -rf src

FROM fedora:latest

ARG TARGETARCH
ARG CODE_VERSION

COPY --from=rootfs-stage /root-out/ /

RUN set -x \
  \
  && echo 'exclude=*.i386 *.i686' >> /etc/dnf.conf \
  && rpm --setcaps shadow-utils 2>/dev/null \
  && dnf install -y --setopt=install_weak_deps=False --best \
    \
    podman \
    containernetworking-plugins \
    passt \
    netavark \
    aardvark-dns \
    crun \
    fuse-overlayfs \
    \
    sudo \
    git-core \
    iproute-tc \
    nftables \
    gzip \
    tar \
    xz \
    unar \
    jq \
    procps-ng \
    which \
    lsof \
    strace \
    ldns-utils \
    https://github.com/coder/code-server/releases/download/v$CODE_VERSION/code-server-$CODE_VERSION-$TARGETARCH.rpm \
    kubernetes-client \
    helm \
  --exclude \
    container-selinux \
  && dnf autoremove -y \
  && dnf clean all \
  && rm -rf /var/cache /var/log/dnf* /var/log/yum.*

RUN set -x \
  \
  && curl -L -o /usr/local/bin/mc \
    https://dl.min.io/client/mc/release/linux-$TARGETARCH/mc \
  && chmod +x /usr/local/bin/mc \
  \
  && echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel

ENV \
  S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
  S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
  S6_VERBOSITY=1 \
  LANG=C.UTF-8

ENTRYPOINT ["/init"]