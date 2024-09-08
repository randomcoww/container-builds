### Image build

```bash
VERSION=$(curl -s https://api.github.com/repos/juicedata/juicefs/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')
TAG=ghcr.io/randomcoww/juicefs:$VERSION

podman build \
  --arch amd64 \
  --build-arg VERSION=$VERSION \
  -t $TAG . && \

podman push $TAG
```
