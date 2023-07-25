### Image build

```bash
FEDORA_VERSION=38
SUNSHINE_VERSION=0.20.0
USER=podman
TAG=ghcr.io/randomcoww/sunshine-desktop:$(date -u +'%Y%m%d').1

sudo podman build \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  --build-arg SUNSHINE_VERSION=$SUNSHINE_VERSION \
  --build-arg USER=$USER \
  -t $TAG . && \

podman push $TAG
```

```bash
sudo podman run -it --rm \
  --name sunshine \
  --privileged \
  --device /dev/kfd \
  --device /dev/dri \
  -p 47984-47990:47984-47990/tcp \
  -p 48010:48010 \
  -p 47998-48000:47998-48000/udp \
  ghcr.io/randomcoww/sunshine-desktop:20230724.1
```