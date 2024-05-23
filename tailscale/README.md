Tailscale without legacy iptables dependency

### Image build

```bash
VERSION=1.66.4
TAG=ghcr.io/randomcoww/tailscale:$VERSION

git clone -b v$VERSION https://github.com/tailscale/tailscale.git

podman build \
  -f tailscale/Dockerfile \
  --target build-env \
  -t tailscale-build

podman build \
  -t $TAG . && \

podman push $TAG
```
