### Image build

This is based on https://github.com/Steam-Headless/docker-steam-headless/tree/master

- Based on Fedora 39 (Sunshine CUDA build only supports up to F39).
- Sunshine only to access the desktop. No VNC.
- Nvidia GPUs only. Setup breaks unless `nvidia-smi` can run.
- Intended to work in Kubernetes with configMap mounts to support service configuration.

```bash
TARGETARCH=amd64
FEDORA_VERSION=39
VERSION=$(curl -s https://api.github.com/repos/LizardByte/Sunshine/tags | jq -r '.[0].name' | tr -d 'v')
S6_OVERLAY_VERSION=$(curl -s https://api.github.com/repos/just-containers/s6-overlay/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')
TAG=ghcr.io/randomcoww/sunshine-desktop:$VERSION-3

podman build \
  --net host \
  --arch $TARGETARCH \
  --build-arg TARGETARCH=$TARGETARCH \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  --build-arg VERSION=$VERSION \
  --build-arg S6_OVERLAY_VERSION=$S6_OVERLAY_VERSION \
  -t $TAG .

podman push $TAG
```