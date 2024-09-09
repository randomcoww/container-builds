### Image build

```bash
VERSION=$(curl -s https://api.github.com/repos/MusicPlayerDaemon/MPD/tags | jq -r '.[0].name' | tr -d 'v')
MAJOR=$(echo $VERSION | cut -d '.' -f1-2)
PATCH=$(echo $VERSION | cut -d '.' -f3)
TAG=ghcr.io/randomcoww/mpd:$VERSION

podman build \
  --build-arg MAJOR=$MAJOR \
  --build-arg PATCH=$PATCH \
  -t $TAG . && \

podman push $TAG
```