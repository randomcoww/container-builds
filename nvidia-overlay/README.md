### Nvidia driver overlay

```bash
KERNEL_VERSION=6.4.15-200.fc38.x86_64
TAG=ghcr.io/randomcoww/nvidia-kmod:$KERNEL_VERSION

mkdir -p tmp
TMPDIR=$(pwd)/tmp podman build \
  --build-arg KERNEL_VERSION=$KERNEL_VERSION \
  -f kmod.Containerfile \
  -t $TAG .

mkdir -p usr
podman run --rm \
  -v $(pwd)/usr:/mnt \
  $TAG cp -r /opt/. /mnt
```

```bash
TAG=ghcr.io/randomcoww/nvidia-patch:latest

mkdir -p tmp
TMPDIR=$(pwd)/tmp podman build \
  -f patch.Containerfile \
  -t $TAG .

mkdir -p usr
podman run --rm \
  -v $(pwd)/usr:/mnt \
  $TAG cp -r /opt/. /mnt
```