# add s6 overlay
# https://github.com/linuxserver/docker-baseimage-fedora/blob/master/Dockerfile
FROM alpine:edge AS rootfs-stage

ARG S6_OVERLAY_VERSION="3.1.6.2"
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

FROM nvidia/cuda:12.2.2-cudnn8-runtime-rockylinux9

ARG ARCH
ARG CODE_VERSION
ARG HELM_VERSION
ARG JFS_VERSION

COPY --from=rootfs-stage /root-out/ /
COPY kubernetes.repo /etc/yum.repos.d/

RUN set -x \
  \
  && echo 'exclude=*.i386 *.i686' >> /etc/dnf.conf \
  && rpm --setcaps shadow-utils 2>/dev/null \
  && dnf install -y --setopt=install_weak_deps=False --best \
    \
    # podman
    podman \
    containernetworking-plugins \
    slirp4netns \
    netavark \
    aardvark-dns \
    crun \
    fuse-overlayfs \
    \
    sudo \
    git-core \
    iproute-tc \
    iptables-nft \
    gzip \
    tar \
    xz \
    jq \
    procps-ng \
    which \
    lsof \
    strace \
    https://github.com/coder/code-server/releases/download/v$CODE_VERSION/code-server-$CODE_VERSION-$ARCH.rpm \
    rsync \
    unzip \
    kubectl \
    \
    # ipynb
    python3-pip \
  --exclude \
    container-selinux \
  && dnf autoremove -y \
  && dnf clean all \
  && rm -rf /var/cache /var/log/dnf* /var/log/yum.*

RUN set -x \
  \
  && curl -L -o helm.tar.gz \
    https://get.helm.sh/helm-v$HELM_VERSION-linux-$ARCH.tar.gz \
  && tar xzf helm.tar.gz -C /usr/local/bin --strip-components=1 linux-$ARCH/helm \
  && rm -f helm.tar.gz \
  \
  && curl -L -o /usr/local/bin/mc \
    https://dl.min.io/client/mc/release/linux-$ARCH/mc \
  && chmod +x /usr/local/bin/mc \
  \
  && curl -L -o jfs.tar.gz \
    https://github.com/juicedata/juicefs/releases/download/v$JFS_VERSION/juicefs-$JFS_VERSION-linux-$ARCH.tar.gz \
  && tar xzf jfs.tar.gz -C /usr/local/bin juicefs \
  && rm -f jfs.tar.gz \
  \
  && echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel

COPY /root /

ENV \
  S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
  S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
  S6_VERBOSITY=1 \
  USER=podman \
  UID=1000 \
  HOME=/home/podman \
  LANG=C.UTF-8 \
  CODE_PORT=8080

ENTRYPOINT ["/init"]