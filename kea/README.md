### Image build

```bash
VERSION=$(curl -s https://api.github.com/repos/isc-projects/kea/tags | jq -r 'first(.[] | select(.name | startswith("Kea-"))).name' | tr -d 'Kea-')
# Stable release
VERSION=2.6.1
TAG=ghcr.io/randomcoww/kea:$VERSION
TARGETARCH=amd64

podman build \
  --arch $TARGETARCH \
  --build-arg VERSION=$VERSION \
  -t $TAG .

podman push $TAG
```
