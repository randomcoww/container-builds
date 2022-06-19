### Image build

```
GO_VERSION=1.17
VERSION=v1.23.3

buildah build \
  --build-arg VERSION=$VERSION \
  --build-arg GO_VERSION=$GO_VERSION \
  -f Dockerfile.base \
  -t ghcr.io/randomcoww/kubernetes:base-$VERSION

buildah build \
  --build-arg VERSION=$VERSION \
  -f Dockerfile.kube-master \
  -t ghcr.io/randomcoww/kubernetes:kube-master-$VERSION

buildah build \
  --build-arg VERSION=$VERSION \
  -f Dockerfile.kube-proxy \
  -t kube-proxy-temp

container=$(buildah from kube-proxy-temp)
buildah run --net=none $container -- rm -f /etc/hosts
buildah commit $container ghcr.io/randomcoww/kubernetes:kube-proxy-$VERSION

buildah build \
  --build-arg VERSION=$VERSION \
  -f Dockerfile.kubelet \
  -t kubelet-temp

container=$(buildah from kubelet-temp)
buildah run --net=none $container -- rm -f /etc/hosts
buildah commit $container ghcr.io/randomcoww/kubernetes:kubelet-$VERSION
```

```
buildah push ghcr.io/randomcoww/kubernetes:kube-master-$VERSION
buildah push ghcr.io/randomcoww/kubernetes:kube-proxy-$VERSION
buildah push ghcr.io/randomcoww/kubernetes:kubelet-$VERSION
```

#### Addon-manager

```
VERSION=master
KUBECTL_VERSION=v1.23.3

buildah build \
  --build-arg VERSION=$VERSION \
  --build-arg KUBECTL_VERSION=$KUBECTL_VERSION \
  -f Dockerfile.addon-manager \
  -t ghcr.io/randomcoww/kubernetes-addon-manager:$VERSION

buildah push ghcr.io/randomcoww/kubernetes-addon-manager:$VERSION
```