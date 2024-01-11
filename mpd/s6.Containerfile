FROM alpine:edge

ARG VERSION
ARG PATCH

RUN set -x \
  \
  && apk add --no-cache --virtual .build-deps \
    g++ \
    meson \
    # py3-sphinx \
    lame-dev \
    glib-dev \
    curl-dev \
    # libao-dev \
    # libmad-dev \
    flac-dev \
    # libogg-dev \
    # faad2-dev \
    # libid3tag-dev \
    # libvorbis-dev \
    # alsa-lib-dev \
    # libsamplerate-dev \
    libshout-dev \
    # libmodplug-dev \
    boost-dev \
    # icu-dev \
    # libnfs-dev \
    # samba-dev \
    # opus-dev \
    ffmpeg-dev \
    # libmpdclient-dev \
    # libcdio-paranoia-dev \
    # libcap \
    # gtest-dev \
    # gtest \
    # libsndfile-dev \
    sqlite-dev \
    soxr-dev \
    bzip2-dev \
    # libcdio-dev \
    # zlib-dev \
    # mpg123-dev \
    # wavpack-dev \
    expat-dev \
    ca-certificates \
  \
## build
  && mkdir -p /usr/src/mpd \
  && cd /usr/src/mpd \
  && wget -O mpd.tar.xz https://www.musicpd.org/download/mpd/$VERSION/mpd-$VERSION.$PATCH.tar.xz \
  && tar xf mpd.tar.xz --strip-components=1 -C /usr/src/mpd \
  && rm mpd.tar.xz \
  \
  && meson \
    --prefix=/usr/local \
    --sysconfdir=/etc \
    --localstatedir=/var \
    --buildtype=plain \
    output \
  && ninja -C output install \
  \
## cleanup
  && rm -rf /usr/src \
  && runDeps="$( \
    scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
      | tr ',' '\n' \
      | sort -u \
      | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
  )" \
  && apk add --virtual .mpd-rundeps $runDeps \
  && apk add --no-cache \
    rclone \
    fuse3 \
    s6-overlay \
  \
  && apk del .build-deps \
  && mpd -V

COPY /root /

ENV \
  S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
  S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
  S6_VERBOSITY=1

ENTRYPOINT ["/init"]