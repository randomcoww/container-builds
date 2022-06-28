### Image build

```
VERSION=v0.18.1
TAG=ghcr.io/randomcoww/flannel:$VERSION

podman build \
  --dns 9.9.9.9 \
  --build-arg VERSION=$VERSION \
  -t $TAG && \

buildah push $TAG
```