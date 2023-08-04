### Prebuilt nvidia kernel modules

# Driver releases
# https://developer.download.nvidia.com/compute/cuda/repos/fedora37/x86_64/

```bash
KERNEL_VERSION=6.4.7-200.fc38.x86_64
NVIDIA_VERSION=535.86.10
TAG=ghcr.io/randomcoww/nvidia-kmod:$KERNEL_VERSION-$NVIDIA_VERSION

podman build \
  --build-arg KERNEL_VERSION=$KERNEL_VERSION \
  --build-arg NVIDIA_VERSION=$NVIDIA_VERSION \
  -f dkms.Containerfile \
  -t $TAG
```

Deploy to COSA image

```bash
podman run --rm \
  -v $(pwd)/src/config/overlay.d/02kmod/usr/lib/modules:/mnt \
  $TAG cp -r /opt/lib/modules/. /mnt/
```