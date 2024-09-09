### Image build

```bash
VERSION=2.6.1
TAG=ghcr.io/randomcoww/kea:$VERSION
TARGETARCH=amd64

podman build \
  --arch $TARGETARCH \
  --build-arg VERSION=$VERSION \
  -t $TAG .

podman push $TAG
```
