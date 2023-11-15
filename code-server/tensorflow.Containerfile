ARG CUDA_VERSION=11.8.0-cudnn8-runtime-ubi8

# s6 from https://github.com/linuxserver/docker-baseimage-fedora/blob/master/Dockerfile
FROM localhost/rootfs-stage:latest AS rootfs-stage

FROM docker.io/nvidia/cuda:$CUDA_VERSION
ARG CODE_VERSION=4.18.0
ARG HELM_VERSION=3.13.1
ARG USER=podman
ARG UID=1000
ARG ARCH=amd64

COPY --from=rootfs-stage /root-out/ /
COPY custom.repo /etc/yum.repos.d/

RUN set -x \
  \
  && rpm --setcaps shadow-utils 2>/dev/null \
  && dnf install -y --setopt=install_weak_deps=False --best \
    podman \
    podman-plugins \
    containernetworking-plugins \
    netavark \
    aardvark-dns \
    crun \
    sudo \
    fuse-overlayfs \
    git-core \
    iproute \
    gzip \
    tar \
    xz \
    jq \
    procps-ng \
    which \
    lsof \
    strace \
    https://github.com/coder/code-server/releases/download/v$CODE_VERSION/code-server-$CODE_VERSION-$ARCH.rpm \
    kubectl \
    conda \
    rsync \
    unar \
    unzip \
  --exclude \
    container-selinux \
  && dnf autoremove -y \
  && dnf clean all \
  && rm -rf /var/cache /var/log/dnf* /var/log/yum.* \
  \
  && curl -L -o helm.tar.gz https://get.helm.sh/helm-v$HELM_VERSION-linux-$ARCH.tar.gz \
  && tar xzf helm.tar.gz -C /usr/bin --strip-components=1 linux-$ARCH/helm \
  && rm helm.tar.gz \
  \
  && curl -L https://dl.min.io/client/mc/release/linux-amd64/mc -o /usr/local/bin/mc \
  && chmod +x /usr/local/bin/mc \
  \
  && ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d \
  && echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel

COPY /root /

ENV \
  S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
  S6_VERBOSITY=1 \
  USER=podman \
  UID=1000 \
  HOME=/home/podman \
  LANG=C.UTF-8 \
  CODE_PORT=8080

ENTRYPOINT ["/init"]
