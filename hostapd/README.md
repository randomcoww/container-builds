### Container for hostapd with noscan patch

https://w1.fi/releases/

Latest release

```bash
curl -s https://w1.fi/hostapd/ | grep -E "/releases/hostapd-([0-9.]+)" | sed -r 's/^.*\/releases\/hostapd-([0-9.]+)\.tar\..*$/\1/'
```