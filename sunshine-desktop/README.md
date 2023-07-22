### Image build

```bash
FEDORA_VERSION=38
SUNSHINE_VERSION=0.20.0
USER=podman
TAG=ghcr.io/randomcoww/sunshine-desktop:$(date -u +'%Y%m%d').1

podman build \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  --build-arg SUNSHINE_VERSION=$SUNSHINE_VERSION \
  --build-arg USER=$USER \
  -t $TAG . && \

podman push $TAG
```