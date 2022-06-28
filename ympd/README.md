### Image build

```
VERSION=latest
TAG=ghcr.io/randomcoww/ympd:$VERSION

buildah build \
  --dns 9.9.9.9 \
  -f Dockerfile \
  -t $TAG && \

buildah push $TAG
```