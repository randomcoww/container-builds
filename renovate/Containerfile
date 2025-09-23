ARG VERSION
FROM ghcr.io/renovatebot/renovate:$VERSION

ARG INTERNAL_CA_CERT

# https://docs.renovatebot.com/examples/self-hosting/#self-signed-tlsssl-certificates
# Changes to the certificate authority require root permissions
USER root

# Copy and install the self signed certificate
RUN set -x \
  \
  && mkdir -p /usr/local/share/ca-certificates/ \
  && echo -e "$INTERNAL_CA_CERT" > /usr/local/share/ca-certificates/self-signed-certificate.crt \
  && update-ca-certificates

# Change back to the Ubuntu user
USER 12021

# OpenSSL
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt