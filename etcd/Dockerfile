ARG GO_VERSION
FROM golang:${GO_VERSION}-alpine as BUILD
ARG VERSION

WORKDIR /go/src/github.com/etcd-io

RUN set -x \
  \
  && apk add --no-cache \
    git \
    make \
    bash \
  \
  && git clone -b $VERSION \
    https://github.com/etcd-io/etcd.git \
  && cd etcd \
  && go mod vendor \
  && GO_LDFLAGS='-s -w' make build

FROM scratch

COPY --from=BUILD /go/src/github.com/etcd-io/etcd/bin/ /usr/local/bin/