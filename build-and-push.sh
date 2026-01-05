#!/bin/bash

# efinance Docker 镜像构建和推送脚本
# 用途：自动化构建 Docker 镜像并推送到 GitHub Container Registry

set -e  # 遇到错误立即退出

# 配置变量
GITHUB_USERNAME="robinspt"
IMAGE_NAME="efinance"
REGISTRY="ghcr.io"
FULL_IMAGE_NAME="${REGISTRY}/${GITHUB_USERNAME}/${IMAGE_NAME}"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 显示使用说明
show_usage() {
    cat << EOF
使用方法:
    $0 [选项] [版本号]

选项:
    -h, --help          显示此帮助信息
    -l, --login         仅执行登录操作
    -b, --build         仅构建镜像（不推送）
    -p, --push          仅推送镜像（不构建）
    --no-cache          构建时不使用缓存
    --latest            同时打上 latest 标签（默认）
    --no-latest         不打 latest 标签

示例:
    $0                  # 构建并推送 latest 版本
    $0 v1.0.0           # 构建并推送 v1.0.0 和 latest
    $0 --no-latest v1.0.0  # 仅构建并推送 v1.0.0
    $0 -b v1.0.0        # 仅构建 v1.0.0
    $0 -l               # 仅登录 GitHub Container Registry

EOF
}

# 检查 Docker 是否安装
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker 未安装，请先安装 Docker"
        exit 1
    fi
    print_info "Docker 已安装: $(docker --version)"
}

# 登录 GitHub Container Registry
login_github() {
    print_info "准备登录 GitHub Container Registry..."
    
    if [ -z "$GITHUB_TOKEN" ]; then
        print_warning "未找到 GITHUB_TOKEN 环境变量"
        echo -n "请输入你的 GitHub Personal Access Token: "
        read -s GITHUB_TOKEN
        echo
    fi
    
    if [ -z "$GITHUB_TOKEN" ]; then
        print_error "Token 不能为空"
        exit 1
    fi
    
    echo "$GITHUB_TOKEN" | docker login ${REGISTRY} -u ${GITHUB_USERNAME} --password-stdin
    
    if [ $? -eq 0 ]; then
        print_info "登录成功！"
    else
        print_error "登录失败"
        exit 1
    fi
}

# 构建 Docker 镜像
build_image() {
    local version=$1
    local no_cache=$2
    
    print_info "开始构建 Docker 镜像..."
    
    local build_args=""
    if [ "$no_cache" = "true" ]; then
        build_args="--no-cache"
    fi
    
    if [ -n "$version" ]; then
        print_info "构建版本: ${version}"
        docker build ${build_args} -t ${FULL_IMAGE_NAME}:${version} .
        
        if [ "$TAG_LATEST" = "true" ]; then
            print_info "同时打上 latest 标签"
            docker tag ${FULL_IMAGE_NAME}:${version} ${FULL_IMAGE_NAME}:latest
        fi
    else
        print_info "构建版本: latest"
        docker build ${build_args} -t ${FULL_IMAGE_NAME}:latest .
    fi
    
    print_info "镜像构建完成！"
    docker images | grep ${IMAGE_NAME}
}

# 推送 Docker 镜像
push_image() {
    local version=$1
    
    print_info "开始推送 Docker 镜像到 ${REGISTRY}..."
    
    if [ -n "$version" ]; then
        print_info "推送版本: ${version}"
        docker push ${FULL_IMAGE_NAME}:${version}
        
        if [ "$TAG_LATEST" = "true" ]; then
            print_info "推送 latest 标签"
            docker push ${FULL_IMAGE_NAME}:latest
        fi
    else
        print_info "推送版本: latest"
        docker push ${FULL_IMAGE_NAME}:latest
    fi
    
    print_info "镜像推送完成！"
    print_info "镜像地址: ${FULL_IMAGE_NAME}:${version:-latest}"
    print_info "查看镜像: https://github.com/${GITHUB_USERNAME}?tab=packages"
}

# 主函数
main() {
    local VERSION=""
    local ONLY_LOGIN=false
    local ONLY_BUILD=false
    local ONLY_PUSH=false
    local NO_CACHE=false
    local TAG_LATEST=true
    
    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -l|--login)
                ONLY_LOGIN=true
                shift
                ;;
            -b|--build)
                ONLY_BUILD=true
                shift
                ;;
            -p|--push)
                ONLY_PUSH=true
                shift
                ;;
            --no-cache)
                NO_CACHE=true
                shift
                ;;
            --latest)
                TAG_LATEST=true
                shift
                ;;
            --no-latest)
                TAG_LATEST=false
                shift
                ;;
            -*)
                print_error "未知选项: $1"
                show_usage
                exit 1
                ;;
            *)
                VERSION=$1
                shift
                ;;
        esac
    done
    
    check_docker
    
    # 仅登录
    if [ "$ONLY_LOGIN" = "true" ]; then
        login_github
        exit 0
    fi
    
    # 仅构建
    if [ "$ONLY_BUILD" = "true" ]; then
        build_image "$VERSION" "$NO_CACHE"
        exit 0
    fi
    
    # 仅推送
    if [ "$ONLY_PUSH" = "true" ]; then
        login_github
        push_image "$VERSION"
        exit 0
    fi
    
    # 完整流程：登录 -> 构建 -> 推送
    login_github
    build_image "$VERSION" "$NO_CACHE"
    push_image "$VERSION"
    
    print_info "========================================="
    print_info "所有操作完成！"
    print_info "========================================="
}

# 执行主函数
main "$@"

