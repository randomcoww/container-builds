Applies patch from

https://github.com/dvdesolve/pkgbuilds/blob/master/packages/hostapd-noscan/noscan.patch

### Image build

```bash
VERSION=2.10
TAG=ghcr.io/randomcoww/hostapd:$VERSION
TARGETARCH=amd64

podman build \
  --arch $TARGETARCH \
  --build-arg VERSION=$VERSION \
  -t $TAG .

podman push $TAG
```