### Image build

```bash
TAG=ghcr.io/randomcoww/transmission:$(date -u +'%Y%m%d').1

podman build \
  --arch amd64 \
  -t $TAG . && \

podman push $TAG
```
