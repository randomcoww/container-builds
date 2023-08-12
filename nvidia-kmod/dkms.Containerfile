FROM fedora:latest AS BUILD
ARG KERNEL_VERSION

COPY custom.repo /etc/yum.repos.d/

RUN set -x \
  \
  && dnf install -y --setopt=install_weak_deps=False \
    kernel-devel-$KERNEL_VERSION \
    kmod-nvidia-latest-dkms

RUN set -x \
  \
  && dkms build -m nvidia/$(rpm -q --queryformat "%{VERSION}" kmod-nvidia-latest-dkms) \
    -k $KERNEL_VERSION \
    -a ${KERNEL_VERSION##*.} \
    --no-depmod \
    --kernelsourcedir /usr/src/kernels/$KERNEL_VERSION \
    -j "$(getconf _NPROCESSORS_ONLN)" \
  && mkdir -p /kmod \
  && cp /var/lib/dkms/nvidia/$(rpm -q --queryformat "%{VERSION}" kmod-nvidia-latest-dkms)/$KERNEL_VERSION/${KERNEL_VERSION##*.}/module/* /kmod

FROM alpine:latest
ARG KERNEL_VERSION

COPY --from=BUILD /kmod /opt/lib/modules/$KERNEL_VERSION/nvidia/

RUN set -x \
  \
  && apk add --no-cache \
    kmod \
  && depmod -b /opt $KERNEL_VERSION