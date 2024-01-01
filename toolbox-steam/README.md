### Image build

```bash
mkdir -p tmp
FEDORA_VERSION=39
HEROIC_VERSION=2.11.0
TAG=ghcr.io/randomcoww/toolbox-steam:$(date -u +'%Y%m%d').3

TMPDIR=$(pwd)/tmp podman build \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  --build-arg HEROIC_VERSION=$HEROIC_VERSION \
  -t $TAG . && \

TMPDIR=$(pwd)/tmp podman push $TAG
```

```bash
toolbox create -i $TAG steam
toolbox enter steam
```