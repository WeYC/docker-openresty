# Dockerfile - OpenResty 1.21.4.3 (Ubuntu Focal, Armv7)
# https://github.com/openresty/docker-openresty
# Modified: added ngx_brotli module for 1Panel compatibility
# Optimized: multi-stage build + BuildKit cache mounts

# syntax=docker/dockerfile:1

# ============================================================
# Stage 1: Builder
# ============================================================
FROM ubuntu:focal AS builder

ARG RESTY_VERSION="1.21.4.3"
ARG RESTY_LUAROCKS_VERSION="3.9.2"
ARG RESTY_OPENSSL_VERSION="1.1.1w"
ARG RESTY_OPENSSL_PATCH_VERSION="1.1.1w"
ARG RESTY_OPENSSL_URL_BASE="https://www.openssl.org/source"
ARG RESTY_OPENSSL_BUILD_OPTIONS="enable-camellia enable-seed enable-rfc3779 enable-cms enable-rc5 \
        enable-weak-ssl-ciphers enable-ssl3 enable-ssl3-method enable-ktls enable-fips"
ARG RESTY_PCRE_VERSION="8.45"
ARG RESTY_PCRE_SHA256="4dae6fdcd2bb0bb6c37b5f99c3c1480e91867027d7cf4d314c3b7f7e6f6f5c79"
ARG RESTY_PCRE_BUILD_OPTIONS="--enable-jit --enable-pcregrep-jit --disable-bsr-anycrlf --disable-coverage --disable-ebcdic --disable-fuzz-support \
    --disable-jit-sealloc --disable-never-backslash-C --enable-newline-is-lf --enable-pcre8 --enable-pcre16 --enable-pcre32 \
    --enable-pcregrep-callout --enable-pcregrep-callout-fork --disable-pcregrep-libbz2 --disable-pcregrep-libz --disable-pcretest-libedit \
    --enable-percent-zt --disable-rebuild-chartables --enable-shared --disable-static --disable-silent-rules --enable-unicode --disable-valgrind"
ARG RESTY_J="1"
ARG NGX_BROTLI_VERSION="master"
ARG RESTY_CONFIG_OPTIONS="\
    --with-compat \
    --without-http_rds_json_module \
    --without-http_rds_csv_module \
    --without-lua_rds_parser \
    --without-mail_pop3_module \
    --without-mail_imap_module \
    --without-mail_smtp_module \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_geoip_module=dynamic \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_image_filter_module=dynamic \
    --with-http_mp4_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-http_xslt_module=dynamic \
    --with-ipv6 \
    --with-mail \
    --with-mail_ssl_module \
    --with-md5-asm \
    --with-sha1-asm \
    --with-stream \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --with-threads"
ARG RESTY_CONFIG_OPTIONS_MORE=""
ARG RESTY_LUAJIT_OPTIONS="--with-luajit-xcflags='-DLUAJIT_NUMMODE=2 -DLUAJIT_ENABLE_LUA52COMPAT'"
ARG RESTY_PCRE_OPTIONS="--with-pcre-jit"

ARG _RESTY_CONFIG_DEPS="--with-pcre \
    --with-cc-opt='-DNGX_LUA_ABORT_AT_PANIC -I/usr/local/openresty/pcre/include -I/usr/local/openresty/openssl/include' \
    --with-ld-opt='-L/usr/local/openresty/pcre/lib -L/usr/local/openresty/openssl/lib -Wl,-rpath,/usr/local/openresty/pcre/lib:/usr/local/openresty/openssl/lib'"

# Install build dependencies (with cache mount)
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    echo "STEP 1: Installing build dependencies" \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        gettext-base \
        libgd-dev \
        libgeoip-dev \
        libncurses5-dev \
        libperl-dev \
        libreadline-dev \
        libxslt1-dev \
        make \
        perl \
        unzip \
        wget \
        zlib1g-dev \
        git \
        python3-pip \
        gpg \
    && curl -fsSL https://apt.kitware.com/keys/kitware-archive-latest.asc | gpg --dearmor -o /usr/share/keyrings/kitware-archive-keyring.gpg \
    && echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main' | tee /etc/apt/sources.list.d/kitware.list > /dev/null \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends cmake \
    && update-ca-certificates --fresh \
    && echo "STEP 1: Done"

# Build OpenSSL (with download cache)
RUN --mount=type=cache,target=/tmp/cache,sharing=locked \
    echo "STEP 2: Building OpenSSL ${RESTY_OPENSSL_VERSION}" \
    && cd /tmp \
    && if [ ! -f /tmp/cache/openssl-${RESTY_OPENSSL_VERSION}.tar.gz ]; then \
        curl -fSL "${RESTY_OPENSSL_URL_BASE}/openssl-${RESTY_OPENSSL_VERSION}.tar.gz" -o /tmp/cache/openssl-${RESTY_OPENSSL_VERSION}.tar.gz ; \
    fi \
    && cp /tmp/cache/openssl-${RESTY_OPENSSL_VERSION}.tar.gz . \
    && tar xzf openssl-${RESTY_OPENSSL_VERSION}.tar.gz \
    && cd openssl-${RESTY_OPENSSL_VERSION} \
    && if [ $(echo ${RESTY_OPENSSL_VERSION} | cut -c 1-2) = "3." ] ; then \
        echo 'patching OpenSSL 3.x for OpenResty' \
        && curl -s https://raw.githubusercontent.com/openresty/openresty/master/patches/openssl-${RESTY_OPENSSL_PATCH_VERSION}-sess_set_get_cb_yield.patch | patch -p1 ; \
    fi \
    && ./config \
      shared zlib -g \
      --prefix=/usr/local/openresty/openssl \
      --libdir=lib \
      -Wl,-rpath,/usr/local/openresty/openssl/lib \
      ${RESTY_OPENSSL_BUILD_OPTIONS} \
    && make -j${RESTY_J} \
    && make -j${RESTY_J} install_sw \
    && echo "STEP 2: Done"

# Build PCRE (with download cache)
RUN --mount=type=cache,target=/tmp/cache,sharing=locked \
    echo "STEP 3: Building PCRE ${RESTY_PCRE_VERSION}" \
    && cd /tmp \
    && if [ ! -f /tmp/cache/pcre-${RESTY_PCRE_VERSION}.tar.gz ]; then \
        curl -fSL "https://sourceforge.net/projects/pcre/files/pcre/${RESTY_PCRE_VERSION}/pcre-${RESTY_PCRE_VERSION}.tar.gz/download" -o /tmp/cache/pcre-${RESTY_PCRE_VERSION}.tar.gz ; \
    fi \
    && cp /tmp/cache/pcre-${RESTY_PCRE_VERSION}.tar.gz . \
    && echo "${RESTY_PCRE_SHA256}  pcre-${RESTY_PCRE_VERSION}.tar.gz" | shasum -a 256 --check \
    && tar xzf pcre-${RESTY_PCRE_VERSION}.tar.gz \
    && cd /tmp/pcre-${RESTY_PCRE_VERSION} \
    && CFLAGS="-g -O3" ./configure \
        --prefix=/usr/local/openresty/pcre \
        --libdir=/usr/local/openresty/pcre/lib \
        ${RESTY_PCRE_BUILD_OPTIONS} \
    && CFLAGS="-g -O3" make -j${RESTY_J} \
    && CFLAGS="-g -O3" make -j${RESTY_J} install \
    && echo "STEP 3: Done"

# Clone ngx_brotli and build brotli library (with git cache)
RUN --mount=type=cache,target=/tmp/cache,sharing=locked \
    echo "STEP 4: Cloning ngx_brotli and building brotli" \
    && cd /tmp \
    && if [ -d /tmp/cache/ngx_brotli ]; then \
        cp -r /tmp/cache/ngx_brotli . ; \
    else \
        git clone --recursive https://github.com/google/ngx_brotli.git /tmp/cache/ngx_brotli ; \
        cp -r /tmp/cache/ngx_brotli . ; \
    fi \
    && cd ngx_brotli \
    && git checkout ${NGX_BROTLI_VERSION} \
    && git submodule update --init --recursive \
    && cd /tmp/ngx_brotli/deps/brotli \
    && mkdir -p out && cd out \
    && cmake -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SHARED_LIBS=ON \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        .. \
    && cmake --build . --config Release -j${RESTY_J} \
    && cmake --build . --target install \
    && ldconfig \
    && echo "STEP 4: Done"

# Build OpenResty (with download cache)
RUN --mount=type=cache,target=/tmp/cache,sharing=locked \
    echo "STEP 5: Building OpenResty ${RESTY_VERSION}" \
    && cd /tmp \
    && if [ ! -f /tmp/cache/openresty-${RESTY_VERSION}.tar.gz ]; then \
        curl -fSL https://openresty.org/download/openresty-${RESTY_VERSION}.tar.gz -o /tmp/cache/openresty-${RESTY_VERSION}.tar.gz ; \
    fi \
    && cp /tmp/cache/openresty-${RESTY_VERSION}.tar.gz . \
    && tar xzf openresty-${RESTY_VERSION}.tar.gz \
    && cd /tmp/openresty-${RESTY_VERSION} \
    && eval ./configure -j${RESTY_J} ${_RESTY_CONFIG_DEPS} ${RESTY_CONFIG_OPTIONS} ${RESTY_CONFIG_OPTIONS_MORE} ${RESTY_LUAJIT_OPTIONS} ${RESTY_PCRE_OPTIONS} \
        --add-dynamic-module=/tmp/ngx_brotli \
    && make -j${RESTY_J} \
    && make -j${RESTY_J} install \
    && echo "STEP 5: Done"

# Build LuaRocks (with download cache)
RUN --mount=type=cache,target=/tmp/cache,sharing=locked \
    echo "STEP 6: Building LuaRocks ${RESTY_LUAROCKS_VERSION}" \
    && cd /tmp \
    && if [ ! -f /tmp/cache/luarocks-${RESTY_LUAROCKS_VERSION}.tar.gz ]; then \
        curl -fSL https://luarocks.github.io/luarocks/releases/luarocks-${RESTY_LUAROCKS_VERSION}.tar.gz -o /tmp/cache/luarocks-${RESTY_LUAROCKS_VERSION}.tar.gz ; \
    fi \
    && cp /tmp/cache/luarocks-${RESTY_LUAROCKS_VERSION}.tar.gz . \
    && tar xzf luarocks-${RESTY_LUAROCKS_VERSION}.tar.gz \
    && cd luarocks-${RESTY_LUAROCKS_VERSION} \
    && ./configure \
        --prefix=/usr/local/openresty/luajit \
        --with-lua=/usr/local/openresty/luajit \
        --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1 \
    && make build \
    && make install \
    && echo "STEP 6: Done"

# ============================================================
# Stage 2: Runtime
# ============================================================
FROM ubuntu:focal AS runtime

LABEL maintainer="Evan Wies <evan@neomantra.net>"

# Install runtime dependencies only
RUN echo "Installing runtime dependencies" \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gettext-base \
        libgd3 \
        libgeoip1 \
        libncurses5 \
        libperl5.30 \
        libreadline8 \
        libxslt1.1 \
        zlib1g \
    && DEBIAN_FRONTEND=noninteractive apt-get autoremove -y \
    && DEBIAN_FRONTEND=noninteractive apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo "Runtime dependencies installed"

# Copy built artifacts from builder
COPY --from=builder /usr/local/openresty/ /usr/local/openresty/
COPY --from=builder /usr/local/lib/libbrotli* /usr/local/lib/
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/usr-local-lib.conf \
    && ldconfig

# Final setup
RUN echo "STEP 8: Final setup" \
    && mkdir -p /var/run/openresty \
    && mkdir -p /usr/local/openresty/nginx/logs \
    && mkdir -p /usr/local/openresty/1pwaf/libraries \
    && ln -sf /dev/stdout /usr/local/openresty/nginx/logs/access.log \
    && ln -sf /dev/stderr /usr/local/openresty/nginx/logs/error.log \
    && echo "STEP 8: Done"

# Add additional binaries into PATH for convenience
ENV PATH=$PATH:/usr/local/openresty/luajit/bin:/usr/local/openresty/nginx/sbin:/usr/local/openresty/bin

# Add LuaRocks paths
ENV LUA_PATH="/usr/local/openresty/site/lualib/?.ljbc;/usr/local/openresty/site/lualib/?/init.ljbc;/usr/local/openresty/lualib/?.ljbc;/usr/local/openresty/lualib/?/init.ljbc;/usr/local/openresty/site/lualib/?.lua;/usr/local/openresty/site/lualib/?/init.lua;/usr/local/openresty/lualib/?.lua;/usr/local/openresty/lualib/?/init.lua;./?.lua;/usr/local/openresty/luajit/share/luajit-2.1/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;/usr/local/openresty/luajit/share/lua/5.1/?.lua;/usr/local/openresty/luajit/share/lua/5.1/?/init.lua"

ENV LUA_CPATH="/usr/local/openresty/site/lualib/?.so;/usr/local/openresty/lualib/?.so;./?.so;/usr/local/lib/lua/5.1/?.so;/usr/local/openresty/luajit/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so;/usr/local/openresty/luajit/lib/lua/5.1/?.so"

# Copy 1Panel nginx configuration
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY default /usr/local/openresty/nginx/conf/default
COPY 1pwaf /usr/local/openresty/1pwaf

CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]

# Use SIGQUIT instead of default SIGTERM to cleanly drain requests
STOPSIGNAL SIGQUIT
