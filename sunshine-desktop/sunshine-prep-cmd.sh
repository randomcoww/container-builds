#!/bin/bash
set -xe

wlr-randr \
  --output HEADLESS-1 \
  --custom-mode ${SUNSHINE_CLIENT_WIDTH}x${SUNSHINE_CLIENT_HEIGHT}@${SUNSHINE_CLIENT_FPS}