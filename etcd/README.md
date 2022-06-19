### Image build

```
VERSION=v3.5.1
GO_VERSION=1.17
TAG=ghcr.io/randomcoww/etcd:$VERSION

buildah build \
  --build-arg VERSION=$VERSION \
  --build-arg GO_VERSION=$GO_VERSION \
  -f Dockerfile \
  -t $TAG

buildah push $TAG
```