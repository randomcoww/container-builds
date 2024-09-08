### Image build

```bash
VERSION=$(curl -s https://api.github.com/repos/lizardbyte/sunshine/tags | jq -r '.[0].name' | tr -d 'v')
TAG=ghcr.io/randomcoww/sunshine:$VERSION.2
TARGETARCH=amd64

sudo podman build \
  --arch $TARGETARCH \
  --build-arg TARGETARCH=$TARGETARCH \
  --build-arg VERSION=$VERSION \
  --build-arg UID=$(stat -c %u $XDG_RUNTIME_DIR) \
  -t $TAG .
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
  output_name=1 \
  upnp=off
```