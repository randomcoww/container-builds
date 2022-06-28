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
  --dns 9.9.9.9 \
  --build-arg VERSION=$VERSION \
  -f Dockerfile \
  -t $TAG && \

buildah push $TAG
```