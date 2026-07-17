# AppToDocker

每个应用独立的 Docker 镜像构建工作流，手动触发。

## 目录结构

```
.
├── .github/
│   └── workflows/
│       └── crush.yml          # Crush 专属工作流
├── apps/
│   ├── crush/                 # Crush 应用
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
docker pull ghcr.io/<username>/AppToDocker/crush:latest

# 运行（挂载当前目录到 /workspace）
docker run --rm -it -v $(pwd):/workspace ghcr.io/<username>/AppToDocker/crush:latest

# 指定命令参数
docker run --rm -it -v $(pwd):/workspace ghcr.io/<username>/AppToDocker/crush:latest <command>
```

## License

MIT
