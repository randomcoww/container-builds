### Image build

```bash
VERSION=latest
TAG=ghcr.io/randomcoww/wireguard:$(date -u +'%Y%m%d')

buildah build \
  --build-arg VERSION=$VERSION \
  -t $TAG && \

buildah push $TAG
```