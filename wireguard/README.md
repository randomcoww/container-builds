### Image build

```bash
VERSION=latest
TAG=ghcr.io/randomcoww/wireguard:$(date -u +'%Y%m%d')

podman build \
  --build-arg VERSION=$VERSION \
  -t $TAG && \

podman push $TAG
```