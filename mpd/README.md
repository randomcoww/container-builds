### Image build

```bash
mkdir -p tmp
VERSION=0.23
PATCH=15
TAG=ghcr.io/randomcoww/mpd:$VERSION.$PATCH

TMPDIR=$(pwd)/tmp podman build \
  --build-arg VERSION=$VERSION \
  --build-arg PATCH=$PATCH \
  -t $TAG . && \

TMPDIR=$(pwd)/tmp podman push $TAG
```

Build with S6 init and S3 fuse mounts

```bash
VERSION=0.23
PATCH=15
TAG=ghcr.io/randomcoww/mpd:$VERSION.$PATCH.2-s6

TMPDIR=$(pwd)/tmp podman build \
  --build-arg VERSION=$VERSION \
  --build-arg PATCH=$PATCH \
  -f s6.Containerfile \
  -t $TAG && \

TMPDIR=$(pwd)/tmp podman push $TAG
```