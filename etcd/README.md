### Image build

```bash
GO_VERSION=1.19
VERSION=v3.5.6
TAG=ghcr.io/randomcoww/etcd:$VERSION

buildah build \
  --build-arg VERSION=$VERSION \
  --build-arg GO_VERSION=$GO_VERSION \
  -t $TAG && \

buildah push $TAG
```
