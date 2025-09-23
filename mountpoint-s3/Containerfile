FROM registry.fedoraproject.org/fedora-minimal:latest

ARG VERSION
ARG INTERNAL_CA_CERT

RUN set -x \
  \
  && mkdir -p /etc/pki/ca-trust/source/anchors \
  && echo -e "$INTERNAL_CA_CERT" > /etc/pki/ca-trust/source/anchors/ca-cert.pem \
  && update-ca-trust \
  && microdnf install -y \
    https://s3.amazonaws.com/mountpoint-s3-release/$VERSION/$(arch)/mount-s3-$VERSION-$(arch).rpm \
  && microdnf clean all \
  && rm -rf \
    /var/cache \
    /var/log/*
