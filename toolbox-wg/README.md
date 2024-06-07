### Image build

Needs custom toolbox build from https://github.com/randomcoww/repos/tree/master/builds/fedora/toolbox

```bash
mkdir -p tmp
FEDORA_VERSION=40
TAG=ghcr.io/randomcoww/toolbox-wg:$(date -u +'%Y%m%d').3

TMPDIR=$(pwd)/tmp podman build \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  -t $TAG . && \

TMPDIR=$(pwd)/tmp podman push $TAG
```

```bash
toolbox create -i $TAG wg
toolbox enter wg
```

Launch wireguard and browser

```bash
sudo wg-quick up ~/wg0.conf
brave-brwoser
```