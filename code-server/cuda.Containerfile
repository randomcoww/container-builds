FROM docker.io/tensorflow/tensorflow:latest-gpu
ARG CODE_VERSION=4.16.1
ARG USER=podman
ARG UID=1000
ARG ARCH=amd64

RUN set -x \
  \
  && curl -o code-server.deb -fOL https://github.com/coder/code-server/releases/download/v$CODE_VERSION/code-server_${CODE_VERSION}_${ARCH}.deb \
  && dpkg -i code-server.deb \
  && rm code-server.deb \
  \
  && curl https://repo.anaconda.com/pkgs/misc/gpgkeys/anaconda.asc | gpg --dearmor > conda.gpg \
  && install -o root -g root -m 644 conda.gpg /usr/share/keyrings/conda-archive-keyring.gpg \
  && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/conda-archive-keyring.gpg] https://repo.anaconda.com/pkgs/misc/debrepo/conda stable main" > /etc/apt/sources.list.d/conda.list \
  \
  && apt update \
  && apt install -y \
    sudo \
    conda \
    vim-tiny \
  \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  \
  && useradd $USER -m -u $UID -s /usr/bin/bash \
  && echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER \
  && ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d

COPY /root /

USER $USER
ENTRYPOINT [ "code-server" ]