### Image build

- CUDA driver releases https://developer.download.nvidia.com/compute/cuda/repos/fedora39/x86_64/

```bash
TARGETARCH=amd64
FEDORA_VERSION=39
VERSION=2024.1214.152703
DRIVER_VERSION=565.57.01
TAG=ghcr.io/randomcoww/sunshine:$VERSION-$DRIVER_VERSION

sudo podman build \
  --net host \
  --arch $TARGETARCH \
  --build-arg TARGETARCH=$TARGETARCH \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  --build-arg VERSION=$VERSION \
  --build-arg DRIVER_VERSION=$DRIVER_VERSION \
  -t $TAG .

sudo podman push $TAG
```