### Image build

#### Build binaries

```
GO_VERSION=1.18
VERSION=v1.24.1

buildah build \
  --net=container \
  --build-arg VERSION=$VERSION \
  --build-arg GO_VERSION=$GO_VERSION \
  -f Dockerfile.base \
  -t ghcr.io/randomcoww/kubernetes:base-$VERSION
```

#### Kubernetes components

```
VERSION=v1.24.1

buildah build \
  --net=container \
  --build-arg VERSION=$VERSION \
  --target kube-master \
  -t ghcr.io/randomcoww/kubernetes:kube-master-$VERSION

buildah build \
  --net=container \
  --build-arg VERSION=$VERSION \
  --target kube-proxy \
  -t kube-proxy-temp

container=$(buildah from kube-proxy-temp)
buildah run --net=none $container -- rm -f /etc/hosts
buildah commit $container ghcr.io/randomcoww/kubernetes:kube-proxy-$VERSION

buildah build \
  --net=container \
  --build-arg VERSION=$VERSION \
  --target kubelet \
  -t kubelet-temp

container=$(buildah from kubelet-temp)
buildah run --net=none $container -- rm -f /etc/hosts
buildah commit $container ghcr.io/randomcoww/kubernetes:kubelet-$VERSION

buildah push ghcr.io/randomcoww/kubernetes:kube-master-$VERSION
buildah push ghcr.io/randomcoww/kubernetes:kube-proxy-$VERSION
buildah push ghcr.io/randomcoww/kubernetes:kubelet-$VERSION
```

#### Kubernetes addon-manager

```
ADDONS_VERSION=master

buildah build \
  --net=container \
  --build-arg VERSION=$VERSION \
  --build-arg ADDONS_VERSION=$ADDONS_VERSION \
  --target addon-manager \
  -t ghcr.io/randomcoww/kubernetes-addon-manager:$ADDONS_VERSION

buildah push ghcr.io/randomcoww/kubernetes-addon-manager:$ADDONS_VERSION
```