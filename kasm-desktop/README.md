### Image build

```bash
mkdir -p tmp
FEDORA_VERSION=39
HELM_VERSION=3.13.2
SUNSHINE_VERSION=0.21.0
HEROIC_VERSION=2.11.0
TAG=ghcr.io/randomcoww/kasm-desktop:$(date -u +'%Y%m%d').3

git clone -b fedora$FEDORA_VERSION https://github.com/linuxserver/docker-baseimage-kasmvnc.git

TMPDIR=$(pwd)/tmp podman build \
  --target buildstage \
  -f docker-baseimage-kasmvnc/Dockerfile \
  -t buildstage

git clone -b master https://github.com/linuxserver/docker-baseimage-fedora.git

TMPDIR=$(pwd)/tmp podman build \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  --target rootfs-stage \
  -f docker-baseimage-fedora/Dockerfile \
  -t rootfs-stage

TMPDIR=$(pwd)/tmp podman build \
  --build-arg SUNSHINE_VERSION=$SUNSHINE_VERSION \
  --build-arg HELM_VERSION=$HELM_VERSION \
  --build-arg HEROIC_VERSION=$HEROIC_VERSION \
  -t $TAG . && \

TMPDIR=$(pwd)/tmp podman push $TAG
```
