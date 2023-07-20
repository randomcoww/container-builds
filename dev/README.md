### Image build

```bash
VERSION=4.14.1
TAG=ghcr.io/randomcoww/dev:$(date -u +'%Y%m%d')

buildah build \
  --build-arg VERSION=$VERSION \
  -t $TAG && \

buildah push $TAG
```