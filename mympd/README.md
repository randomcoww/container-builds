### Image build

```bash
VERSION=v10.1.5
TAG=ghcr.io/randomcoww/mympd:$VERSION

buildah build \
  --build-arg VERSION=$VERSION \
  -t $TAG && \

buildah push $TAG
```
