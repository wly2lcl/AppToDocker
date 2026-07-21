# Stage 1: 下载 standalone pi 二进制（Bun 编译，无需 Node.js 运行时）
FROM debian:bookworm-slim AS downloader
ARG PI_VERSION=0.80.10

RUN apt-get update \
  && apt-get install -y --no-install-recommends curl ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN ARCH=$(uname -m | sed 's/x86_64/x64/; s/aarch64/arm64/') \
    && echo "Detected arch: ${ARCH}" \
    && curl -fsSL "https://github.com/earendil-works/pi/releases/download/v${PI_VERSION}/pi-linux-${ARCH}.tar.gz" \
       -o /tmp/pi.tar.gz \
    && mkdir -p /opt/pi \
    && tar -xzf /tmp/pi.tar.gz -C /opt/pi --strip-components=1 \
    && rm /tmp/pi.tar.gz

# Stage 2: 最终镜像 — Node.js 仅用于 pi-web，pi 本身用 standalone binary
FROM node:24-bookworm-slim

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
       bash \
       ca-certificates \
       git \
       ripgrep \
  && rm -rf /var/lib/apt/lists/*

# standalone pi（替代 npm install -g pi-coding-agent）
COPY --from=downloader /opt/pi /opt/pi
ENV PATH="/opt/pi:${PATH}"

# pi-web 仍需 Node.js
RUN npm config set allow-scripts true \
  && npm install -g @agegr/pi-web \
  && npm cache clean --force

# 复制启动脚本
COPY start-pi.sh /usr/local/bin/start-pi.sh
RUN chmod +x /usr/local/bin/start-pi.sh

WORKDIR /workspace
ENTRYPOINT ["/usr/local/bin/start-pi.sh"]
