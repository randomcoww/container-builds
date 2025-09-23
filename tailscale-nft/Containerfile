# https://github.com/tailscale/tailscale/blob/main/Dockerfile

ARG VERSION
FROM ghcr.io/tailscale/tailscale:$VERSION AS source

FROM alpine:latest

COPY --from=source /usr/local/bin/tailscale /usr/local/bin/
COPY --from=source /usr/local/bin/tailscaled /usr/local/bin/
COPY --from=source /usr/local/bin/containerboot /usr/local/bin/

RUN set -x \
  \
  && apk add --no-cache \
    ca-certificates \
    iptables \
    iproute2 \
    ip6tables

ENTRYPOINT [ "containerboot" ]