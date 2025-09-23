### Container build for Nvidia Geforce driver

Pass Geforce URL to build drivers using official build

https://github.com/NVIDIA/gpu-driver-container

or modified version for Fedora CoreOS

https://gitlab.com/container-toolkit-fcos/driver

Latest release

```bash
curl -s https://gitlab.com/api/v4/projects/container-toolkit-fcos%2Fdriver/repository/tags | jq -r 'first(.[] | select(.name | endswith("-fedora"))).name'
```
