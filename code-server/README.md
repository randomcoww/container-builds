### Image build

```bash
CODE_VERSION=4.16.1
USER=podman

mkdir -p tmp
```

Fedora

```bash
FEDORA_VERSION=latest
TAG=ghcr.io/randomcoww/code-server:$(date -u +'%Y%m%d').1

TMPDIR=$(pwd)/tmp podman build \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  --build-arg CODE_VERSION=$CODE_VERSION \
  --build-arg USER=$USER \
  -f Containerfile \
  -t $TAG . && \

TMPDIR=$(pwd)/tmp podman push $TAG
```

UBI8 With CUDA and cuDNN support for tensorflow

```bash
CUDA_VERSION=11.8.0-cudnn8-runtime-ubi8
HELM_VERSION=3.12.3
TAG=ghcr.io/randomcoww/code-server:$(date -u +'%Y%m%d').1-tensorflow

TMPDIR=$(pwd)/tmp podman build \
  --build-arg CUDA_VERSION=$CUDA_VERSION \
  --build-arg CODE_VERSION=$CODE_VERSION \
  --build-arg USER=$USER \
  -f tensorflow.Containerfile \
  -t $TAG . && \

TMPDIR=$(pwd)/tmp podman push $TAG
```

Setup tensorflow in environment https://www.tensorflow.org/install/pip

```bash
!python3 --version
!conda install -y -c conda-forge cudatoolkit=11.8.0
!pip install nvidia-cudnn-cu11==8.6.0.163
!pip install tensorflow==2.13.*
```

Verify GPU

```bash
!nvidia-smi
import tensorflow as tf
print(tf.config.list_physical_devices('GPU'))
```