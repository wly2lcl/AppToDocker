FROM node:24-bookworm-slim

ARG INSTALL_PI_SUBAGENTS=false
ARG INSTALL_PI_HASHLINE_READMAP=false

# 安装运行时依赖
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
       bash \
       ca-certificates \
       git \
       ripgrep \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g @earendil-works/pi-coding-agent @agegr/pi-web

RUN if [ "$INSTALL_PI_SUBAGENTS" = "true" ]; then \
      npm install -g pi-subagents; \
    fi
RUN if [ "$INSTALL_PI_HASHLINE_READMAP" = "true" ]; then \
      npm install -g pi-hashline-readmap; \
    fi

RUN npm cache clean --force

# 复制启动脚本
COPY start-pi.sh /usr/local/bin/start-pi.sh
RUN chmod +x /usr/local/bin/start-pi.sh

WORKDIR /workspace
ENTRYPOINT ["/usr/local/bin/start-pi.sh"]
