### Image build

```
VERSION=latest
TAG=ghcr.io/randomcoww/hostapd:$VERSION

buildah build \
  --dns 9.9.9.9 \
  --build-arg VERSION=$VERSION \
  -t $TAG && \

buildah push $TAG
```
