# Docker 构建和推送指南

本文档说明如何使用自动化脚本构建 Docker 镜像并推送到 GitHub Container Registry。

> **📌 重要提示**: Dockerfile 已配置自动关联到 GitHub 仓库的 LABEL，推送后镜像会自动显示在仓库页面。

## 前置准备

### 1. 创建 GitHub Personal Access Token (PAT)

1. 访问 GitHub Token 设置页面：https://github.com/settings/tokens
2. 点击 **"Generate new token"** → **"Generate new token (classic)"**
3. 设置 Token 信息：
   - **Note**: 填写描述，例如 "Docker Registry Access"
   - **Expiration**: 选择过期时间（建议选择 90 天或自定义）
   - **Select scopes**: 勾选以下权限
     - ✅ `write:packages` - 上传包到 GitHub Package Registry
     - ✅ `read:packages` - 从 GitHub Package Registry 下载包
     - ✅ `delete:packages` - 删除 GitHub Package Registry 的包
4. 点击 **"Generate token"** 生成 Token
5. **重要**: 复制并保存 Token（离开页面后将无法再次查看）

### 2. 设置环境变量（可选）

为了避免每次都输入 Token，可以将其设置为环境变量：

```bash
# 临时设置（当前终端会话有效）
export GITHUB_TOKEN="your_github_token_here"

# 永久设置（添加到 ~/.bashrc 或 ~/.zshrc）
echo 'export GITHUB_TOKEN="your_github_token_here"' >> ~/.bashrc
source ~/.bashrc
```

## 使用自动化脚本

### 赋予执行权限

```bash
chmod +x build-and-push.sh
```

### 基本用法

#### 1. 构建并推送 latest 版本

```bash
./build-and-push.sh
```

这将：
- 登录 GitHub Container Registry
- 构建镜像并打上 `latest` 标签
- 推送到 `ghcr.io/robinspt/efinance:latest`

#### 2. 构建并推送指定版本

```bash
./build-and-push.sh v1.0.0
```

这将：
- 构建镜像并打上 `v1.0.0` 和 `latest` 标签
- 推送两个标签到 GitHub

#### 3. 仅推送指定版本（不打 latest 标签）

```bash
./build-and-push.sh --no-latest v1.0.0
```

### 高级用法

#### 仅登录（测试 Token 是否有效）

```bash
./build-and-push.sh --login
```

#### 仅构建镜像（不推送）

```bash
./build-and-push.sh --build v1.0.0
```

#### 仅推送镜像（不构建）

```bash
./build-and-push.sh --push v1.0.0
```

#### 不使用缓存构建

```bash
./build-and-push.sh --no-cache v1.0.0
```

#### 查看帮助信息

```bash
./build-and-push.sh --help
```

## 使用 docker-compose

### 构建镜像

```bash
docker-compose build
```

### 推送镜像

```bash
# 需要先登录
echo "$GITHUB_TOKEN" | docker login ghcr.io -u robinspt --password-stdin

# 推送镜像
docker-compose push
```

### 一步完成构建和推送

```bash
docker-compose build && docker-compose push
```

## 拉取和使用镜像

### 设置镜像为公开（可选）

1. 访问：https://github.com/robinspt?tab=packages
2. 找到 `efinance` 包
3. 点击 **Package settings**
4. 在 **Danger Zone** 中点击 **Change visibility**
5. 选择 **Public** 并确认

### 拉取镜像

```bash
# 拉取 latest 版本
docker pull ghcr.io/robinspt/efinance:latest

# 拉取指定版本
docker pull ghcr.io/robinspt/efinance:v1.0.0
```

### 运行容器

```bash
# 使用 docker run
docker run -it ghcr.io/robinspt/efinance:latest python

# 使用 docker-compose
docker-compose up
```

## 常见问题

### 1. 登录失败

**错误信息**: `Error response from daemon: Get https://ghcr.io/v2/: unauthorized`

**解决方法**:
- 检查 Token 是否正确
- 确认 Token 具有 `write:packages` 权限
- 重新生成 Token 并重试

### 2. 推送失败（权限不足）

**错误信息**: `denied: permission_denied`

**解决方法**:
- 确认你是仓库的所有者或有推送权限
- 检查 Token 权限是否包含 `write:packages`

### 3. 镜像构建失败

**解决方法**:
- 检查 Dockerfile 语法
- 使用 `--no-cache` 选项重新构建
- 查看详细错误日志

## 镜像信息

- **Registry**: GitHub Container Registry (ghcr.io)
- **镜像名称**: `ghcr.io/robinspt/efinance`
- **支持的标签**:
  - `latest` - 最新版本
  - `v1.0.0`, `v1.0.1` 等 - 特定版本

## 相关链接

- GitHub 仓库: https://github.com/robinspt/efinance
- GitHub Packages: https://github.com/robinspt?tab=packages
- Token 设置: https://github.com/settings/tokens
- Docker 文档: https://docs.docker.com/
- GitHub Container Registry 文档: https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry

