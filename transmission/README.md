### Image build

```
VERSION=latest
TAG=ghcr.io/randomcoww/transmission:$VERSION

buildah build \
  -t $TAG && \

buildah push $TAG
```