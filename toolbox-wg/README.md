### Image build

Needs custom toolbox build from https://github.com/randomcoww/repos/tree/master/builds/fedora/toolbox

```bash
mkdir -p tmp
FEDORA_VERSION=40
TAILSCALE_VERSION=$(curl -s https://api.github.com/repos/tailscale/tailscale/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')
TAG=ghcr.io/randomcoww/toolbox-wg:$(date -u +'%Y%m%d').3

git clone -b v$TAILSCALE_VERSION https://github.com/tailscale/tailscale.git

podman build \
  -f tailscale/Dockerfile \
  --target build-env \
  -t tailscale-build

TMPDIR=$(pwd)/tmp podman build \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  -t $TAG .
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