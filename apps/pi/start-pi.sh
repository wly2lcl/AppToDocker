#!/bin/bash
set -e

# 启动 pi-web
export PI_WEB_HOST=${PI_WEB_HOST:-127.0.0.1}
export PI_WEB_PORT=${PI_WEB_PORT:-8504}
echo "Starting pi-web server on ${PI_WEB_HOST}:${PI_WEB_PORT}..."
nohup pi-web --hostname "$PI_WEB_HOST" --port "$PI_WEB_PORT" --no-open > /tmp/pi-web.log 2>&1 &
sleep 2

# 启动 pi
exec pi "$@"
