FROM fedora:latest AS BUILD
ARG KERNEL_VERSION

COPY custom.repo /etc/yum.repos.d/

RUN set -x \
  \
  && dnf install -y \
    https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
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
  && mkdir -p /opt/modules \
  && cp /var/lib/dkms/nvidia/$(rpm -q --queryformat "%{VERSION}" kmod-nvidia-latest-dkms)/$KERNEL_VERSION/${KERNEL_VERSION##*.}/module/* /opt/modules

FROM alpine:latest
ARG KERNEL_VERSION

COPY --from=BUILD /opt/modules /opt/lib/modules/$KERNEL_VERSION/kernel/drivers/video

RUN set -x \
  \
  && apk add --no-cache \
    kmod \
  && depmod -b /opt $KERNEL_VERSION