#!/usr/bin/with-contenv bash

exec s6-setuidgid $USER code-server \
  --auth=none \
  --bind-addr=0.0.0.0:$CODE_PORT
