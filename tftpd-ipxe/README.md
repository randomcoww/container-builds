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
TAG=ghcr.io/randomcoww/tftpd-ipxe:$(date -u +'%Y%m%d').3
TARGETARCH=amd64

podman build \
  --arch $TARGETARCH \
  --build-arg VERSION=$VERSION \
  -t $TAG .

podman push $TAG
```