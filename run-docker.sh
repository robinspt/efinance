#!/bin/bash

# efinance Docker 快速运行脚本
# 用途：简化 Docker 镜像的使用

set -e

# 配置
IMAGE_NAME="ghcr.io/robinspt/efinance:latest"
DATA_DIR="./data"

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_tip() {
    echo -e "${BLUE}[TIP]${NC} $1"
}

show_usage() {
    cat << EOF
efinance Docker 快速运行工具

用法:
    $0 [命令] [参数]

命令:
    shell               启动交互式 Python shell
    ipython             启动 IPython shell
    example [股票代码] [基金代码]   运行示例脚本（默认: 688802 161725）
    run <脚本路径>       运行自定义 Python 脚本
    exec <Python代码>   执行单行 Python 代码
    bash                进入容器 bash shell
    pull                拉取最新镜像
    build               构建本地镜像

示例:
    $0 shell                    # 启动 Python shell
    $0 example 600519           # 获取股票 600519 的数据
    $0 example 600519 005827    # 获取股票 600519 和基金 005827 的数据
    $0 run my_script.py         # 运行自定义脚本
    $0 exec "import efinance as ef; print(ef.stock.get_quote_history('688802').head())"

支持的数据类型:
    - 股票数据: 18种（基本信息、K线、实时行情、资金流向等）
    - 基金数据: 10种（基本信息、净值、持仓、业绩等）

详细文档:
    - DOCKER_FEATURES_GUIDE.md - 完整功能使用指南
    - README_DOCKER.md - Docker 构建和推送指南

EOF
}

# 确保数据目录存在
ensure_data_dir() {
    if [ ! -d "$DATA_DIR" ]; then
        mkdir -p "$DATA_DIR"
        print_info "创建数据目录: $DATA_DIR"
    fi
}

# 拉取镜像
pull_image() {
    print_info "拉取最新镜像..."
    docker pull "$IMAGE_NAME"
    print_info "镜像拉取完成"
}

# 构建镜像
build_image() {
    print_info "构建本地镜像..."
    docker build -t "$IMAGE_NAME" .
    print_info "镜像构建完成"
}

# 启动 Python shell
run_shell() {
    ensure_data_dir
    print_info "启动 Python shell..."
    print_tip "在 Python 中输入: import efinance as ef"
    print_tip "获取数据: df = ef.stock.get_quote_history('688802')"
    echo ""
    
    docker run -it --rm \
        -v "$(pwd)/examples:/scripts:ro" \
        -v "$(pwd)/$DATA_DIR:/data" \
        "$IMAGE_NAME" python
}

# 启动 IPython
run_ipython() {
    ensure_data_dir
    print_info "启动 IPython shell..."
    echo ""
    
    docker run -it --rm \
        -v "$(pwd)/examples:/scripts:ro" \
        -v "$(pwd)/$DATA_DIR:/data" \
        "$IMAGE_NAME" ipython
}

# 运行示例脚本
run_example() {
    local stock_code=${1:-688802}
    ensure_data_dir
    
    print_info "运行示例脚本，股票代码: $stock_code"
    echo ""
    
    docker run --rm \
        -v "$(pwd)/examples:/scripts:ro" \
        -v "$(pwd)/$DATA_DIR:/data" \
        "$IMAGE_NAME" python /scripts/all_features_example.py "$stock_code"
    
    echo ""
    print_info "数据已保存到: $DATA_DIR/"
    ls -lh "$DATA_DIR/" 2>/dev/null || true
}

# 运行自定义脚本
run_script() {
    local script_path=$1
    
    if [ -z "$script_path" ]; then
        echo "错误: 请指定脚本路径"
        echo "用法: $0 run <脚本路径>"
        exit 1
    fi
    
    if [ ! -f "$script_path" ]; then
        echo "错误: 脚本文件不存在: $script_path"
        exit 1
    fi
    
    ensure_data_dir
    print_info "运行脚本: $script_path"
    echo ""
    
    docker run --rm \
        -v "$(pwd)/$script_path:/app/script.py:ro" \
        -v "$(pwd)/$DATA_DIR:/data" \
        "$IMAGE_NAME" python /app/script.py
}

# 执行 Python 代码
exec_python() {
    local code=$1
    
    if [ -z "$code" ]; then
        echo "错误: 请指定要执行的 Python 代码"
        echo "用法: $0 exec '<Python代码>'"
        exit 1
    fi
    
    ensure_data_dir
    print_info "执行 Python 代码..."
    echo ""
    
    docker run --rm \
        -v "$(pwd)/$DATA_DIR:/data" \
        "$IMAGE_NAME" python -c "$code"
}

# 进入 bash shell
run_bash() {
    ensure_data_dir
    print_info "进入容器 bash shell..."
    echo ""
    
    docker run -it --rm \
        -v "$(pwd)/examples:/scripts:ro" \
        -v "$(pwd)/$DATA_DIR:/data" \
        "$IMAGE_NAME" bash
}

# 主函数
main() {
    local command=${1:-shell}
    shift || true
    
    case $command in
        shell)
            run_shell
            ;;
        ipython)
            run_ipython
            ;;
        example)
            run_example "$@"
            ;;
        run)
            run_script "$@"
            ;;
        exec)
            exec_python "$@"
            ;;
        bash)
            run_bash
            ;;
        pull)
            pull_image
            ;;
        build)
            build_image
            ;;
        -h|--help|help)
            show_usage
            ;;
        *)
            echo "错误: 未知命令: $command"
            echo ""
            show_usage
            exit 1
            ;;
    esac
}

main "$@"

