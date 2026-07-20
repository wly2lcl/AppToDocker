FROM node:24-bookworm-slim

ARG INSTALL_PI_WEB=true
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

RUN npm install -g --ignore-scripts @earendil-works/pi-coding-agent

# 如果需要编译，临时安装构建工具，安装完删除
RUN if [ "$INSTALL_PI_WEB" = "true" ]; then \
      apt-get update \
      && apt-get install -y --no-install-recommends build-essential python3 \
      && npm install -g @jmfederico/pi-web \
      && apt-get purge -y build-essential python3 \
      && apt-get autoremove -y \
      && rm -rf /var/lib/apt/lists/*; \
    fi

RUN if [ "$INSTALL_PI_SUBAGENTS" = "true" ]; then \
      npm install -g pi-subagents; \
    fi
RUN if [ "$INSTALL_PI_HASHLINE_READMAP" = "true" ]; then \
      npm install -g pi-hashline-readmap; \
    fi

# 复制启动脚本
COPY start-pi.sh /usr/local/bin/start-pi.sh
RUN chmod +x /usr/local/bin/start-pi.sh

WORKDIR /workspace
ENTRYPOINT ["/usr/local/bin/start-pi.sh"]
