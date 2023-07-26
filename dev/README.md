### Image build

```bash
ALPINE_VERSION=latest
CODE_VERSION=4.14.1
USER=podman
TAG=ghcr.io/randomcoww/dev:$(date -u +'%Y%m%d').4

podman build \
  --build-arg ALPINE_VERSION=$ALPINE_VERSION \
  --build-arg CODE_VERSION=$CODE_VERSION \
  --build-arg USER=$USER \
  -f alpine.Containerfile \
  -t $TAG . && \

podman push $TAG
```