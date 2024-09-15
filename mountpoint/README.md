### Image build

```bash
TAG=ghcr.io/randomcoww/mountpoint:$(date -u +'%Y%m%d').4
TARGETARCH=amd64

podman build \
  --arch $TARGETARCH \
  -t $TAG .

podman push $TAG
```
