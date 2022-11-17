### Image build

```bash
VERSION=v0.18.1
TAG=ghcr.io/randomcoww/flannel:$VERSION

buildah build \
  --build-arg VERSION=$VERSION \
  -t $TAG && \

buildah push $TAG
```
