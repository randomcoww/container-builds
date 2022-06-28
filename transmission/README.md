# docker-transmission
Sample usage with openvpn
- Kubernetes: https://github.com/randomcoww/environment-config/blob/master/manifests_extra/transmission

### Image build

```
VERSION=latest
TAG=ghcr.io/randomcoww/transmission:$VERSION

buildah build \
  --dns 9.9.9.9 \
  -t $TAG && \

buildah push $TAG
```