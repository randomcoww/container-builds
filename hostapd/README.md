### Image build

```
VERSION=latest
TAG=ghcr.io/randomcoww/hostapd:$VERSION

buildah build \
  --build-arg VERSION=$VERSION \
  -t $TAG && \

buildah push $TAG
```
