Applies noscan patch from

http://copr-dist-git.fedorainfracloud.org/git/dturner/hostapd-noscan/hostapd.git

### Image build

```bash
VERSION=2.11
TAG=ghcr.io/randomcoww/hostapd:$VERSION
TARGETARCH=amd64

podman build \
  --arch $TARGETARCH \
  --build-arg VERSION=$VERSION \
  -t $TAG .

podman push $TAG
```