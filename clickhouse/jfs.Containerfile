ARG CLICKHOUSE_VERSION=head

FROM clickhouse/clickhouse-server:$CLICKHOUSE_VERSION-alpine
ARG JFS_VERSION

RUN set -x \
  \
  && wget -O jfs.tar.gz \
    https://github.com/juicedata/juicefs/releases/download/v$JFS_VERSION/juicefs-$JFS_VERSION-linux-amd64.tar.gz \
  && tar xzf jfs.tar.gz -C /usr/local/bin juicefs \
  && rm jfs.tar.gz \
  && apk add --no-cache \
    fuse \
    s6-overlay