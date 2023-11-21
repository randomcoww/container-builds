### Image build

```bash
FEDORA_VERSION=latest
CODE_VERSION=4.18.0

mkdir -p tmp
```

S6 base image

```bash
git clone -b master https://github.com/linuxserver/docker-baseimage-fedora.git

podman build \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  --target rootfs-stage \
  -f docker-baseimage-fedora/Dockerfile \
  -t rootfs-stage
```

UBI8 With CUDA and cuDNN support for tensorflow

```bash
CUDA_VERSION=11.8.0-cudnn8-runtime-ubi8
HELM_VERSION=3.13.1
TAG=ghcr.io/randomcoww/code-server:$(date -u +'%Y%m%d').3-tensorflow

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

!CUDNN_PATH=$(dirname $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)"))
!export LD_LIBRARY_PATH=$CUDNN_PATH/lib:$CONDA_PREFIX/lib/:$LD_LIBRARY_PATH

!mkdir -p $CONDA_PREFIX/etc/conda/activate.d
!echo 'CUDNN_PATH=$(dirname $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)"))' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
!echo 'export LD_LIBRARY_PATH=$CUDNN_PATH/lib:$CONDA_PREFIX/lib/:$LD_LIBRARY_PATH' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh

!pip install --upgrade pip
!pip install tensorflow==2.13.*
```

Verify GPU

```bash
!nvidia-smi
import tensorflow as tf
print(tf.config.list_physical_devices('GPU'))
```
