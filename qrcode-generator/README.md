## QR code renderer

Based on https://github.com/bizzycola/qrcode-generator

### Image build

```bash
TAG=ghcr.io/randomcoww/qrcode-generator:$(date -u +'%Y%m%d').3
TARGETARCH=amd64

podman build \
  --arch $TARGETARCH \
  -t $TAG .

podman push $TAG
```