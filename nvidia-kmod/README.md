### Prebuilt nvidia kernel modules

#### Driver releases
https://developer.download.nvidia.com/compute/cuda/repos/fedora37/x86_64/

```bash
KERNEL_VERSION=6.4.11-200.fc38.x86_64
TAG=ghcr.io/randomcoww/nvidia-kmod:$KERNEL_VERSION

mkdir -p tmp

TMPDIR=$(pwd)/tmp podman build \
  --build-arg KERNEL_VERSION=$KERNEL_VERSION \
  -f dkms.Containerfile \
  -t $TAG
```

Deploy to COSA image

```bash
mkdir -p 02nvidia/usr

podman run --rm \
  -v $(pwd)/02nvidia/usr:/mnt \
  $TAG cp -r /opt/. /mnt/
```