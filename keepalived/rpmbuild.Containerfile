ARG FEDORA_VERSION=38

FROM fedora:latest
ARG KEEPALIVED_VERSION=2.2.8
ARG FEDORA_VERSION=38

RUN set -x \
  \
  && dnf install -y \
    rpm-build \
    dnf-plugins-core \
    git \
    libnftnl-devel \
  \
  && mkdir -p $HOME/rpmbuild/SOURCES/ \
  && cd $HOME/rpmbuild \
  && git clone -b f$FEDORA_VERSION https://src.fedoraproject.org/rpms/keepalived.git SOURCES/ \
  && cd SOURCES \
  && curl https://keepalived.org/software/keepalived-$KEEPALIVED_VERSION.tar.gz -o keepalived-$KEEPALIVED_VERSION.tar.gz \
  && dnf builddep -y keepalived.spec \
  && rpmbuild -bb keepalived.spec \
    --without snmp \
    --with nftables \
    --without debug