FROM fedora:latest AS BUILD
ARG NVIDIA_VERSION=535.54.03

COPY nvidia.repo /etc/yum.repos.d/

RUN set -x \
  \
  && dnf install -y --setopt=install_weak_deps=False \
    kernel-devel-$(uname -r) \
    kmod-nvidia-latest-dkms-3:$NVIDIA_VERSION \
  \
  && dkms build -m nvidia/$NVIDIA_VERSION --kernelsourcedir /usr/src/kernels/$(uname -r) \
  && mkdir -p /kmod \
  && cp /var/lib/dkms/nvidia/$NVIDIA_VERSION/$(uname -r)/$(uname -m)/module/* /kmod/

FROM alpine:latest

COPY --from=BUILD /kmod/* /kmod/