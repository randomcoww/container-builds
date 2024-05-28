### Image build

#### Build binaries

```bash
mkdir -p tmp
GO_VERSION=1.21
VERSION=$(curl -s https://api.github.com/repos/kubernetes/kubernetes/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')

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
