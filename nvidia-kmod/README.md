### Prebuilt nvidia kernel modules

```bash
NVIDIA_VERSION=535.54.03
TAG=ghcr.io/randomcoww/nvidia-kmod:$(uname -r)

podman build \
  --build-arg NVIDIA_VERSION=$NVIDIA_VERSION \
  -f dkms.Containerfile \
  -t $TAG
```