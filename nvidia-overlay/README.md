### Nvidia driver overlay

```bash
KERNEL_VERSION=6.4.12-200.fc38.x86_64
DRIVER_VERSION=535.98
TAG=ghcr.io/randomcoww/nvidia-kmod:$KERNEL_VERSION

mkdir -p tmp
TMPDIR=$(pwd)/tmp podman build \
  --build-arg KERNEL_VERSION=$KERNEL_VERSION \
  -f kmod.Containerfile \
  -t $TAG
```

Deploy to COSA image

```bash
mkdir -p 02nvidia/usr

podman run --rm \
  -v $(pwd)/02nvidia/usr:/mnt \
  $TAG cp -r /opt/. /mnt
```