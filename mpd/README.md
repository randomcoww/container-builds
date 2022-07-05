### Image build

```
VERSION=0.23
PATCH=7
TAG=ghcr.io/randomcoww/mpd:$VERSION.$PATCH

buildah build \
  --dns 9.9.9.9 \
  --build-arg VERSION=$VERSION \
  --build-arg PATCH=$PATCH \
  -t $TAG && \

buildah push $TAG
```
