### Image build

#### Build binaries

```bash
GO_VERSION=1.20
VERSION=v1.27.1

podman build \
  --build-arg VERSION=$VERSION \
  --build-arg GO_VERSION=$GO_VERSION \
  -f base.Containerfile \
  -t ghcr.io/randomcoww/kubernetes:base-$VERSION
```

#### Kubernetes components

```bash
podman build \
  --build-arg VERSION=$VERSION \
  --target kube-master \
  -t ghcr.io/randomcoww/kubernetes:kube-master-$VERSION && \

podman build \
  --build-arg VERSION=$VERSION \
  --target kube-proxy \
  -t ghcr.io/randomcoww/kubernetes:kube-proxy-$VERSION && \

podman push ghcr.io/randomcoww/kubernetes:kube-master-$VERSION && \
podman push ghcr.io/randomcoww/kubernetes:kube-proxy-$VERSION
```
