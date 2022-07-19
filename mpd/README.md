### Image build

```
VERSION=0.23
PATCH=8
TAG=ghcr.io/randomcoww/mpd:$VERSION.$PATCH-2

buildah build \
  --build-arg VERSION=$VERSION \
  --build-arg PATCH=$PATCH \
  -t $TAG && \

buildah push $TAG
```
