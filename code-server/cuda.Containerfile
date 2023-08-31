ARG CUDA_VERSION=12.1.0-cudnn8-runtime-ubi9

FROM docker.io/nvidia/cuda:$CUDA_VERSION
ARG CODE_VERSION=4.16.1
ARG HELM_VERSION=3.12.3
ARG USER=podman
ARG UID=1000
ARG ARCH=amd64

COPY custom.repo /etc/yum.repos.d/

RUN set -x \
  \
  && rpm --setcaps shadow-utils 2>/dev/null \
  && dnf install -y --setopt=install_weak_deps=False --best \
    podman \
    sudo \
    fuse-overlayfs \
    git-core \
    iproute \
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
    # kube client
    kubectl \
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
  && useradd $USER -m -u $UID \
  && echo -e "$USER:100000:65536" | tee /etc/subuid /etc/subgid \
  && usermod -G wheel $USER \
  && echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel

COPY /root /

USER $USER
ENTRYPOINT [ "code-server" ]