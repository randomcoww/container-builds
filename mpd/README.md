### Image build

```bash
VERSION=0.23
PATCH=10
TAG=ghcr.io/randomcoww/mpd:$VERSION.$PATCH

buildah build \
  --build-arg VERSION=$VERSION \
  --build-arg PATCH=$PATCH \
  -t $TAG && \

buildah push $TAG
```
