### RPM build

```bash
NVIDIA_VERSION=535.54.03
TAG=$(uname -r)-$NVIDIA_VERSION

podman build \
  --build-arg NVIDIA_VERSION=$NVIDIA_VERSION \
  -f dkms.Containerfile \
  -t nvidia-kmod:$TAG
```