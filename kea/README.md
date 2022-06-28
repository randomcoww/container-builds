### Image build

```
VERSION=2.0.2
TAG=ghcr.io/randomcoww/kea:$VERSION

buildah build \
  --dns 9.9.9.9 \
  --build-arg VERSION=$VERSION \
  -f Dockerfile \
  -t $TAG && \

buildah push $TAG
```