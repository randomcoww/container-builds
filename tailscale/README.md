Tailscale without legacy iptables dependency

### Image build

```bash
VERSION=$(curl -s https://api.github.com/repos/tailscale/tailscale/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')
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
