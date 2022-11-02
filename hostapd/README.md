Applies patch from

https://github.com/dvdesolve/pkgbuilds/blob/master/packages/hostapd-noscan/noscan.patch

### Image build

```
VERSION=2.10
TAG=ghcr.io/randomcoww/hostapd:$VERSION

buildah build \
  --build-arg VERSION=$VERSION \
  -t $TAG && \

buildah push $TAG
```
