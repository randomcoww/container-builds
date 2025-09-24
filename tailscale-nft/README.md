### Container for tailscale packaged with nftables version of iptables

https://github.com/tailscale/tailscale

https://github.com/tailscale/tailscale/blob/main/Dockerfile

Latest release

```bash
curl -s https://api.github.com/repos/tailscale/tailscale/git/refs/tags | jq -r 'last(.[] | select(.ref | endswith("-pre") | not )).ref' | sed 's/refs\/tags\///' | tr -d 'v'
```