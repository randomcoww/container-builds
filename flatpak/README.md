### RPM build

Build without malcontent

```bash
FEDORA_VERSION=38

podman build \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  -f rpmbuild.Containerfile \
  -t flatpak:latest

podman run --rm -v $(pwd):/mnt flatpak:latest \
  cp -r /root/rpmbuild/RPMS /mnt
```