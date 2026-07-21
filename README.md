# AppToDocker

每个应用独立的 Docker 镜像构建工作流，手动触发。

## 目录结构

```
.
├── .github/
│   └── workflows/
│       ├── crush.yml          # Crush 专属工作流
│       ├── opencode.yml       # OpenCode 工作流（支持可选语言环境）
│       └── pi.yml             # Pi 工作流
├── apps/
│   ├── crush/                 # Crush 应用
│   │   └── Dockerfile
│   ├── opencode/              # OpenCode 应用
│   │   └── Dockerfile
│   ├── pi/                    # Pi 应用
│   │   └── Dockerfile
│   └── <other-app>/           # 添加更多应用
│       └── Dockerfile
└── README.md
```

## 添加新应用

1. 创建应用目录和 Dockerfile：
   ```bash
   mkdir apps/my-app
   # 在 apps/my-app/ 中创建 Dockerfile
   ```

2. 创建对应的工作流文件 `.github/workflows/my-app.yml`

## Crush

### 手动构建

在 GitHub Actions 页面选择 **"Build Crush Image"**，点击 **"Run workflow"**：

- **tag**：自定义镜像标签，默认 `latest`
- **push**：是否推送到仓库，默认 `true`

### 镜像地址

```
ghcr.io/<username>/AppToDocker/crush:<tag>
```

### 平台支持

| 平台 | 架构 | 说明 |
|------|------|------|
| linux/amd64 | x86_64 | 大多数服务器、PC |
| linux/arm64 | ARM64 | Apple Silicon (M1/M2/M3)、AWS Graviton、树莓派 4+ |

Docker 会自动拉取匹配当前系统的镜像。

### 使用镜像

```bash
# 拉取镜像
docker pull ghcr.io/wly2lcl/apptodocker/crush:latest
```

#### 前台运行（一次性使用）

```bash
docker run --rm -it \
  -e ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY:-}" \
  -e OPENAI_API_KEY="${OPENAI_API_KEY:-}" \
  -v "$(pwd):/workspace" \
  ghcr.io/wly2lcl/apptodocker/crush:latest
```

退出后容器自动删除。

#### 后台运行（持久使用）

```bash
# 启动容器
docker run -dit --name crush \
  -e ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY:-}" \
  -e OPENAI_API_KEY="${OPENAI_API_KEY:-}" \
  -v "$(pwd):/workspace" \
  ghcr.io/wly2lcl/apptodocker/crush:latest

# 进入 crush
docker attach crush

# 脱离容器（容器继续运行）
# Ctrl+P, 然后 Ctrl+Q

# 停止容器
docker stop crush

# 删除容器
docker rm crush
```

## OpenCode

### 手动构建

在 GitHub Actions 页面选择 **"Build Docker (Fork)"**，点击 **"Run workflow"**：

- **tag**：自定义镜像标签，默认 `dev`
- **release**：要嵌入的官方 release 版本（如 `v1.15.11` 或 `latest`），默认 `latest`
- **nodejs**：是否安装 Node.js 24.x LTS，默认不勾选
- **python**：是否安装 Python 3.14，默认不勾选
- **go**：是否安装 Go 1.26.0，默认不勾选
- **rust**：是否安装 Rust（最新稳定版），默认不勾选

语言环境按需勾选，不勾则不安装，镜像更小。

### 镜像地址

```
ghcr.io/<username>/AppToDocker/opencode:<tag>
```

### 平台支持

| 平台 | 架构 | 说明 |
|------|------|------|
| linux/amd64 | x86_64 | 大多数服务器、PC |
| linux/arm64 | ARM64 | Apple Silicon (M1/M2/M3)、AWS Graviton、树莓派 4+ |

Docker 会自动拉取匹配当前系统的镜像。

### 使用镜像

```bash
# 拉取镜像
docker pull ghcr.io/wly2lcl/apptodocker/opencode:latest
```

#### 前台运行（一次性使用）

```bash
docker run --rm -it \
  -e ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY:-}" \
  -e OPENAI_API_KEY="${OPENAI_API_KEY:-}" \
  -v "$(pwd):/workspace" \
  ghcr.io/wly2lcl/apptodocker/opencode:latest
```

退出后容器自动删除。

#### 后台运行（持久使用）

```bash
# 启动容器
docker run -dit --name opencode \
  -e ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY:-}" \
  -e OPENAI_API_KEY="${OPENAI_API_KEY:-}" \
  -v "$(pwd):/workspace" \
  ghcr.io/wly2lcl/apptodocker/opencode:latest

# 进入 opencode
docker attach opencode

# 脱离容器（容器继续运行）
# Ctrl+P, 然后 Ctrl+Q

# 停止容器
docker stop opencode

# 删除容器
docker rm opencode
```

## Pi

### 手动构建

在 GitHub Actions 页面选择 **"Build Pi Image"**，点击 **"Run workflow"**：

- **pi_version**：pi 版本号（对应 GitHub release tag，不含 v 前缀），默认 `0.80.10`

### 镜像地址

```
ghcr.io/<username>/AppToDocker/pi:<tag>
```

### 平台支持

| 平台 | 架构 | 说明 |
|------|------|------|
| linux/amd64 | x86_64 | 大多数服务器、PC |
| linux/arm64 | ARM64 | Apple Silicon (M1/M2/M3)、AWS Graviton、树莓派 4+ |

Docker 会自动拉取匹配当前系统的镜像。

### 使用镜像

```bash
# 拉取镜像
docker pull ghcr.io/wly2lcl/apptodocker/pi:latest
```

#### 前台运行（一次性使用）

```bash
docker run --rm -it \
  -e ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY:-}" \
  -v "$(pwd):/workspace" \
  -v pi-agent-home:/root/.pi/agent \
  ghcr.io/wly2lcl/apptodocker/pi:latest
```

退出后容器自动删除。使用命名卷 `pi-agent-home` 保存配置和 session 数据。

#### 后台运行（持久使用）

```bash
# 启动容器
docker run -dit --name pi \
  -e ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY:-}" \
  -v "$(pwd):/workspace" \
  -v pi-agent-home:/root/.pi/agent \
  ghcr.io/wly2lcl/apptodocker/pi:latest

# 进入 pi
docker attach pi

# 脱离容器（容器继续运行）
# Ctrl+P, 然后 Ctrl+Q

# 停止容器
docker stop pi

# 删除容器
docker rm pi
```

**注意**：使用命名卷 `pi-agent-home:/root/.pi/agent` 而非挂载宿主机目录，避免暴露宿主机认证信息给容器。

### 使用 pi-web（Web UI）

容器启动时会**自动运行** pi-web 服务。

#### ⚠️ 安全警告

pi-web **没有内置认证机制**。直接暴露到公网会导致任何人可以控制你的 AI agent 执行任意代码，非常危险。

**推荐的安全访问方式：**

1. **SSH 隧道（最简单）**：
   ```bash
   # 从你的电脑建立 SSH 隧道
   ssh -L 8504:localhost:8504 user@server
   
   # 然后浏览器访问 http://localhost:8504
   ```
   无需修改容器配置，流量通过 SSH 加密。

2. **反向代理 + HTTP 认证**（nginx/caddy）：
   ```bash
   # nginx 示例
   location / {
       auth_basic "Restricted";
       auth_basic_user_file /etc/nginx/.htpasswd;
       proxy_pass http://localhost:8504;
   }
   ```

3. **Tailscale / VPN**：
   - 所有设备加入同一个 Tailscale 网络
   - 通过 Tailscale 内网 IP 访问

#### 本地访问（默认绑定 127.0.0.1）

```bash
# 启动容器（pi-web 自动启动）
docker run -dit --name pi \
  -e ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY:-}" \
  -v "$(pwd):/workspace" \
  -v pi-agent-home:/root/.pi/agent \
  ghcr.io/wly2lcl/apptodocker/pi:latest

# 进入 pi
docker attach pi
```

然后在浏览器访问 `http://127.0.0.1:8504` 即可使用 Web UI。

#### 远程访问（绑定所有接口）

**必须先配置上述安全措施之一！**

```bash
# 启动容器，设置 PI_WEB_HOST 允许外部访问
docker run -dit --name pi \
  -p 8504:8504 \
  -e ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY:-}" \
  -e PI_WEB_HOST=0.0.0.0 \
  -v "$(pwd):/workspace" \
  -v pi-agent-home:/root/.pi/agent \
  ghcr.io/wly2lcl/apptodocker/pi:latest

# 进入 pi
docker attach pi
```

然后通过安全方式访问：
- SSH 隧道：`ssh -L 8504:localhost:8504 user@server` 后访问 `http://localhost:8504`
- 反向代理：访问 `https://your-domain.com`（需配置 nginx/caddy）
- Tailscale：访问 `http://<tailscale-ip>:8504`

#### 查看 pi-web 状态

```bash
# 进入容器
docker exec -it pi bash

# 查看 pi-web 进程
ps aux | grep pi-web

# 查看日志
tail -f /tmp/pi-web.log

# 重启 pi-web（如果需要）
pkill -f pi-web-server
PI_WEB_HOST=0.0.0.0 PI_WEB_PORT=8504 nohup pi-web-server > /tmp/pi-web.log 2>&1 &
```

## License

MIT
