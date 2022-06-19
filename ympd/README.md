### Image build

```
VERSION=latest

podman build \
  -f Dockerfile \
  -t ghcr.io/randomcoww/ympd:$VERSION
```

```
podman push ghcr.io/randomcoww/ympd:$VERSION
```
