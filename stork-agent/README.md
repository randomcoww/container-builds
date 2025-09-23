### Container for ISC Stork Agent

https://github.com/isc-projects/stork

Alpine package

https://cloudsmith.io/~isc/repos/stork-dev/setup/#formats-alpine

Latest release

```bash
curl -s https://api.github.com/repos/isc-projects/stork/git/refs/tags | jq -r 'last(.[] | select(.ref | startswith("refs/tags/v"))).ref' | sed 's/refs\/tags\/v//'
```