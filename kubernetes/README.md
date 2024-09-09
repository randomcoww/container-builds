### Image build

#### Build binaries

```bash
GO_VERSION=1.22
VERSION=$(curl -s https://api.github.com/repos/kubernetes/kubernetes/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')
TARGETARCH=amd64

podman build \
  --arch $TARGETARCH \
  --build-arg VERSION=$VERSION \
  --build-arg GO_VERSION=$GO_VERSION \
  -f base.Containerfile \
  -t ghcr.io/randomcoww/kubernetes:base-$VERSION
```

#### Kubernetes components

```bash
podman build \
  --arch $TARGETARCH \
  --build-arg VERSION=$VERSION \
  --target kube-master \
  -t ghcr.io/randomcoww/kubernetes:kube-master-$VERSION . && \

podman build \
  --arch $TARGETARCH \
  --build-arg VERSION=$VERSION \
  --target kube-proxy \
  -t ghcr.io/randomcoww/kubernetes:kube-proxy-$VERSION . && \

podman push ghcr.io/randomcoww/kubernetes:kube-master-$VERSION && \
podman push ghcr.io/randomcoww/kubernetes:kube-proxy-$VERSION
```
