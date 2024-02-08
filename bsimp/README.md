Tailscale without legacy iptables dependency

### Image build

```bash
GO_VERSION=1.21
VERSION=main
TAG=ghcr.io/randomcoww/bsimp:$(date -u +'%Y%m%d').2

podman build \
  --build-arg GO_VERSION=$GO_VERSION \
  --build-arg VERSION=$VERSION \
  -t $TAG . && \

podman push $TAG
```
