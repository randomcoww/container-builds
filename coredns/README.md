### Image build

CoreDNS with coredns-mdns plugin

```bash
VERSION=$(curl -s https://api.github.com/repos/coredns/coredns/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')
TAG=ghcr.io/randomcoww/coredns:$VERSION
TARGETARCH=amd64

podman build \
  --arch $TARGETARCH \
  --build-arg VERSION=$VERSION \
  -t $TAG .

podman push $TAG
```
