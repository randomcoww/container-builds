FROM fedora:latest AS BUILD
ARG NVIDIA_VERSION=535.54.03
ARG KERNEL_VERSION

COPY nvidia.repo /etc/yum.repos.d/

RUN set -x \
  \
  && dnf install -y --setopt=install_weak_deps=False \
    kernel-devel-$KERNEL_VERSION \
    kmod-nvidia-latest-dkms-$NVIDIA_VERSION \
  \
  && dkms build -m nvidia/$NVIDIA_VERSION \
    -k $KERNEL_VERSION \
    -a ${KERNEL_VERSION##*.} \
    --no-depmod \
    --kernelsourcedir /usr/src/kernels/$KERNEL_VERSION \
    -j "$(getconf _NPROCESSORS_ONLN)" \
  && mkdir -p /kmod \
  && cp /var/lib/dkms/nvidia/$NVIDIA_VERSION/$KERNEL_VERSION/${KERNEL_VERSION##*.}/module/* /kmod

FROM alpine:latest
ARG KERNEL_VERSION

COPY --from=BUILD /kmod /opt/lib/modules/$KERNEL_VERSION/nvidia/

RUN set -x \
  \
  && apk add --no-cache \
    kmod \
  && depmod -b /opt $KERNEL_VERSION