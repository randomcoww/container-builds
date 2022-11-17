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

```bash
VERSION=master
TAG=ghcr.io/randomcoww/tftpd-ipxe:$(date -u +'%Y%m%d')

buildah build \
  --build-arg VERSION=$VERSION \
  -f Dockerfile \
  -t $TAG && \

buildah push $TAG
```