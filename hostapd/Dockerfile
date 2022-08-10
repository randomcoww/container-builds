# Based on https://git.alpinelinux.org/aports/tree/main/hostapd/APKBUILD
# add CONFIG_SAE
# remove CONFIG_WEP

FROM alpine:latest

ARG VERSION

RUN set -x \
  \
  && apk add --no-cache --virtual .build-deps \
    libnl3-dev \
    openssl-dev \
    linux-headers \
    make \
    g++ \
  \
  && wget -O hostapd.tar.gz "https://w1.fi/releases/hostapd-$VERSION.tar.gz" \
  && mkdir -p /usr/src/hostapd \
  && tar xf hostapd.tar.gz --strip-components=1 -C /usr/src/hostapd \
  && rm hostapd.tar.gz \
  && cd /usr/src/hostapd/hostapd \
  \
  && cp defconfig .config \
	&& echo "CC ?= ${CC:-gcc}" >> .config \
	&& echo "CFLAGS += -I/usr/include/libnl3" >> .config \
	&& echo "LIBS += -L/usr/local/lib" >> .config \
  \
	&& echo "CONFIG_DRIVER_NL80211=y" >> .config \
	&& echo "CONFIG_RADIUS_SERVER=y" >> .config \
	&& echo "CONFIG_DRIVER_WIRED=y" >> .config \
	&& echo "CONFIG_DRIVER_NONE=y" >> .config \
	&& echo "CONFIG_IEEE80211N=y" >> .config \
	&& echo "CONFIG_IEEE80211R=y" >> .config \
	&& echo "CONFIG_IEEE80211AC=y" >> .config \
	&& echo "CONFIG_IEEE80211AX=y" >> .config \
	&& echo "CONFIG_FULL_DYNAMIC_VLAN=y" >> .config \
	&& echo "CONFIG_LIBNL32=y" >> .config \
	&& echo "CONFIG_ACS=y" >> .config \
	&& echo "CONFIG_SAE=y" >> .config \
  \
  && make -j "$(getconf _NPROCESSORS_ONLN)" install \
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
  && apk add --virtual .hostapd-rundeps $runDeps \
  && apk del .build-deps

ENTRYPOINT ["/usr/local/bin/hostapd"]
