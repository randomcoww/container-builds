### Image build

```bash
TAG=ghcr.io/randomcoww/wireguard:$(date -u +'%Y%m%d')
TARGETARCH=amd64

podman build \
  --arch $TARGETARCH \
  -t $TAG .

podman push $TAG
```