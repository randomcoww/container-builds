### Image build

```bash
TAG=ghcr.io/randomcoww/wireguard:$(date -u +'%Y%m%d')

podman build \
  -t $TAG . && \

podman push $TAG
```