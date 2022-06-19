### PXE images served over TFTP

ipxe.efi and undionly.kpxe served over TFTP-HPA

PXE images built to support:

```
DNS
HTTP
HTTPS
iSCSI
NFS
TFTP
FCoE
SRP
VLAN
AoE
EFI
Menu
```

### Image build

```
VERSION=master
TAG=ghcr.io/randomcoww/tftpd-ipxe:$VERSION

buildah build \
  --build-arg VERSION=$VERSION \
  -f Dockerfile \
  -t localtemp

container=$(buildah from localtemp)
buildah run --net=none $container -- rm /etc/hosts
buildah commit $container $TAG

buildah push $TAG
```