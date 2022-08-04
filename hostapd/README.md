### Image build

```
VERSION=latest
TAG=ghcr.io/randomcoww/hostapd:$(date -u +'%Y%m%d')

buildah build \
  --build-arg VERSION=$VERSION \
  -t $TAG && \

buildah push $TAG
```
