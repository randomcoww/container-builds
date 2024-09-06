### Image build

```bash
mkdir -p tmp
TARGETARCH=amd64
S6_OVERLAY_VERSION=$(curl -s https://api.github.com/repos/just-containers/s6-overlay/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')
CODE_VERSION=$(curl -s https://api.github.com/repos/coder/code-server/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')
TAG=ghcr.io/randomcoww/code-server:tensorflow-$(date -u +'%Y%m%d').4

TMPDIR=$(pwd)/tmp podman build \
  --arch $TARGETARCH \
  --build-arg TARGETARCH=$TARGETARCH \
  --build-arg S6_OVERLAY_VERSION=$S6_OVERLAY_VERSION \
  --build-arg CODE_VERSION=$CODE_VERSION \
  -t $TAG . && \

TMPDIR=$(pwd)/tmp podman push $TAG
```

#### Tensorflow setup

```bash
conda create --name tf -c conda-forge python=3.11
conda activate tf
pip install --upgrade pip setuptools wheel
pip install --upgrade tensorflow[and-cuda]==2.16.1
```

```python
import tensorflow as tf
print(tf.config.list_physical_devices('GPU'))
```