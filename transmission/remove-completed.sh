#!/bin/sh
set -xe

# https://github.com/transmission/transmission/wiki/Scripts
#  * TR_APP_VERSION
#  * TR_TIME_LOCALTIME
#  * TR_TORRENT_DIR
#  * TR_TORRENT_HASH
#  * TR_TORRENT_ID
#  * TR_TORRENT_NAME

/usr/bin/transmission-remote 127.0.0.1:9091 \
  --torrent "${TR_TORRENT_ID}" \
  --verify

/usr/bin/transmission-remote 127.0.0.1:9091 \
  --torrent "${TR_TORRENT_ID}" \
  --remove