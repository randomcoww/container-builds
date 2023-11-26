### Image build

```bash
mkdir -p tmp
FEDORA_VERSION=38
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
  -t $TAG . && \

TMPDIR=$(pwd)/tmp podman push $TAG
```
