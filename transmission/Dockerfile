FROM alpine:edge

RUN set -x \
  \
  && apk add --no-cache \
	  transmission-daemon \
	  transmission-cli

COPY docker-entrypoint.sh /
COPY remove-completed.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
