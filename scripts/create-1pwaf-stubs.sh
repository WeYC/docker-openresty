#!/bin/bash
# Script to create stub 1pwaf files in the container
# Run this after container start if you need to bypass 1pwaf errors

set -e

PWAF_DIR="/usr/local/openresty/1pwaf"

# Create directories
mkdir -p "$PWAF_DIR/lib"
mkdir -p "$PWAF_DIR/data/conf"
mkdir -p "$PWAF_DIR/data/db"
mkdir -p "$PWAF_DIR/data/default"
mkdir -p "$PWAF_DIR/data/geo"
mkdir -p "$PWAF_DIR/data/html"
mkdir -p "$PWAF_DIR/data/rules"

# Create stub Lua files
cat > "$PWAF_DIR/init.lua" << 'EOF'
-- Stub init.lua for 1pwaf compatibility
-- This is a fake/stub file to prevent nginx startup errors
EOF

cat > "$PWAF_DIR/waf.lua" << 'EOF'
-- Stub waf.lua for 1pwaf compatibility
-- This is a fake/stub file to prevent nginx startup errors
EOF

cat > "$PWAF_DIR/log_and_traffic.lua" << 'EOF'
-- Stub log_and_traffic.lua for 1pwaf compatibility
-- This is a fake/stub file to prevent nginx startup errors
EOF

cat > "$PWAF_DIR/worker.lua" << 'EOF'
-- Stub worker.lua for 1pwaf compatibility
-- This is a fake/stub file to prevent nginx startup errors
EOF

# Create stub waf.conf
cat > "$PWAF_DIR/data/conf/waf.conf" << 'EOF'
lua_shared_dict waf_locks 1m;

lua_code_cache on;
lua_package_path "/usr/local/openresty/1pwaf/?.lua;/usr/local/openresty/1pwaf/lib/?.lua;;";
init_by_lua_file  /usr/local/openresty/1pwaf/init.lua;
access_by_lua_file /usr/local/openresty/1pwaf/waf.lua;
log_by_lua_file /usr/local/openresty/1pwaf/log_and_traffic.lua;
init_worker_by_lua_file /usr/local/openresty/1pwaf/worker.lua;
EOF

echo "1pwaf stub files created successfully at $PWAF_DIR"