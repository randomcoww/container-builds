FROM alpine:edge

RUN set -x \
  \
  && apk add --no-cache \
	  transmission-daemon \
	  transmission-cli

COPY remove-completed.sh /
ENTRYPOINT ["transmission-daemon", "--foreground"]