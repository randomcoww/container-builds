### Image build

#### Build binaries

```bash
mkdir -p tmp
GO_VERSION=1.21
VERSION=v1.29.1

TMPDIR=$(pwd)/tmp podman build \
  --build-arg VERSION=$VERSION \
  --build-arg GO_VERSION=$GO_VERSION \
  -f base.Containerfile \
  -t ghcr.io/randomcoww/kubernetes:base-$VERSION
```

#### Kubernetes components

```bash
TMPDIR=$(pwd)/tmp podman build \
  --build-arg VERSION=$VERSION \
  --target kube-master \
  -t ghcr.io/randomcoww/kubernetes:kube-master-$VERSION . && \

TMPDIR=$(pwd)/tmp podman build \
  --build-arg VERSION=$VERSION \
  --target kube-proxy \
  -t ghcr.io/randomcoww/kubernetes:kube-proxy-$VERSION . && \

TMPDIR=$(pwd)/tmp podman push ghcr.io/randomcoww/kubernetes:kube-master-$VERSION && \
TMPDIR=$(pwd)/tmp podman push ghcr.io/randomcoww/kubernetes:kube-proxy-$VERSION
```
