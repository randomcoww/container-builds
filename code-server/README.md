### Image build

```bash
mkdir -p tmp
TARGETARCH=amd64
S6_OVERLAY_VERSION=$(curl -s https://api.github.com/repos/just-containers/s6-overlay/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')
CODE_VERSION=$(curl -s https://api.github.com/repos/coder/code-server/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')
HELM_VERSION=$(curl -s https://api.github.com/repos/helm/helm/releases/latest |grep tag_name | cut -d '"' -f 4 | tr -d 'v')

TAG=ghcr.io/randomcoww/code-server:$(date -u +'%Y%m%d').6-fedora
CUDA_IMAGE_TAG="12.2.2-cudnn8-runtime-rockylinux9"

TMPDIR=$(pwd)/tmp podman build \
  --build-arg TARGETARCH=$TARGETARCH \
  --build-arg S6_OVERLAY_VERSION=$S6_OVERLAY_VERSION \
  --build-arg CUDA_IMAGE_TAG=$CUDA_IMAGE_TAG \
  --build-arg CODE_VERSION=$CODE_VERSION \
  --build-arg HELM_VERSION=$HELM_VERSION \
  -f fedora.Containerfile \
  -t $TAG && \

TMPDIR=$(pwd)/tmp podman push $TAG
```

Setup tensorflow in environment https://www.tensorflow.org/install/pip

Open [tfenv.ipynb](tfenv.ipynb)

1. Select kernel
2. Python environments
3. Create python environment
4. Venv
5. Select project path