### Image build

```
VERSION=2.10
TAG=ghcr.io/randomcoww/hostapd:$VERSION

buildah build \
  --build-arg VERSION=$VERSION \
  -t $TAG && \

buildah push $TAG
```
