#!/bin/bash
set -e

# 启动 pi-web（如果已安装）
if command -v pi-web-server >/dev/null 2>&1; then
  export PI_WEB_HOST=${PI_WEB_HOST:-127.0.0.1}
  export PI_WEB_PORT=${PI_WEB_PORT:-8504}
  echo "Starting pi-web server on ${PI_WEB_HOST}:${PI_WEB_PORT}..."
  nohup pi-web-server > /tmp/pi-web.log 2>&1 &
  sleep 2
fi

# 启动 pi
exec pi "$@"
