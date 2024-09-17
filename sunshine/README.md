### Image build

```bash
VERSION=$(curl -s https://api.github.com/repos/lizardbyte/sunshine/tags | jq -r '.[0].name' | tr -d 'v')
TAG=ghcr.io/randomcoww/sunshine:$VERSION
TARGETARCH=amd64
FEDORA_VERSION=39
DRIVER_VERSION=560.35.03

sudo podman build \
  --arch $TARGETARCH \
  --build-arg TARGETARCH=$TARGETARCH \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  --build-arg DRIVER_VERSION=$DRIVER_VERSION \
  --build-arg VERSION=$VERSION \
  -t $TAG .

sudo podman push $TAG
```

Test

```bash
SUNSHINE_HOME=/var/sunshine

sudo podman \
run --rm \
--net host \
--env XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
--env HOME=$SUNSHINE_HOME \
--name sunshine-test \
--privileged \
--security-opt label=disable \
--user $UID:$UID \
--mount type=tmpfs,destination=$SUNSHINE_HOME \
--volume /dev:/dev:rslave \
--volume $XDG_RUNTIME_DIR:$XDG_RUNTIME_DIR \
$TAG \
  encoder=nvenc \
  key_rightalt_to_key_win=enabled \
  log_path=/dev/null \
  origin_web_ui_allowed=pc \
  output_name=0 \
  upnp=off
```