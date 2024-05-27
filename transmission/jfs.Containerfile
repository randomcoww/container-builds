FROM golang:alpine AS BUILD

WORKDIR /go/src
COPY . .

RUN set -x \
  \
  && apk add --no-cache \
    git \
  \
  && CGO_ENABLED=0 GO111MODULE=on GOOS=linux \
    go build -v -ldflags '-s -w' -o minio-client \
    minio-client.go

FROM alpine:latest

COPY --from=BUILD /go/src/minio-client /usr/local/bin/minio-client
ARG JFS_VERSION

RUN set -x \
  \
  && wget -O jfs.tar.gz \
    https://github.com/juicedata/juicefs/releases/download/v${JFS_VERSION}/juicefs-${JFS_VERSION}-linux-amd64.tar.gz \
  && tar xzf jfs.tar.gz \
  && mv juicefs /usr/local/bin/ \
  && rm jfs.tar.gz \
  && apk add --no-cache \
    transmission-daemon \
    transmission-remote \
    fuse \
    s6-overlay

COPY /root /

ENTRYPOINT ["/init"]
