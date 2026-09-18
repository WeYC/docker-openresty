#!/bin/sh
# Seed 1Panel module files into the host install dir on container start.
# All operations are idempotent; missing mounts are skipped silently.
set -e

SEED_DIR="/opt/1panel-seed"
HOST_BUILD_DIR="/mnt/host-build"
NGINX_CONF="/usr/local/openresty/nginx/conf/nginx.conf"
MODULE_INCLUDE='include /usr/local/openresty/nginx/conf/modules-enabled/*.conf;'

if [ -d "${HOST_BUILD_DIR}" ]; then
    for f in Dockerfile.modules module.catalog.json; do
        if [ ! -f "${HOST_BUILD_DIR}/${f}" ] && [ -f "${SEED_DIR}/${f}" ]; then
            cp "${SEED_DIR}/${f}" "${HOST_BUILD_DIR}/${f}"
        fi
    done
fi

if [ -f "${NGINX_CONF}" ] && ! grep -Fq 'modules-enabled/*.conf' "${NGINX_CONF}"; then
    sed -i "1i${MODULE_INCLUDE}" "${NGINX_CONF}"
fi

exec "$@"
