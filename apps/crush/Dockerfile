# 构建阶段：安装并提取 Crush 核心二进制
FROM ubuntu:24.04 AS builder

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update \
  && apt install -y --no-install-recommends curl gpg ca-certificates \
  && mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://repo.charm.sh/apt/gpg.key | gpg --dearmor -o /etc/apt/keyrings/charm.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | tee /etc/apt/sources.list.d/charm.list \
  && apt update \
  && apt install -y --no-install-recommends crush \
  && mkdir -p /output/usr/bin \
  && cp /usr/bin/crush /output/usr/bin/

# 运行阶段：极简基础镜像
FROM debian:bookworm-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update \
  && apt install -y --no-install-recommends \
    ca-certificates \
    coreutils \
    bash \
    git \
  && apt clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 从构建阶段复制纯净的 Crush 二进制
COPY --from=builder /output/usr/bin/crush /usr/bin/crush

WORKDIR /workspace
ENTRYPOINT ["crush"]