# 测试脚本对比说明

## 📋 概述

本项目提供了两套测试脚本：**本地版本** 和 **Docker版本**，用于测试 efinance 库的股票数据获取功能。

## 🔄 两个版本对比

### 快速对比表

| 特性 | 本地版本 | Docker版本 |
|------|----------|-----------|
| **脚本名称** | `test_stock_functions.py` | `test_stock_docker.py` |
| **运行脚本** | - | `run-test-docker.sh` |
| **运行环境** | 本地 Python 环境 | Docker 容器 |
| **测试股票** | 600895（张江高科） | 601399（工商银行） |
| **数据目录** | `./data/` | `./data/` (挂载到容器) |
| **依赖安装** | 需要手动安装 | 镜像已包含所有依赖 |
| **运行方式** | `python test_stock_functions.py` | `./run-test-docker.sh` |
| **龙虎榜** | 获取所有上榜股票 | 获取今日数据 |
| **适用场景** | 开发调试、本地测试 | 生产环境、CI/CD |

---

## 📝 详细对比

### 1. 本地版本 (test_stock_functions.py)

#### 优点
- ✅ 运行速度快（无需启动容器）
- ✅ 调试方便（可直接修改代码）
- ✅ 适合开发环境

#### 缺点
- ❌ 需要手动安装依赖
- ❌ 环境可能不一致
- ❌ 需要配置 Python 环境

#### 使用方法

```bash
# 1. 安装依赖
pip install efinance pandas

# 2. 运行测试
python test_stock_functions.py
```

#### 测试股票
- **600895** - 张江高科

#### 输出文件示例
```
data/
├── 600895_基本信息.csv
├── 600895_日K线.csv
├── 600895_最新报价.csv
├── 龙虎榜_YYYY-MM-DD.csv  (所有上榜股票)
├── 600895_公司业绩.csv
├── 600895_股东户数.csv
├── 600895_前十大股东.csv
├── 600895_历史资金流向.csv
└── 600895_所属板块.csv
```

---

### 2. Docker版本 (test_stock_docker.py)

#### 优点
- ✅ 环境一致性（所有依赖已打包）
- ✅ 无需安装 Python 和依赖
- ✅ 适合生产环境和 CI/CD
- ✅ 隔离性好（不影响本地环境）

#### 缺点
- ❌ 需要安装 Docker
- ❌ 首次运行需要拉取镜像（约200MB）
- ❌ 启动稍慢（需要启动容器）

#### 使用方法

```bash
# 方法1: 直接运行
./run-test-docker.sh

# 方法2: 拉取最新镜像后运行
./run-test-docker.sh --pull

# 方法3: 使用本地构建的镜像
./run-test-docker.sh --build
```

#### 测试股票
- **601399** - 工商银行

#### 输出文件示例
```
data/
├── 601399_基本信息.csv
├── 601399_日K线.csv
├── 601399_最新报价.csv
├── 龙虎榜_YYYY-MM-DD.csv  (今日上榜股票)
├── 601399_公司业绩.csv
├── 601399_股东户数.csv
├── 601399_前十大股东.csv
├── 601399_历史资金流向.csv
└── 601399_所属板块.csv
```

---

## 🎯 使用场景推荐

### 选择本地版本的场景

1. **开发调试**
   - 需要频繁修改代码
   - 需要快速测试功能
   - 本地已有 Python 环境

2. **学习探索**
   - 学习 efinance 库的使用
   - 探索不同的股票数据
   - 需要交互式调试

3. **快速验证**
   - 快速验证某个功能
   - 临时测试某只股票
   - 不需要环境隔离

### 选择 Docker 版本的场景

1. **生产环境**
   - 需要环境一致性
   - 多人协作开发
   - 部署到服务器

2. **CI/CD 流程**
   - 自动化测试
   - 持续集成
   - 定时任务

3. **无 Python 环境**
   - 不想安装 Python
   - 不想配置依赖
   - 需要快速开始

---

## 📊 测试项目（两个版本相同）

| 序号 | 数据类型 | 函数 | 字段数 |
|------|----------|------|--------|
| 1 | 股票基本信息 | `ef.stock.get_base_info()` | 12 |
| 2 | K线数据（日K） | `ef.stock.get_quote_history()` | 13 |
| 3 | 最新报价 | `ef.stock.get_latest_quote()` | 20 |
| 4 | 龙虎榜 | `ef.stock.get_daily_billboard()` | 16 |
| 5 | 公司业绩 | `ef.stock.get_all_company_performance()` | 14 |
| 6 | 股东户数 | `ef.stock.get_latest_holder_number()` | 11 |
| 7 | 前十大股东 | `ef.stock.get_top10_stock_holder_info()` | 8 |
| 8 | 历史资金流向 | `ef.stock.get_history_bill()` | 15 |
| 9 | 所属板块 | `ef.stock.get_belong_board()` | 5 |

---

## 🔧 技术细节对比

### 本地版本

```python
# 数据保存路径
data_dir = 'data'

# 运行环境
- Python 3.7+
- pandas
- efinance
```

### Docker版本

```python
# 数据保存路径（容器内）
data_dir = '/data'

# Docker 挂载
docker run --rm \
    -v "$(pwd)/test_stock_docker.py:/app/test.py:ro" \
    -v "$(pwd)/data:/data" \
    ghcr.io/robinspt/efinance:latest python /app/test.py
```

---

## 📚 相关文档

### 本地版本
- [TEST_SCRIPTS_README.md](TEST_SCRIPTS_README.md) - 本地测试脚本详细说明

### Docker版本
- [DOCKER_TEST_README.md](DOCKER_TEST_README.md) - Docker 测试脚本详细说明
- [DOCKER_FEATURES_GUIDE.md](DOCKER_FEATURES_GUIDE.md) - Docker 完整功能使用指南

### 通用文档
- [TESTED_FUNCTIONS_SUMMARY.md](TESTED_FUNCTIONS_SUMMARY.md) - 测试函数详细说明（字段、示例）

---

## 💡 快速开始

### 本地版本
```bash
# 安装依赖
pip install efinance pandas

# 运行测试
python test_stock_functions.py
```

### Docker版本
```bash
# 直接运行（推荐）
./run-test-docker.sh

# 或者拉取最新镜像后运行
./run-test-docker.sh --pull
```

---

**创建时间**: 2026-01-05  
**版本**: v1.0

