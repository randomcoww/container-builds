### Image build

```bash
FEDORA_VERSION=38
SUNSHINE_VERSION=0.20.0
TAG=ghcr.io/randomcoww/sunshine:$(date -u +'%Y%m%d').1

podman build \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  --build-arg SUNSHINE_VERSION=$SUNSHINE_VERSION \
  -t $TAG . && \

podman push $TAG
```

### Run

- `CAP_SYS_ADMIN` is for Sunshine error with `cap_sys_admin+p sunshine`

```bash
mkdir -p tmp
TMPDIR=$(pwd)/tmp podman pull $TAG

podman run -it --rm --security-opt label=disable \
  --name sunshine \
  --cap-add CAP_SYS_ADMIN \
  --device /dev/dri \
  --device /dev/kfd \
  -p 6901:6901/tcp \
  -p 47984-47990:47984-47990/tcp \
  -p 48010:48010/tcp \
  -p 48010:48010/udp \
  -p 47998-48000:47998-48000/udp \
  $TAG \
    key_rightalt_to_key_win=enabled \
    origin_pin_allowed=wan \
    origin_web_ui_allowed=pc \
    adapter_name=/dev/dri/renderD128 \
    upnp=off

podman stop sunshine
```

### Register Sunshine client

```bash
curl http://localhost:47989/pin/<PIN>
```