### Image build

```
VERSION=latest
TAG=ghcr.io/randomcoww/ympd:$(date -u +'%Y%m%d')

buildah build \
  -t $TAG && \

buildah push $TAG
```