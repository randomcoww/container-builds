### Prebuilt nvidia kernel modules

```bash
KERNEL_VERSION=$(uname -r)
NVIDIA_VERSION=535.54.03
TAG=ghcr.io/randomcoww/nvidia-kmod:$KERNEL_VERSION-$NVIDIA_VERSION

podman build \
  --build-arg KERNEL_VERSION=$KERNEL_VERSION \
  --build-arg NVIDIA_VERSION=$NVIDIA_VERSION \
  -f dkms.Containerfile \
  -t $TAG
```