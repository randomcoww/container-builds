### Image build

```bash
FEDORA_VERSION=38
SUNSHINE_VERSION=0.20.0
TAG=ghcr.io/randomcoww/sunshine-desktop:$(date -u +'%Y%m%d').1

git clone -b fedora$FEDORA_VERSION https://github.com/linuxserver/docker-baseimage-kasmvnc.git

podman build \
  --target buildstage \
  -f docker-baseimage-kasmvnc/Dockerfile \
  -t buildstage

git clone -b master https://github.com/linuxserver/docker-baseimage-fedora.git

podman build \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  --target rootfs-stage \
  -f docker-baseimage-fedora/Dockerfile \
  -t rootfs-stage

podman build \
  --build-arg SUNSHINE_VERSION=$SUNSHINE_VERSION \
  -t $TAG . && \

podman push $TAG
```

```bash
podman run -it --name kasm --rm \
  -e USER=kasm_user \
  -e HOME=/home/kasm_user \
  -e UID=10000 \
  --shm-size=1g \
  --device /dev/dri/card0 \
  --device /dev/dri/renderD128 \
  -p 6901:6901/tcp \
  -p 47984-47990:47984-47990/tcp \
  -p 48010:48010/tcp \
  -p 48010:48010/udp \
  -p 47998-48000:47998-48000/udp \
  $TAG
```