### Image build

- CUDA driver releases https://developer.download.nvidia.com/compute/cuda/repos/fedora39/x86_64/

```bash
TARGETARCH=amd64
FEDORA_VERSION=39
VERSION=$(curl -s https://api.github.com/repos/LizardByte/Sunshine/tags | jq -r '.[0].name' | tr -d 'v')
S6_OVERLAY_VERSION=$(curl -s https://api.github.com/repos/just-containers/s6-overlay/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')
TAG=ghcr.io/randomcoww/sunshine-desktop:$VERSION

sudo podman build \
  --net host \
  --arch $TARGETARCH \
  --build-arg TARGETARCH=$TARGETARCH \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  --build-arg VERSION=$VERSION \
  --build-arg S6_OVERLAY_VERSION=$S6_OVERLAY_VERSION \
  -t $TAG .

sudo podman push $TAG
```