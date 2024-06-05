### Build toolbox to not pass in --network host

```bash
TAG=toolbox

TMPDIR=$(pwd)/tmp podman build \
  -t $TAG . && \

podman run --rm \
  -v $(pwd):/mnt \
  $TAG cp -r /build/toolbox /mnt/
```