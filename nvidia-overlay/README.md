### Nvidia driver overlay

```bash
KERNEL_VERSION=6.4.11-200.fc38.x86_64
DRIVER_VERSION=535.98
TAG=ghcr.io/randomcoww/nvidia-overlay:$KERNEL_VERSION

mkdir -p tmp

TMPDIR=$(pwd)/tmp podman build \
  --build-arg DRIVER_VERSION=$DRIVER_VERSION \
  --build-arg KERNEL_VERSION=$KERNEL_VERSION \
  -f dkms.Containerfile \
  -t $TAG
```

Deploy to COSA image

```bash
mkdir -p 02nvidia

podman run --rm \
  -v $(pwd)/02nvidia:/mnt \
  $TAG cp -r /opt/. /mnt/
```