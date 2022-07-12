### Image build

```
VERSION=latest
TAG=ghcr.io/randomcoww/wireguard:$VERSION

buildah build \
  -t $TAG && \

buildah push $TAG
```