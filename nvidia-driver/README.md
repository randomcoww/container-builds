### Image build

```bash
git clone https://gitlab.com/container-toolkit-fcos/driver.git
cd driver/fedora

TARGETARCH=amd64
DRIVER_VERSION=565.77
KERNEL_TYPE=kernel-open
FEDORA_VERSION=41
BASE_URL=http://us.download.nvidia.com/XFree86/Linux-x86_64
TAG=ghcr.io/randomcoww/nvidia-driver:$DRIVER_VERSION-fedora$FEDORA_VERSION

podman build \
  --net host \
  --arch $TARGETARCH \
  --build-arg TARGETARCH=$TARGETARCH \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  --build-arg BASE_URL=$BASE_URL \
  --build-arg DRIVER_VERSION=$DRIVER_VERSION \
  --build-arg KERNEL_TYPE=$KERNEL_TYPE \
  -f Dockerfile \
  -t $TAG

podman push $TAG
```

```bash
sudo podman run -it --rm --privileged --pid=host --net=host \
  -v /run/nvidia:/run/nvidia:shared \
  -v /var/log:/var/log \
  $TAG
```
