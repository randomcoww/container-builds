FROM alpine:latest

RUN set -x \
  \
  && apk add --no-cache \
	  transmission-daemon \
	  transmission-cli \
    curl \
    jq

ENTRYPOINT ["transmission-daemon", "--foreground"]