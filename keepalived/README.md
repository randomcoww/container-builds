### RPM build

Build with nft, without snmp

```bash
FEDORA_VERSION=39

mkdir -p tmp
TMPDIR=$(pwd)/tmp podman build \
  --build-arg FEDORA_VERSION=$FEDORA_VERSION \
  -f rpmbuild.Containerfile \
  -t keepalived:latest

podman run --rm -v $(pwd):/mnt keepalived:latest \
  cp -r /root/rpmbuild/RPMS /mnt
```
