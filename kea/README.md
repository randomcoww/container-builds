### Container for Kea development release

https://github.com/isc-projects/kea

Alpine package

https://cloudsmith.io/~isc/repos/kea-dev/setup/#formats-alpine

Latest release

```bash
curl -s https://api.github.com/repos/isc-projects/kea/git/refs/tags | jq -r 'last(.[] | select(.ref | startswith("refs/tags/Kea-"))).ref' | sed 's/refs\/tags\/Kea-//'
```