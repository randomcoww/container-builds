# based on https://github.com/containers/podman/blob/main/contrib/podmanimage/stable/Containerfile
# replace iptables-legacy with iptables-nft
ARG FEDORA_VERSION=latest

FROM registry.fedoraproject.org/fedora:$FEDORA_VERSION
ARG CODE_VERSION=4.14.1
ARG USER=podman
ARG ARCH=amd64

RUN set -x \
  \
  && rpm --setcaps shadow-utils 2>/dev/null \
  && dnf install -y --setopt=install_weak_deps=False --best \
    ca-certificates \
    podman \
    fuse-overlayfs \
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
    ldns-utils \
    https://github.com/coder/code-server/releases/download/v$CODE_VERSION/code-server-$CODE_VERSION-$ARCH.rpm \
  --exclude \
    container-selinux \
  && dnf autoremove -y \
  && dnf clean all \
  && rm -rf /var/cache /var/log/dnf* /var/log/yum.* \
  \
  && useradd $USER -m -u 1000 \
  && echo -e "$USER:1:999" > /etc/subuid \
	&& echo -e "$USER:1001:64535" >> /etc/subuid \
  && echo -e "$USER:1:999" > /etc/subgid \
	&& echo -e "$USER:1001:64535" >> /etc/subgid \
  && usermod -G wheel $USER \
  && echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel

COPY containers.conf /etc/containers/containers.conf.d/10-override.conf
COPY storage.conf /etc/containers/storage.conf.d/10-override.conf

USER $USER
ENTRYPOINT [ "code-server" ]
