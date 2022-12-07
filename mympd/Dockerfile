FROM alpine:latest

ARG VERSION

RUN set -x \
  \
  && apk add --no-cache --virtual .build-deps \
    git \
    cmake \
    make \
    g++ \
    jq \
    gzip \
    perl \
    pkgconfig \
    pcre2-dev \
    flac-dev \
    libid3tag-dev \
  \
  && git clone -b $VERSION https://github.com/jcorporation/myMPD.git /usr/src/mympd \
  && cd /usr/src/mympd \
  && cmake -B build \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local . \
    -DMYMPD_MANPAGES=OFF \
    -DMYMPD_ENABLE_SSL=OFF \
    -DMYMPD_ENABLE_LUA=OFF \
  && make -C build \
  && make -C build install \
  \
## cleanup
  && cd / \
  && rm -rf /usr/src \
  \
  && runDeps="$( \
    scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
      | tr ',' '\n' \
      | sort -u \
      | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
  )" \
  && apk add --virtual .kea-rundeps $runDeps \
  && apk del .build-deps

ENTRYPOINT ["mympd", "--user", "nobody"]