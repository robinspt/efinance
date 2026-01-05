#!/bin/bash

# efinance 股票数据测试脚本 - Docker版本
# 测试股票代码: 601399

set -e

# 配置
IMAGE_NAME="ghcr.io/robinspt/efinance:latest"
DATA_DIR="./data"
SCRIPT_NAME="test_stock_docker.py"

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_tip() {
    echo -e "${BLUE}[TIP]${NC} $1"
}

# 显示使用说明
show_usage() {
    cat << EOF
efinance 股票数据测试脚本 - Docker版本

用法:
    $0 [选项]

选项:
    -h, --help      显示此帮助信息
    -p, --pull      运行前先拉取最新镜像
    -b, --build     使用本地构建的镜像

说明:
    - 测试股票代码: 601399
    - 测试9种股票数据获取函数
    - 每个函数间隔10-15秒随机时间
    - 所有数据保存到 $DATA_DIR/ 目录
    - 龙虎榜获取今日数据

测试项目:
    1. 股票基本信息
    2. K线数据（日K）
    3. 最新报价
    4. 龙虎榜（今日）
    5. 公司业绩
    6. 股东户数
    7. 前十大股东
    8. 历史资金流向
    9. 所属板块

示例:
    $0              # 直接运行测试
    $0 --pull       # 拉取最新镜像后运行
    $0 --build      # 使用本地构建的镜像运行

EOF
}

# 确保数据目录存在
ensure_data_dir() {
    if [ ! -d "$DATA_DIR" ]; then
        mkdir -p "$DATA_DIR"
        print_info "创建数据目录: $DATA_DIR"
    fi
}

# 检查脚本文件是否存在
check_script() {
    if [ ! -f "$SCRIPT_NAME" ]; then
        print_error "测试脚本不存在: $SCRIPT_NAME"
        exit 1
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

# 运行测试
run_test() {
    ensure_data_dir
    check_script
    
    print_info "开始运行股票数据测试..."
    print_tip "测试股票: 601399（工商银行）"
    print_tip "数据保存目录: $DATA_DIR/"
    echo ""
    
    # 运行 Docker 容器
    docker run --rm \
        -v "$(pwd)/$SCRIPT_NAME:/app/test.py:ro" \
        -v "$(pwd)/$DATA_DIR:/data" \
        "$IMAGE_NAME" python /app/test.py
    
    echo ""
    print_info "测试完成！"
    print_info "数据已保存到: $DATA_DIR/"
    echo ""
    
    # 显示生成的文件
    if [ -d "$DATA_DIR" ]; then
        print_info "生成的文件列表:"
        ls -lh "$DATA_DIR/"*.csv 2>/dev/null || print_warning "未找到CSV文件"
    fi
}

# 主函数
main() {
    local pull_flag=false
    local build_flag=false
    
    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -p|--pull)
                pull_flag=true
                shift
                ;;
            -b|--build)
                build_flag=true
                shift
                ;;
            *)
                print_error "未知选项: $1"
                echo ""
                show_usage
                exit 1
                ;;
        esac
    done
    
    # 拉取或构建镜像
    if [ "$pull_flag" = true ]; then
        pull_image
        echo ""
    fi
    
    if [ "$build_flag" = true ]; then
        build_image
        echo ""
    fi
    
    # 运行测试
    run_test
}

main "$@"

