### Image build

```bash
VERSION=2.4.0
TAG=ghcr.io/randomcoww/kea:$VERSION

podman build \
  --build-arg VERSION=$VERSION \
  -t $TAG . && \

podman push $TAG
```
