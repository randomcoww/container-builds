### Image build

```bash
mkdir -p tmp
FEDORA_VERSION=40
CODE_VERSION=$(curl -s https://api.github.com/repos/coder/code-server/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')
HELM_VERSION=$(curl -s https://api.github.com/repos/helm/helm/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')
JFS_VERSION=$(curl -s https://api.github.com/repos/juicedata/juicefs/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')
ARCH=amd64
TAG=ghcr.io/randomcoww/code-server:$(date -u +'%Y%m%d').6
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

Build

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