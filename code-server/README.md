### Image build

```bash
mkdir -p tmp
FEDORA_VERSION=40
CODE_VERSION=4.20.0
HELM_VERSION=3.14.0
JFS_VERSION=$(curl -s https://api.github.com/repos/juicedata/juicefs/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')
ARCH=amd64
TAG=ghcr.io/randomcoww/code-server:$(date -u +'%Y%m%d').0
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

```bash
TMPDIR=$(pwd)/tmp podman build \
  --build-arg ARCH=$ARCH \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  --build-arg CODE_VERSION=$CODE_VERSION \
  --build-arg HELM_VERSION=$HELM_VERSION \
  --build-arg JFS_VERSION=$JFS_VERSION \
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
