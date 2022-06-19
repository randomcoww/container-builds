#!/bin/sh
set -e

## Working path for transmission
config_dir=${CONFIG_DIR:-/var/lib/transmission}

## By default, torrents and resume are created automatically under $config_dir
## and path cannot be cspecified. Make this more configurable for external mounts
torrents_dir=${TORRENTS_DIR:-/transmission/torrents}
resume_dir=${RESUME_DIR:-/transmission/resume}
mkdir -p $torrents_dir
touch $torrents_dir/.keep
ln -sf $torrents_dir $config_dir/torrents
mkdir -p $resume_dir
touch $resume_dir/.keep
ln -sf $resume_dir $config_dir/resume

## Config file must be at $config_dir/settings.json
## This may be mounted from configMap

## Start
exec transmission-daemon \
  $@ \
  --config-dir $config_dir \
  --foreground \
  --port 9091