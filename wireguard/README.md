### Image build

```
VERSION=latest
TAG=ghcr.io/randomcoww/wireguard:$VERSION

buildah build \
  --dns 9.9.9.9 \
  -t $TAG && \

buildah push $TAG
```