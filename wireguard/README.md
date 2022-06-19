### Image build

```
mkdir -p build
export TMPDIR=$(pwd)/build

VERSION=latest

podman build \
  -f Dockerfile \
  -t ghcr.io/randomcoww/wireguard:$VERSION
```

```
podman push ghcr.io/randomcoww/wireguard:$VERSION
```