Tailscale without legacy iptables dependency

### Image build

```bash
GO_VERSION=1.20
VERSION=1.44.0
TAG=ghcr.io/randomcoww/tailscale:$VERSION

podman build \
  --build-arg GO_VERSION=$GO_VERSION \
  --build-arg VERSION=$VERSION \
  -t $TAG && \

podman push $TAG
```
