#!/bin/bash
set -xe

modeline=$(cvt $SUNSHINE_CLIENT_WIDTH $SUNSHINE_CLIENT_HEIGHT $SUNSHINE_CLIENT_FPS | awk 'FNR == 2')
modeline=${modeline//Modeline /}
display_device=$(xrandr | grep " connected" | awk '{ print $1 }')

if xrandr --newmode $modeline; then
  xrandr --addmode $display_device $(echo $modeline | awk '{print $1}')
fi
xrandr --output $display_device --primary --mode $(echo $modeline | awk '{print $1}') --pos 0x0 --rotate normal --scale 1