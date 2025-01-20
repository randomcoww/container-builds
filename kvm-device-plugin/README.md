### Image build

```bash
VERSION=main
TAG=ghcr.io/randomcoww/kvm-device-plugin:$VERSION
TARGETARCH=amd64

podman build \
  --arch $TARGETARCH \
  --build-arg VERSION=$VERSION \
  -t $TAG .

podman push $TAG
```
