### Image build

```bash
mkdir -p tmp
FEDORA_VERSION=39
CODE_VERSION=4.19.1
HELM_VERSION=3.13.2
TAG=ghcr.io/randomcoww/code-server:$(date -u +'%Y%m%d').3-tensorflow
```

S6 base image

```bash
git clone -b master https://github.com/linuxserver/docker-baseimage-fedora.git

TMPDIR=$(pwd)/tmp podman build \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  --target rootfs-stage \
  -f docker-baseimage-fedora/Dockerfile \
  -t rootfs-stage:$FEDORA_VERSION
```

UBI8 With CUDA and cuDNN support for tensorflow

```bash

TMPDIR=$(pwd)/tmp podman build \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  --build-arg CODE_VERSION=$CODE_VERSION \
  --build-arg HELM_VERSION=$HELM_VERSION \
  -t $TAG . && \

TMPDIR=$(pwd)/tmp podman push $TAG
```

Setup tensorflow in environment https://www.tensorflow.org/install/pip

Create conda environment:

Open [env.ipynb](env.ipynb)

1. Select kernel
2. Python environments
3. Create python environment
4. Conda
5. Select project path
6. Select Python 3.11
