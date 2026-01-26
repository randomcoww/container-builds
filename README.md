### Container builds for homelab

Pushes to ghcr.io and internal registry (reg.cluster.internal)

#### Renovate run local test

```bash
GITHUB_TOKEN=<token>

podman run -it --rm \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  -e RENOVATE_TOKEN=$GITHUB_TOKEN \
  -e GITHUB_COM_TOKEN=$GITHUB_TOKEN \
  -e LOG_LEVEL=debug \
  ghcr.io/renovatebot/renovate \
  bash
```

```bash
renovate --platform=local --dry-run
```