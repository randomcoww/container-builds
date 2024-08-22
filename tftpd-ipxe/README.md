### Image build

```bash
VERSION=$(curl -s https://api.github.com/repos/ipxe/shim/releases | jq -r '.[0].tag_name' | tr -d 'v')
TAG=ghcr.io/randomcoww/tftpd-ipxe:$VERSION.3

podman build \
  --build-arg VERSION=$VERSION \
  -t $TAG . && \

podman push $TAG
```