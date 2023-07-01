### RPM build

```bash
FEDORA_VERSION=38
KEEPALIVED_VERSION=2.2.8

podman build \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  --build-arg KEEPALIVED_VERSION=$KEEPALIVED_VERSION \
  -f rpmbuild.Containerfile \
  -t keepalived:$KEEPALIVED_VERSION

podman run --rm -v $(pwd):/mnt keepalived:$KEEPALIVED_VERSION \
  cp -r /root/rpmbuild/RPMS /mnt
```