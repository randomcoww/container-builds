### Image build

Clickhouse with JFS

```bash
CLICKHOUSE_VERSION=$(curl -s https://api.github.com/repos/clickhouse/clickhouse/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v' | cut -d "-" -f 1)
JFS_VERSION=$(curl -s https://api.github.com/repos/juicedata/juicefs/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')

TAG=ghcr.io/randomcoww/clickhouse:$CLICKHOUSE_VERSION.4

podman build \
  --arch amd64 \
  --build-arg CLICKHOUSE_VERSION=$CLICKHOUSE_VERSION \
  --build-arg JFS_VERSION=$JFS_VERSION \
  -f jfs.Containerfile \
  -t $TAG && \

podman push $TAG
```
