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

RUN set -x \
  \
  && apk add --no-cache \
	  transmission-daemon \
	  transmission-cli

ENTRYPOINT ["transmission-daemon", "--foreground"]