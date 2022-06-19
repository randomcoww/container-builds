# docker-transmission
Sample usage with openvpn
- Kubernetes: https://github.com/randomcoww/environment-config/blob/master/manifests_extra/transmission

### Image build

```
mkdir -p build
export TMPDIR=$(pwd)/build

VERSION=latest

podman build \
  -f Dockerfile \
  -t ghcr.io/randomcoww/transmission:$VERSION
```

```
podman push ghcr.io/randomcoww/transmission:$VERSION
```