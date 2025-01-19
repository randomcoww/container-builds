### Image build

```bash
TAG=ghcr.io/randomcoww/steamcmd:$(date -u +'%Y%m%d').4
TARGETARCH=amd64

podman build \
  --arch $TARGETARCH \
  --build-arg VERSION=$VERSION \
  -t $TAG .

podman push $TAG
```