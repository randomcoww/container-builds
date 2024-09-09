### Image build

```bash
TAG=ghcr.io/randomcoww/transmission:$(date -u +'%Y%m%d').1
TARGETARCH=amd64

podman build \
  --arch $TARGETARCH \
  -t $TAG .

podman push $TAG
```
