### Container for Steam over Sunshine

Originally based on https://github.com/Steam-Headless/docker-steam-headless/tree/master but has changed quite a bit now. This setup works with AMD and most likely also with Intel.

### Example config:

#### AMD

```yaml
containers:
- name: sunshine-desktop
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
  - name: USER
    value: sunshine
  - name: UID
    value: "10000"
  - name: HOME
    value: /home/sunshine
  - name: XDG_RUNTIME_DIR
    value: /run/user/10000
  volumeMounts:
  - mountPath: /dev/input
    name: dev-input
  - mountPath: /dev/shm
    name: dev-shm
  resources:
    limits:
      amd.com/gpu: "1"
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
