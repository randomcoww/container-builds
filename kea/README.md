### Image build

```bash
VERSION=2.2.0
TAG=ghcr.io/randomcoww/kea:$VERSION

buildah build \
  --build-arg VERSION=$VERSION \
  -t $TAG && \

buildah push $TAG
```
