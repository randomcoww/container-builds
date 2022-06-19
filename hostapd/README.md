### Image build

```
VERSION=latest
TAG=ghcr.io/randomcoww/hostapd:$VERSION

buildah build \
  -f Dockerfile \
  -t $TAG

buildah push $TAG
```