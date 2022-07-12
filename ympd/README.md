### Image build

```
VERSION=latest
TAG=ghcr.io/randomcoww/ympd:$VERSION

buildah build \
  -t $TAG && \

buildah push $TAG
```