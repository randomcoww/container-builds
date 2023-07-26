### Image build

```bash
ALPINE_VERSION=latest
FEDORA_VERSION=latest
CODE_VERSION=4.14.1
USER=podman
TAG=ghcr.io/randomcoww/dev:$(date -u +'%Y%m%d').5

podman build \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  --build-arg CODE_VERSION=$CODE_VERSION \
  --build-arg USER=$USER \
  -f fedora.Containerfile \
  -t $TAG . && \

podman push $TAG
```