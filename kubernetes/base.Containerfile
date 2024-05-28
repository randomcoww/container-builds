ARG GO_VERSION
FROM docker.io/golang:$GO_VERSION-alpine as BUILD
ARG VERSION

WORKDIR /go/src/github.com/kubernetes
RUN set -x \
  \
  && apk add --no-cache \
    git \
    make \
    bash \
    rsync \
  \
  && git clone -b v$VERSION https://github.com/kubernetes/kubernetes.git \
  && cd kubernetes \
  && make \
    kube-apiserver \
    kube-controller-manager \
    kube-scheduler \
    kube-proxy

FROM scratch

COPY --from=BUILD /go/src/github.com/kubernetes/kubernetes/_output/bin/ /usr/local/bin
