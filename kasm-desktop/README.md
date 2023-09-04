### Image build

```bash
FEDORA_VERSION=38
TAG=ghcr.io/randomcoww/kasm-desktop:$(date -u +'%Y%m%d').3

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
  -t $TAG . && \

podman push $TAG
```

### Run

Flatpak issues:
- https://discussion.fedoraproject.org/t/cannot-run-flatpaks-in-a-fedora-container/73867
- https://github.com/flatpak/flatpak/issues/5076

Use custom flatpak build without malcontent [here](../flatpak)

```bash
mkdir -p tmp
TMPDIR=$(pwd)/tmp podman pull $TAG

mkdir -p kasm-home
USER=kasm-user
UID="10000"

podman run -it --rm --security-opt label=disable \
  --name kasm-desktop \
  --cap-add CAP_AUDIT_WRITE \
  -e USER=$USER \
  -e HOME=/home/$USER \
  -e UID=$UID \
  -e XDG_RUNTIME_DIR=/run/user/$UID \
  -e DISPLAY=:1 \
  -e DEVICE=/dev/dri/renderD128 \
  -v $(pwd)/kasm-home:/home/$USER \
  --shm-size=1g \
  --device /dev/dri/renderD128 \
  --device /dev/dri/card0 \
  -p 6901:6901/tcp \
  $TAG

podman stop kasm-desktop
```