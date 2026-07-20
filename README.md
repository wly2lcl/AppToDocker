# AppToDocker

每个应用独立的 Docker 镜像构建工作流，手动触发。

## 目录结构

```
.
├── .github/
│   └── workflows/
│       ├── crush.yml          # Crush 专属工作流
│       └── opencode.yml       # OpenCode 工作流（支持可选语言环境）
├── apps/
│   ├── crush/                 # Crush 应用
│   │   └── Dockerfile
│   ├── opencode/              # OpenCode 应用
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
- **nodejs**：是否安装 Node.js 22.x LTS，默认不勾选
- **python**：是否安装 Python 3.12，默认不勾选
- **go**：是否安装 Go 1.26，默认不勾选
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

## License

MIT
