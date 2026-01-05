# efinance 功能总结

## 📊 支持的所有数据类型

### 股票数据（18种）

| 分类 | 序号 | 功能 | API 函数 | 示例代码 |
|------|------|------|----------|----------|
| **基础数据** | 1 | 股票基本信息 | `get_base_info()` | `ef.stock.get_base_info('600519')` |
| | 2 | 日K线数据 | `get_quote_history()` | `ef.stock.get_quote_history('688802')` |
| | 3 | 5分钟K线 | `get_quote_history(klt=5)` | `ef.stock.get_quote_history('688802', klt=5)` |
| | 4 | 最新报价 | `get_latest_quote()` | `ef.stock.get_latest_quote('600519')` |
| | 5 | 行情快照 | `get_quote_snapshot()` | `ef.stock.get_quote_snapshot('600519')` |
| **市场数据** | 6 | 实时行情 | `get_realtime_quotes()` | `ef.stock.get_realtime_quotes()` |
| | 7 | 龙虎榜 | `get_daily_billboard()` | `ef.stock.get_daily_billboard()` |
| | 8 | 公司业绩 | `get_all_company_performance()` | `ef.stock.get_all_company_performance()` |
| | 9 | 股东户数 | `get_latest_holder_number()` | `ef.stock.get_latest_holder_number()` |
| | 10 | IPO信息 | `get_latest_ipo_info()` | `ef.stock.get_latest_ipo_info()` |
| **资金流向** | 11 | 历史资金流(日) | `get_history_bill()` | `ef.stock.get_history_bill('300750')` |
| | 12 | 今日资金流(分钟) | `get_today_bill()` | `ef.stock.get_today_bill('300750')` |
| **股东信息** | 13 | 前十大股东 | `get_top10_stock_holder_info()` | `ef.stock.get_top10_stock_holder_info('600519')` |
| **板块信息** | 14 | 所属板块 | `get_belong_board()` | `ef.stock.get_belong_board('600519')` |
| | 15 | 板块成员 | `get_members()` | `ef.stock.get_members('BK0001')` |
| **其他** | 16 | 成交明细 | `get_deal_detail()` | `ef.stock.get_deal_detail('600519')` |
| | 17 | 报告日期 | `get_all_report_dates()` | `ef.stock.get_all_report_dates()` |

### 基金数据（10种）

| 分类 | 序号 | 功能 | API 函数 | 示例代码 |
|------|------|------|----------|----------|
| **基础数据** | 1 | 基金基本信息 | `get_base_info()` | `ef.fund.get_base_info('161725')` |
| | 2 | 历史净值 | `get_quote_history()` | `ef.fund.get_quote_history('161725')` |
| | 3 | 多只基金净值 | `get_quote_history_multi()` | `ef.fund.get_quote_history_multi(['161725'])` |
| | 4 | 基金经理 | `get_fund_manager()` | `ef.fund.get_fund_manager('161725')` |
| | 5 | 基金代码列表 | `get_fund_codes()` | `ef.fund.get_fund_codes()` |
| **持仓信息** | 6 | 持仓信息 | `get_invest_position()` | `ef.fund.get_invest_position('161725')` |
| | 7 | 行业分布 | `get_industry_distribution()` | `ef.fund.get_industry_distribution('161725')` |
| | 8 | 资产占比 | `get_types_percentage()` | `ef.fund.get_types_percentage('161725')` |
| **业绩数据** | 9 | 实时涨跌幅 | `get_realtime_increase_rate()` | `ef.fund.get_realtime_increase_rate(['161725'])` |
| | 10 | 阶段涨跌 | `get_period_change()` | `ef.fund.get_period_change('161725')` |

---

## 🚀 五种使用方法

每种数据都可以通过以下5种方法获取：

### 方法 1：交互式 Shell
```bash
./run-docker.sh shell
>>> import efinance as ef
>>> df = ef.stock.get_quote_history('688802')
>>> print(df.head())
```

### 方法 2：单行命令
```bash
./run-docker.sh exec "import efinance as ef; print(ef.stock.get_quote_history('688802').head())"
```

### 方法 3：Python 脚本
```bash
# 创建脚本
cat > my_script.py << 'EOF'
import efinance as ef
df = ef.stock.get_quote_history('688802')
print(df.head())
EOF

# 运行脚本
./run-docker.sh run my_script.py
```

### 方法 4：docker-compose
```bash
docker-compose run --rm app python -c "import efinance as ef; print(ef.stock.get_quote_history('688802').head())"
```

### 方法 5：Docker 命令
```bash
docker run --rm ghcr.io/robinspt/efinance:latest python -c "
import efinance as ef
print(ef.stock.get_quote_history('688802').head())
"
```

---

## 📖 快速开始

### 运行完整示例
```bash
# 使用默认股票代码 (688802) 和基金代码 (161725)
./run-docker.sh run examples/all_features_example.py

# 指定股票代码
./run-docker.sh run examples/all_features_example.py 600519

# 指定股票和基金代码
./run-docker.sh run examples/all_features_example.py 600519 005827
```

### 获取特定数据
```bash
# 股票基本信息
./run-docker.sh exec "import efinance as ef; print(ef.stock.get_base_info('600519'))"

# 基金历史净值
./run-docker.sh exec "import efinance as ef; print(ef.fund.get_quote_history('161725').head())"

# 实时行情
./run-docker.sh exec "import efinance as ef; print(ef.stock.get_realtime_quotes().head(10))"
```

---

## 📚 相关文档

- **[README.md](README.md)** - 项目主文档
- **[README_DOCKER.md](README_DOCKER.md)** - Docker 构建和推送指南
- **[DOCKER_FEATURES_GUIDE.md](DOCKER_FEATURES_GUIDE.md)** - 完整功能使用指南

---

## 💡 使用建议

1. **新手用户**：从交互式 Shell 开始，逐步熟悉 API
2. **快速查询**：使用单行命令快速获取数据
3. **批量处理**：编写 Python 脚本处理多只股票/基金
4. **自动化**：使用 docker-compose 或 Docker 命令集成到自动化流程

---

**总计支持：28种数据类型 × 5种使用方法 = 140+ 种使用场景** 🎉

