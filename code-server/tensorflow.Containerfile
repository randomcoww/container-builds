# add s6 overlay
# https://github.com/linuxserver/docker-baseimage-fedora/blob/master/Dockerfile
FROM alpine:edge AS rootfs-stage

ARG S6_OVERLAY_VERSION
RUN set -x \
  \
  && mkdir -p /root-out src \
  && wget -O src/s6-overlay-noarch.tar.xz \
    https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz \
  && wget -O src/s6-overlay-arch.tar.xz \
    https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-$(arch).tar.xz \
  && wget -O src/s6-overlay-symlinks-noarch.tar.xz \
    https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz \
  && wget -O src/s6-overlay-symlinks-arch.tar.xz \
    https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz \
  && tar -C /root-out -Jxpf src/s6-overlay-noarch.tar.xz \
  && tar -C /root-out -Jxpf src/s6-overlay-arch.tar.xz \
  && tar -C /root-out -Jxpf src/s6-overlay-symlinks-noarch.tar.xz \
  && tar -C /root-out -Jxpf src/s6-overlay-symlinks-arch.tar.xz \
  && rm -rf src

FROM fedora:latest

ARG TARGETARCH
ARG CODE_VERSION

COPY --from=rootfs-stage /root-out/ /

### Steps from nvidia/cuda:12.2.2-cudnn8-runtime-rockylinux9 image build + libnvinfer for tensorrt
COPY cuda.repo /etc/yum.repos.d/

ENV \
  NVARCH=x86_64 \
  NVIDIA_REQUIRE_CUDA=cuda>=12.2 brand=tesla,driver>=470,driver<471 brand=unknown,driver>=470,driver<471 brand=nvidia,driver>=470,driver<471 brand=nvidiartx,driver>=470,driver<471 brand=geforce,driver>=470,driver<471 brand=geforcertx,driver>=470,driver<471 brand=quadro,driver>=470,driver<471 brand=quadrortx,driver>=470,driver<471 brand=titan,driver>=470,driver<471 brand=titanrtx,driver>=470,driver<471 brand=tesla,driver>=525,driver<526 brand=unknown,driver>=525,driver<526 brand=nvidia,driver>=525,driver<526 brand=nvidiartx,driver>=525,driver<526 brand=geforce,driver>=525,driver<526 brand=geforcertx,driver>=525,driver<526 brand=quadro,driver>=525,driver<526 brand=quadrortx,driver>=525,driver<526 brand=titan,driver>=525,driver<526 brand=titanrtx,driver>=525,driver<526 \
  NV_CUDA_CUDART_VERSION=12.2.140-1 \
  CUDA_VERSION=12.2.2 \
  PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
  LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64 \
  NVIDIA_VISIBLE_DEVICES=all \
  NVIDIA_DRIVER_CAPABILITIES=compute,utility \
  NV_CUDA_LIB_VERSION=12.2.2-1 \
  NV_NVTX_VERSION=12.2.140-1 \
  NV_LIBNPP_VERSION=12.2.1.4-1 \
  NV_LIBNPP_PACKAGE=libnpp-12-2-12.2.1.4-1 \
  NV_LIBCUBLAS_VERSION=12.2.5.6-1 \
  NV_LIBNCCL_PACKAGE_NAME=libnccl \
  NV_LIBNCCL_PACKAGE_VERSION=2.19.3-1 \
  NV_LIBNCCL_VERSION=2.19.3 \
  NCCL_VERSION=2.19.3 \
  NV_LIBNCCL_PACKAGE=libnccl-2.19.3-1+cuda12.2 \
  NVIDIA_PRODUCT_NAME=CUDA \
  NV_CUDNN_VERSION=8.9.6.50-1 \
  NV_CUDNN_PACKAGE=libcudnn8-8.9.6.50-1.cuda12.2 \
  # TensorRT for TF 2.16 requires libnvinfer 8.6.1
  LIBNVINFER_VERSION=8.6.1.6-1.cuda12.0

LABEL com.nvidia.cudnn.version=8.9.6.50-1

RUN set -x \
  \
  && TARGETARCH=$TARGETARCH \
  && echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
  && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf \
  \
  && echo 'exclude=*.i386 *.i686' >> /etc/dnf.conf \
  && dnf install -y --setopt=install_weak_deps=False --best \
    \
    cuda-cudart-12-2-${NV_CUDA_CUDART_VERSION} \
    cuda-compat-12-2 \
    cuda-libraries-12-2-${NV_CUDA_LIB_VERSION} \
    cuda-nvtx-12-2-${NV_NVTX_VERSION} \
    ${NV_LIBNPP_PACKAGE} \
    libcublas-12-2-${NV_LIBCUBLAS_VERSION} \
    ${NV_LIBNCCL_PACKAGE} \
    ${NV_CUDNN_PACKAGE} \
    libnvinfer8-${LIBNVINFER_VERSION} \
    libnvinfer-plugin8-${LIBNVINFER_VERSION} \
  && dnf autoremove -y \
  && dnf clean all \
  && rm -rf /var/cache /var/log/dnf* /var/log/yum.*
###

RUN set -x \
  \
  && dnf install -y --setopt=install_weak_deps=False --best \
    \
    sudo \
    git-core \
    iproute-tc \
    iptables-nft \
    gzip \
    tar \
    xz \
    unar \
    jq \
    procps-ng \
    which \
    lsof \
    strace \
    ldns-utils \
    https://github.com/coder/code-server/releases/download/v$CODE_VERSION/code-server-$CODE_VERSION-$TARGETARCH.rpm \
    python3-pip \
    conda \
  && dnf autoremove -y \
  && dnf clean all \
  && rm -rf /var/cache /var/log/dnf* /var/log/yum.* \
  && ln -sf /usr/bin/python3 /usr/bin/python

RUN set -x \
  \
  && curl -L -o /usr/local/bin/mc \
    https://dl.min.io/client/mc/release/linux-$TARGETARCH/mc \
  && chmod +x /usr/local/bin/mc \
  \
  && echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel

ENV \
  S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
  S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
  S6_VERBOSITY=1 \
  LANG=C.UTF-8

ENTRYPOINT ["/init"]