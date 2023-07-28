### RPM build

```bash
FEDORA_VERSION=38

podman build \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  -f rpmbuild.Containerfile \
  -t keepalived:latest

podman run --rm -v $(pwd):/mnt keepalived:latest \
  cp -r /root/rpmbuild/RPMS /mnt
```