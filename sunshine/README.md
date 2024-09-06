### Image build

```bash
VERSION=$(curl -s https://api.github.com/repos/lizardbyte/sunshine/tags | jq -r '.[0].name' | tr -d 'v')
TAG=ghcr.io/randomcoww/sunshine:$VERSION
TARGETARCH=amd64

sudo podman build \
  --arch $TARGETARCH \
  --build-arg TARGETARCH=$TARGETARCH \
  --build-arg VERSION=$VERSION \
  --build-arg USER=$(whoami) \
  --build-arg UID=$(id -u) \
  --build-arg HOME=$HOME \
  -t $TAG .
```

Test

```bash
sudo podman \
run --rm \
--net host \
--env XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
--name sunshine-test \
--privileged \
--security-opt label=disable \
--user $UID:$UID \
--volume /dev:/dev:rslave \
--volume $HOME:$HOME:rslave \
--volume $XDG_RUNTIME_DIR:$XDG_RUNTIME_DIR \
$TAG \
sunshine encoder=nvenc \
  key_rightalt_to_key_win=enabled \
  log_path=/dev/null \
  origin_web_ui_allowed=pc \
  output_name=1 \
  upnp=off
```