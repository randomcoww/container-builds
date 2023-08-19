## Kasm desktop with Sunshine for alternate stream

### Image build

```bash
FEDORA_VERSION=38
SUNSHINE_VERSION=0.20.0
TAG=ghcr.io/randomcoww/kasm-desktop:$(date -u +'%Y%m%d').1
USER=kasm_user

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

### Run

- Device passthrough is not working in rootless for me
- `CAP_SYS_ADMIN` is for Sunshine error with `cap_sys_admin+p sunshine`

```bash
mkdir -p kasm-home

sudo podman run -it --name kasm --rm --security-opt label=disable \
  --name kasm-desktop \
  --cap-add CAP_SYS_ADMIN \
  -e USER=$USER \
  -e HOME=/home/$USER \
  -e UID=10000 \
  -v $(pwd)/kasm-home:/home/$USER \
  --shm-size=1g \
  --device /dev/dri \
  --device /dev/kfd \
  -p 6901:6901/tcp \
  -p 47984-47990:47984-47990/tcp \
  -p 48010:48010/tcp \
  -p 48010:48010/udp \
  -p 47998-48000:47998-48000/udp \
  $TAG

sudo podman stop kasm-desktop
```

### Register sunshine client

```bash
curl http://localhost:47989/pin/<PIN>
```