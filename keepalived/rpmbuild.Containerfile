ARG FEDORA_VERSION=39

FROM fedora:${FEDORA_VERSION}

RUN set -x \
  \
  && dnf install -y --setopt=install_weak_deps=False \
    rpmdevtools \
    dnf-plugins-core \
    git \
    libnftnl-devel \
  \
  && mkdir -p $HOME/rpmbuild/ \
  && cd $HOME/rpmbuild \
  && git clone -b f$(rpm -E %fedora) https://src.fedoraproject.org/rpms/keepalived.git SOURCES/ \
  && cd SOURCES \
  && spectool -gR keepalived.spec \
  && dnf builddep -y keepalived.spec \
  && rpmbuild -bb keepalived.spec \
    --without snmp \
    --with nftables \
    --without debug