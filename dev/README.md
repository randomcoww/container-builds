### Image build

```bash
FEDORA_VERSION=latest
CODE_VERSION=4.14.1
USER=podman
TAG=ghcr.io/randomcoww/dev:$(date -u +'%Y%m%d').1

buildah build \
  --build-arg CODE_VERSION=$CODE_VERSION \
  --build-arg USER=$USER \
  -t $TAG && \

buildah push $TAG
```