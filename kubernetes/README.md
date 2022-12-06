### Image build

#### Build binaries

```bash
GO_VERSION=1.19
VERSION=v1.25.4

buildah build \
  --build-arg VERSION=$VERSION \
  --build-arg GO_VERSION=$GO_VERSION \
  -f Dockerfile.base \
  -t ghcr.io/randomcoww/kubernetes:base-$VERSION
```

#### Kubernetes components

```bash
buildah build \
  --build-arg VERSION=$VERSION \
  --target kube-master \
  -t ghcr.io/randomcoww/kubernetes:kube-master-$VERSION && \

buildah build \
  --build-arg VERSION=$VERSION \
  --target kube-proxy \
  -t ghcr.io/randomcoww/kubernetes:kube-proxy-$VERSION && \

buildah push ghcr.io/randomcoww/kubernetes:kube-master-$VERSION && \
buildah push ghcr.io/randomcoww/kubernetes:kube-proxy-$VERSION
```
