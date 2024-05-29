### Image build

```bash
mkdir -p tmp
FEDORA_VERSION=40

ARCH=amd64
CODE_VERSION=$(curl -s https://api.github.com/repos/coder/code-server/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')
HELM_VERSION=$(curl -s https://api.github.com/repos/helm/helm/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')
JFS_VERSION=$(curl -s https://api.github.com/repos/juicedata/juicefs/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')
```

Build

```bash
TAG=ghcr.io/randomcoww/code-server:$(date -u +'%Y%m%d').8

git clone -b master https://github.com/linuxserver/docker-baseimage-fedora.git

TMPDIR=$(pwd)/tmp podman build \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  --target rootfs-stage \
  -f docker-baseimage-fedora/Dockerfile \
  -t rootfs-stage:$FEDORA_VERSION

TMPDIR=$(pwd)/tmp podman build \
  --build-arg ARCH=$ARCH \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  --build-arg CODE_VERSION=$CODE_VERSION \
  --build-arg HELM_VERSION=$HELM_VERSION \
  --build-arg JFS_VERSION=$JFS_VERSION \
  -f Containerfile \
  -t $TAG && \

TMPDIR=$(pwd)/tmp podman push $TAG
```

GPU build based on Nvidia CUDA container

```bash
TAG=ghcr.io/randomcoww/code-server:$(date -u +'%Y%m%d').10-gpu

TMPDIR=$(pwd)/tmp podman build \
  --build-arg ARCH=$ARCH \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  --build-arg CODE_VERSION=$CODE_VERSION \
  --build-arg HELM_VERSION=$HELM_VERSION \
  --build-arg JFS_VERSION=$JFS_VERSION \
  -f gpu.Containerfile \
  -t $TAG && \

TMPDIR=$(pwd)/tmp podman push $TAG
```

Setup tensorflow in environment https://www.tensorflow.org/install/pip

Open [tfenv.ipynb](tfenv.ipynb)

1. Select kernel
2. Python environments
3. Create python environment
4. Venv
5. Select project path