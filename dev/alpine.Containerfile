ARG ALPINE_VERSION=edge
FROM alpine:$ALPINE_VERSION

ARG CODE_VERSION=4.14.1
ARG ARCH=amd64
ARG USER=podman

RUN set -x \
  \
  && apk add --no-cache \
    ca-certificates \
    gcompat \
    bash \
    sudo \
    git \
    openssh-client \
    iptables \
    gzip \
    tar \
    xz \
    jq \
    drill \
    podman \
    fuse-overlayfs \
    libstdc++ \
  \
  && adduser -D -u 1000 $USER -s /bin/bash \
  && echo -e "$USER:1:999" > /etc/subuid \
	&& echo -e "$USER:1001:64535" >> /etc/subuid \
  && echo -e "$USER:1:999" > /etc/subgid \
	&& echo -e "$USER:1001:64535" >> /etc/subgid \
  && addgroup $USER wheel \
  && mkdir -p /etc/sudoers.d \
  && echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel \
  \
  && mkdir -p /opt/code-server \
  && wget -O code-server.tar.gz \
    https://github.com/cdr/code-server/releases/download/v$CODE_VERSION/code-server-$CODE_VERSION-linux-$ARCH.tar.gz \
  && tar xzf code-server.tar.gz --strip-components=1 -C /opt/code-server \
  && rm code-server.tar.gz

COPY containers.conf /etc/containers/containers.conf.d/10-override.conf
COPY storage.conf /etc/containers/storage.conf.d/10-override.conf

USER $USER
ENTRYPOINT [ "/opt/code-server/bin/code-server" ]