### Image build

```
VERSION=v0.15.0
TAG=ghcr.io/randomcoww/flannel:$VERSION

podman build \
  --build-arg VERSION=$VERSION \
  -f Dockerfile \
  -t localtemp

container=$(buildah from localtemp)
buildah run --net=none $container -- rm /etc/hosts
buildah commit $container $TAG

buildah push $TAG
```