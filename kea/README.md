### Image build

```
VERSION=2.0.0
TAG=ghcr.io/randomcoww/kea:$VERSION

buildah build \
  --build-arg VERSION=$VERSION \
  -f Dockerfile \
  -t localtemp

container=$(buildah from localtemp)
buildah run --net=none $container -- rm /etc/hosts
buildah commit $container $TAG

buildah push $TAG
```