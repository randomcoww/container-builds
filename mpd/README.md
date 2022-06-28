### Docker MPD intended for HTTP streaming

https://hub.docker.com/r/randomcoww/mpd/

Default configuration creates a FLAC-3 stream over HTTP on port 8000

**Images**

https://hub.docker.com/repository/docker/randomcoww/mpd

#### Sample usage

```bash
podman run -it --rm \
    --security-opt label=disable \
    -v music_path:/mpd/music \
    -v cache_path:/mpd/cache \
    -p 6600:6600 \
    -p 8000:8000 \
    ghcr.io/randomcoww/mpd:0.23.5
```

### Image build

```
VERSION=0.23
PATCH=7
TAG=ghcr.io/randomcoww/mpd:$VERSION.$PATCH

buildah build \
  --dns 9.9.9.9 \
  --build-arg VERSION=$VERSION \
  --build-arg PATCH=$PATCH \
  -t $TAG && \

buildah push $TAG
```