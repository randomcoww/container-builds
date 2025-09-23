### Container for Steam over Sunshine

Originally based on https://github.com/Steam-Headless/docker-steam-headless/tree/master but has changed quite a bit now.

Currently migrating to Wayland and isn't able to fully use the Nvidia GPU. Nvidia graphics acceleration works in applications like games, but desktop rendering and Sunshine encoding seems to only work on an alternate GPU with non proprietary drivers.

My environment is also a little unique and some common modules like `nvidia-drm` are not installed with the Nvidia driver, so this may be one issue.

#### Example config:

```yaml
containers:
- name: sushine-desktop
  args:
  - bash
  - -c
  - |
    set -e

    ## User ##

    useradd $USER -d $HOME -m -u $UID
    usermod -G video,input,render,dbus,seat $USER

    mkdir -p $HOME $XDG_RUNTIME_DIR
    chown $UID:$UID $HOME $XDG_RUNTIME_DIR

    ## Driver ##

    mkdir -p $HOME/nvidia
    targetarch=$(arch)
    driver_version=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader --id=0)
    driver_file=$HOME/nvidia/NVIDIA-Linux-$targetarch-$driver_version.run

    NVIDIA_DRIVER_BASE_URL=${NVIDIA_DRIVER_BASE_URL:-https://us.download.nvidia.com/XFree86/${targetarch/x86_64/Linux-x86_64}}
    curl -L --skip-existing -o "$driver_file" \
      $NVIDIA_DRIVER_BASE_URL/$driver_version/NVIDIA-Linux-$targetarch-$driver_version.run

    chmod +x "$driver_file"
    "$driver_file" \
      --silent \
      --accept-license \
      --skip-depmod \
      --skip-module-unload \
      --no-kernel-modules \
      --no-kernel-module-source \
      --no-nouveau-check \
      --no-nvidia-modprobe \
      --no-systemd \
      --no-wine-files \
      --no-x-check \
      --no-dkms \
      --no-distro-scripts \
      --no-rpms \
      --no-backup \
      --no-check-for-alternate-installs \
      --no-libglx-indirect \
      --no-install-libglvnd

    ## Udev ##

    /lib/systemd/systemd-udevd &

    ## Seatd ##

    seatd -u $USER &

    runuser -p -u $USER -- bash <<EOT
    set -e
    cd $HOME

    ## Pulseaudio ##

    pulseaudio \
      --log-level=0 \
      --daemonize=true \
      --disallow-exit=true \
      --log-target=stderr \
      --exit-idle-time=-1

    ## Sway ##

    sway &

    ## Sunshine ##

    while ! wlr-randr >/dev/null 2>&1; do
    sleep 1
    done
    exec sunshine \
      origin_web_ui_allowed=wan \
      port=$SUNSHINE_PORT \
      file_apps=/etc/sunshine/apps.json \
      upnp=off
    EOT
  env:
  - name: NVIDIA_VISIBLE_DEVICES
    value: all
  - name: NVIDIA_DRIVER_CAPABILITIES
    value: all
  - name: USER
    value: sunshine
  - name: UID
    value: "10000"
  - name: HOME
    value: /home/sunshine
  - name: XDG_RUNTIME_DIR
    value: /run/user/10000
  - name: __NV_PRIME_RENDER_OFFLOAD
    value: "1"
  - name: __GLX_VENDOR_LIBRARY_NAME
    value: "nvidia"
  volumeMounts:
  - mountPath: /dev/input
    name: dev-input
  - mountPath: /dev/shm
    name: dev-shm
  resources:
    limits:
      nvidia.com/gpu: "1"
  securityContext:
    privileged: true # make sunshine inputs work
volumes:
- name: dev-shm
  emptyDir:
    medium: Memory
- name: dev-input
  hostPath:
    path: /dev/input
```

Latest Sunshine release

```bash
curl -s https://api.github.com/repos/LizardByte/Sunshine/tags | grep name | head -1 | cut -d '"' -f 4 | tr -d 'v'
```