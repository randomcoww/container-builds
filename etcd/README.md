### Image build

```
VERSION=v3.5.4
GO_VERSION=1.18
TAG=ghcr.io/randomcoww/etcd:$VERSION

buildah build \
  --dns 9.9.9.9 \
  --build-arg VERSION=$VERSION \
  --build-arg GO_VERSION=$GO_VERSION \
  -f Dockerfile \
  -t $TAG && \

buildah push $TAG
```