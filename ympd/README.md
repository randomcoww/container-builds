### Image build

```
VERSION=latest
TAG=ghcr.io/randomcoww/ympd:$VERSION

buildah build \
  --dns 9.9.9.9 \
  -t $TAG && \

buildah push $TAG
```