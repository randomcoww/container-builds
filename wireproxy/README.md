### Image build

```bash
VERSION=$(curl -s https://api.github.com/repos/pufferffish/wireproxy/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')
TAG=ghcr.io/randomcoww/wireproxy:$VERSION.1
TARGETARCH=amd64

podman build \
  --arch $TARGETARCH \
  --build-arg TARGETARCH=$TARGETARCH \
  --build-arg VERSION=$VERSION \
  -t $TAG .

podman push $TAG
```