### Image build

```bash
CODE_VERSION=4.16.1
USER=podman

mkdir -p tmp
```

```bash
FEDORA_VERSION=latest
TAG=ghcr.io/randomcoww/code-server:$(date -u +'%Y%m%d').1

TMPDIR=$(pwd)/tmp podman build \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  --build-arg CODE_VERSION=$CODE_VERSION \
  --build-arg USER=$USER \
  -f Containerfile \
  -t $TAG . && \

podman push $TAG
```

```bash
CUDA_VERSION=12.1.0-cudnn8-runtime-ubi9
HELM_VERSION=3.12.3
TAG=ghcr.io/randomcoww/code-server:cuda-$(date -u +'%Y%m%d').1

TMPDIR=$(pwd)/tmp podman build \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  --build-arg CODE_VERSION=$CODE_VERSION \
  --build-arg USER=$USER \
  -f cuda.Containerfile \
  -t $TAG . && \

podman push $TAG
```