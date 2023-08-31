### Image build

```bash
FEDORA_VERSION=latest
CODE_VERSION=4.16.1
USER=podman
TAG=ghcr.io/randomcoww/code-server:$(date -u +'%Y%m%d').1

mkdir -p tmp

TMPDIR=$(pwd)/tmp podman build \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  --build-arg CODE_VERSION=$CODE_VERSION \
  --build-arg USER=$USER \
  -t $TAG . && \

podman push $TAG
```