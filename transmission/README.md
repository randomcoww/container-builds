### Tool to move completed to minio

```bash
WORKDIR=/go/src/
podman run --name minio-client --net host -it --rm \
    -v $(pwd):$WORKDIR \
    -w $WORKDIR golang:alpine

go fmt minio-client.go && \

CGO_ENABLED=0 GO111MODULE=on GOOS=linux \
    go build -v -ldflags '-s -w' \
    -o minio-client minio-client.go
```

### Image build

```bash
TAG=ghcr.io/randomcoww/transmission:$(date -u +'%Y%m%d').1

podman build \
  --arch amd64 \
  -t $TAG . && \

podman push $TAG
```
