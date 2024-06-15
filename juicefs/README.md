### Image build

```bash
JFS_VERSION=$(curl -s https://api.github.com/repos/juicedata/juicefs/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')
TAG=ghcr.io/randomcoww/juicefs:$JFS_VERSION

podman build \
  --arch amd64 \
  --build-arg JFS_VERSION=$JFS_VERSION \
  -t $TAG . && \

podman push $TAG
```
