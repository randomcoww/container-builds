FROM alpine:edge

RUN set -x \
  \
  && apk add --no-cache \
    s3fs-fuse

ENTRYPOINT ["s3fs", "-f"]