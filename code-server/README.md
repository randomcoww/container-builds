### Image build

```bash
mkdir -p tmp
TARGETARCH=amd64
S6_OVERLAY_VERSION=$(curl -s https://api.github.com/repos/just-containers/s6-overlay/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')
CODE_VERSION=$(curl -s https://api.github.com/repos/coder/code-server/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')
HELM_VERSION=$(curl -s https://api.github.com/repos/helm/helm/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')
CUDA_IMAGE_TAG="12.2.2-cudnn8-runtime-rockylinux9"

TAG=ghcr.io/randomcoww/code-server:$(date -u +'%Y%m%d').1-tensorflow

TMPDIR=$(pwd)/tmp podman build \
  --build-arg TARGETARCH=$TARGETARCH \
  --build-arg S6_OVERLAY_VERSION=$S6_OVERLAY_VERSION \
  --build-arg CODE_VERSION=$CODE_VERSION \
  -f tensorflow.Containerfile \
  -t $TAG && \

TMPDIR=$(pwd)/tmp podman push $TAG
```