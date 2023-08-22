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
    kmod-nvidia-latest-dkms \
    nvidia-driver-cuda \
    nvidia-driver-cuda-libs \
    nvidia-driver-NvFBCOpenGL \
    git-core

RUN set -x \
  # patch nvidia driver
  && git clone https://github.com/keylase/nvidia-patch.git nvidia-patch \
  && ./nvidia-patch/patch.sh -d $(rpm -q --queryformat "%{VERSION}" kmod-nvidia-latest-dkms) \
  && ./nvidia-patch/patch-fbc.sh -d $(rpm -q --queryformat "%{VERSION}" kmod-nvidia-latest-dkms) \
  && rm -r \
    nvidia-patch \
    /opt/nvidia \
  && mkdir -p /opt/lib64 \
  && mv /usr/lib64/libnvidia-fbc.* /opt/lib64 \
  && mv /usr/lib64/libnvidia-encode.* /opt/lib64

RUN set -x \
  \
  && dkms build -m nvidia/$(rpm -q --queryformat "%{VERSION}" kmod-nvidia-latest-dkms) \
    -k $KERNEL_VERSION \
    -a ${KERNEL_VERSION##*.} \
    --no-depmod \
    --kernelsourcedir /usr/src/kernels/$KERNEL_VERSION \
    -j "$(getconf _NPROCESSORS_ONLN)" \
  && mkdir -p /opt/modules \
  && cp /var/lib/dkms/nvidia/$(rpm -q --queryformat "%{VERSION}" kmod-nvidia-latest-dkms)/$KERNEL_VERSION/${KERNEL_VERSION##*.}/module/* /opt/modules

FROM alpine:latest
ARG KERNEL_VERSION

COPY --from=BUILD /opt/modules /opt/lib/modules/$KERNEL_VERSION/nvidia
COPY --from=BUILD /opt/lib64 /opt/lib64

RUN set -x \
  \
  && apk add --no-cache \
    kmod \
  && depmod -b /opt $KERNEL_VERSION