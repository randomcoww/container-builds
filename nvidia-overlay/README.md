### Nvidia driver overlay

```bash
KERNEL_VERSION=6.6.10-200.fc39.x86_64
DRIVER_VERSION=545.23.08
TAG=ghcr.io/randomcoww/nvidia-kmod:$KERNEL_VERSION
BUILD_PATH=$HOME/silverblue

mkdir -p tmp
TMPDIR=$(pwd)/tmp podman build \
  --build-arg KERNEL_VERSION=$KERNEL_VERSION \
  --build-arg DRIVER_VERSION=$DRIVER_VERSION \
  -f kmod.Containerfile \
  -t $TAG .

mkdir -p usr
podman run --rm \
  -v $(pwd)/usr:/mnt \
  $TAG cp -r /opt/. /mnt

sudo cp -a usr/. $BUILD_PATH/src/config/overlay.d/02nvidia/usr/
```

```bash
TAG=ghcr.io/randomcoww/nvidia-patch:latest
BUILD_PATH=$HOME/silverblue

mkdir -p tmp
TMPDIR=$(pwd)/tmp podman build \
  -f patch.Containerfile \
  -t $TAG .

mkdir -p usr
podman run --rm \
  -v $(pwd)/usr:/mnt \
  $TAG cp -r /opt/. /mnt

sudo cp -a usr/. $BUILD_PATH/src/config/overlay.d/02nvidia/usr/
```
