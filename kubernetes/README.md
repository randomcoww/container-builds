### Image build

#### Build binaries

```
GO_VERSION=1.18
VERSION=v1.24.1

buildah build \
  --dns 9.9.9.9 \
  --build-arg VERSION=$VERSION \
  --build-arg GO_VERSION=$GO_VERSION \
  -f Dockerfile.base \
  -t ghcr.io/randomcoww/kubernetes:base-$VERSION
```

#### Kubernetes components

```
buildah build \
  --dns 9.9.9.9 \
  --build-arg VERSION=$VERSION \
  --target kube-master \
  -t ghcr.io/randomcoww/kubernetes:kube-master-$VERSION && \

buildah build \
  --dns 9.9.9.9 \
  --build-arg VERSION=$VERSION \
  --target kube-proxy \
  -t ghcr.io/randomcoww/kubernetes:kube-proxy-$VERSION && \

buildah build \
  --dns 9.9.9.9 \
  --build-arg VERSION=$VERSION \
  --target kubelet \
  -t ghcr.io/randomcoww/kubernetes:kubelet-$VERSION && \

buildah push ghcr.io/randomcoww/kubernetes:kube-master-$VERSION && \
buildah push ghcr.io/randomcoww/kubernetes:kube-proxy-$VERSION && \
buildah push ghcr.io/randomcoww/kubernetes:kubelet-$VERSION
```
