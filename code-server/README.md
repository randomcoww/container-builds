#### Container for openvscode-server (VS Code in a browser)

https://github.com/gitpod-io/openvscode-server

Latest release

```bash
curl -s https://api.github.com/repos/gitpod-io/openvscode-server/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/openvscode-server-v//'
```

#### Tensorflow setup

```bash
conda create --name tf -c conda-forge python=3.12
conda activate tf

pip install --upgrade pip setuptools wheel
pip install --upgrade tensorflow[and-cuda]
pip install tensorrt

export CUDNN_PATH=$(dirname $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)"))
export TENSORRT_PATH=$(dirname $(python -c "import tensorrt;print(tensorrt.__file__)"))

export LD_LIBRARY_PATH=$CONDA_PREFIX/lib/:${TENSORRT_PATH}_libs/:$CUDNN_PATH/lib/:$LD_LIBRARY_PATH
```

```python
import tensorflow as tf
print(tf.config.list_physical_devices('GPU'))
```