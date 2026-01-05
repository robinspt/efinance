# efinance Docker 完整功能使用指南

本文档详细说明如何使用 Docker 镜像获取所有类型的金融数据。

## 📊 支持的数据类型

### 股票数据（18种）

#### 基础数据
1. ✅ 股票基本信息 - `ef.stock.get_base_info()`
2. ✅ 股票日K线数据 - `ef.stock.get_quote_history()`
3. ✅ 5分钟K线数据 - `ef.stock.get_quote_history(klt=5)`
4. ✅ 最新报价 - `ef.stock.get_latest_quote()`
5. ✅ 行情快照 - `ef.stock.get_quote_snapshot()`

#### 市场数据
6. ✅ 沪深A股实时行情 - `ef.stock.get_realtime_quotes()`
7. ✅ 股票龙虎榜 - `ef.stock.get_daily_billboard()`
8. ✅ 公司业绩 - `ef.stock.get_all_company_performance()`
9. ✅ 最新股东户数 - `ef.stock.get_latest_holder_number()`
10. ✅ 最新IPO信息 - `ef.stock.get_latest_ipo_info()`

#### 资金流向
11. ✅ 历史资金流向(日级) - `ef.stock.get_history_bill()`
12. ✅ 今日资金流向(分钟级) - `ef.stock.get_today_bill()`

#### 股东信息
13. ✅ 前十大股东 - `ef.stock.get_top10_stock_holder_info()`

#### 板块信息
14. ✅ 所属板块 - `ef.stock.get_belong_board()`
15. ✅ 板块成员股票 - `ef.stock.get_members()`

#### 其他
16. ✅ 成交明细 - `ef.stock.get_deal_detail()`
17. ✅ 所有报告日期 - `ef.stock.get_all_report_dates()`

### 基金数据（10种）

#### 基础数据
1. ✅ 基金基本信息 - `ef.fund.get_base_info()`
2. ✅ 基金历史净值 - `ef.fund.get_quote_history()`
3. ✅ 多只基金历史净值 - `ef.fund.get_quote_history_multi()`
4. ✅ 基金经理信息 - `ef.fund.get_fund_manager()`
5. ✅ 基金代码列表 - `ef.fund.get_fund_codes()`

#### 持仓信息
6. ✅ 基金持仓信息 - `ef.fund.get_invest_position()`
7. ✅ 行业分布 - `ef.fund.get_industry_distribution()`
8. ✅ 资产类型占比 - `ef.fund.get_types_percentage()`

#### 业绩数据
9. ✅ 实时涨跌幅 - `ef.fund.get_realtime_increase_rate()`
10. ✅ 阶段涨跌 - `ef.fund.get_period_change()`

---

## 🚀 五种使用方法

每种数据获取功能都可以通过以下5种方法使用：

### 方法 1️⃣：使用快捷脚本 + 交互式 Shell（推荐新手）

**优点**: 最简单，适合探索和测试

```bash
# 启动 Python shell
./run-docker.sh shell

# 在 Python 中执行
>>> import efinance as ef
>>> # 获取数据
>>> df = ef.stock.get_quote_history('688802')
>>> print(df.head())
```

### 方法 2️⃣：使用快捷脚本 + 单行命令（推荐快速查询）

**优点**: 快速执行，无需进入交互环境

```bash
./run-docker.sh exec "import efinance as ef; print(ef.stock.get_quote_history('688802').head())"
```

### 方法 3️⃣：使用快捷脚本 + Python 脚本（推荐批量处理）

**优点**: 适合复杂逻辑和批量处理

```bash
# 运行示例脚本
./run-docker.sh run examples/all_features_example.py

# 运行自定义脚本
./run-docker.sh run my_script.py
```

### 方法 4️⃣：使用 docker-compose（推荐团队协作）

**优点**: 配置统一，易于分享

```bash
# 交互式
docker-compose run --rm app python

# 运行脚本
docker-compose run --rm app python /scripts/all_features_example.py
```

### 方法 5️⃣：直接使用 Docker 命令（推荐自动化）

**优点**: 最灵活，适合集成到其他系统

```bash
# 交互式
docker run -it --rm ghcr.io/robinspt/efinance:latest python

# 单行命令
docker run --rm ghcr.io/robinspt/efinance:latest python -c "
import efinance as ef
print(ef.stock.get_quote_history('688802').head())
"

# 运行脚本
docker run --rm \
  -v $(pwd)/my_script.py:/app/script.py \
  ghcr.io/robinspt/efinance:latest python /app/script.py
```

---

## 📋 完整功能示例

以下展示每种数据类型的5种获取方法。

## 一、股票数据

### 1. 股票日K线数据

#### 方法 1：交互式 Shell
```bash
./run-docker.sh shell
```
```python
>>> import efinance as ef
>>> df = ef.stock.get_quote_history('688802')
>>> print(df.head())
```

#### 方法 2：单行命令
```bash
./run-docker.sh exec "import efinance as ef; print(ef.stock.get_quote_history('688802').head())"
```

#### 方法 3：Python 脚本
创建 `get_stock_daily.py`:
```python
import efinance as ef
df = ef.stock.get_quote_history('688802')
print(df.head())
df.to_csv('/data/688802_daily.csv', index=False)
```
运行:
```bash
./run-docker.sh run get_stock_daily.py
```

#### 方法 4：docker-compose
```bash
docker-compose run --rm app python -c "import efinance as ef; print(ef.stock.get_quote_history('688802').head())"
```

#### 方法 5：Docker 命令
```bash
docker run --rm ghcr.io/robinspt/efinance:latest python -c "
import efinance as ef
print(ef.stock.get_quote_history('688802').head())
"
```

---

### 2. ETF K线数据

#### 方法 1：交互式 Shell
```bash
./run-docker.sh shell
```
```python
>>> import efinance as ef
>>> # 中概互联网ETF
>>> df = ef.stock.get_quote_history('513050')
>>> print(df.head())
```

#### 方法 2：单行命令
```bash
./run-docker.sh exec "import efinance as ef; print(ef.stock.get_quote_history('513050').head())"
```

#### 方法 3：Python 脚本
创建 `get_etf.py`:
```python
import efinance as ef
etf_code = '513050'  # 中概互联网ETF
df = ef.stock.get_quote_history(etf_code)
print(f"ETF {etf_code} 数据:")
print(df.head())
df.to_csv(f'/data/{etf_code}_etf.csv', index=False)
```
运行:
```bash
./run-docker.sh run get_etf.py
```

#### 方法 4：docker-compose
```bash
docker-compose run --rm app python -c "import efinance as ef; print(ef.stock.get_quote_history('513050').head())"
```

#### 方法 5：Docker 命令
```bash
docker run --rm -v $(pwd)/data:/data ghcr.io/robinspt/efinance:latest python -c "
import efinance as ef
df = ef.stock.get_quote_history('513050')
print(df.head())
df.to_csv('/data/513050_etf.csv', index=False)
"
```

---

### 3. 单只股票5分钟K线数据

#### 方法 1：交互式 Shell
```bash
./run-docker.sh shell
```
```python
>>> import efinance as ef
>>> # 5分钟K线
>>> df = ef.stock.get_quote_history('688802', klt=5)
>>> print(df.head())
```

#### 方法 2：单行命令
```bash
./run-docker.sh exec "import efinance as ef; print(ef.stock.get_quote_history('688802', klt=5).head())"
```

#### 方法 3：Python 脚本
创建 `get_5min_kline.py`:
```python
import efinance as ef
stock_code = '688802'
df = ef.stock.get_quote_history(stock_code, klt=5)
print(f"股票 {stock_code} 5分钟K线数据:")
print(df.head(20))
df.to_csv(f'/data/{stock_code}_5min.csv', index=False)
```
运行:
```bash
./run-docker.sh run get_5min_kline.py
```

#### 方法 4：docker-compose
```bash
docker-compose run --rm app python -c "import efinance as ef; print(ef.stock.get_quote_history('688802', klt=5).head())"
```

#### 方法 5：Docker 命令
```bash
docker run --rm ghcr.io/robinspt/efinance:latest python -c "
import efinance as ef
print(ef.stock.get_quote_history('688802', klt=5).head())
"
```

---

### 4. 沪深市场A股最新状况

#### 方法 1：交互式 Shell
```bash
./run-docker.sh shell
```
```python
>>> import efinance as ef
>>> df = ef.stock.get_realtime_quotes()
>>> print(df.head(10))
```

#### 方法 2：单行命令
```bash
./run-docker.sh exec "import efinance as ef; print(ef.stock.get_realtime_quotes().head(10))"
```

#### 方法 3：Python 脚本
创建 `get_market_status.py`:
```python
import efinance as ef
df = ef.stock.get_realtime_quotes()
print(f"沪深市场A股实时状况 (共 {len(df)} 只股票):")
print(df.head(20))
# 保存涨幅前50的股票
top_gainers = df.nlargest(50, '涨跌幅')
top_gainers.to_csv('/data/top_gainers.csv', index=False)
print("\n涨幅前50已保存到 /data/top_gainers.csv")
```
运行:
```bash
./run-docker.sh run get_market_status.py
```

#### 方法 4：docker-compose
```bash
docker-compose run --rm app python -c "import efinance as ef; print(ef.stock.get_realtime_quotes().head(10))"
```

#### 方法 5：Docker 命令
```bash
docker run --rm ghcr.io/robinspt/efinance:latest python -c "
import efinance as ef
print(ef.stock.get_realtime_quotes().head(10))
"
```

---

### 5. 股票龙虎榜

#### 方法 1：交互式 Shell
```bash
./run-docker.sh shell
```
```python
>>> import efinance as ef
>>> # 最新龙虎榜
>>> df = ef.stock.get_daily_billboard()
>>> print(df.head())
>>> # 指定日期区间
>>> df = ef.stock.get_daily_billboard(start_date='2024-01-01', end_date='2024-01-10')
>>> print(df)
```

#### 方法 2：单行命令
```bash
./run-docker.sh exec "import efinance as ef; print(ef.stock.get_daily_billboard().head())"
```

#### 方法 3：Python 脚本
创建 `get_billboard.py`:
```python
import efinance as ef
from datetime import datetime, timedelta

# 获取最近7天的龙虎榜
end_date = datetime.now().strftime('%Y-%m-%d')
start_date = (datetime.now() - timedelta(days=7)).strftime('%Y-%m-%d')

df = ef.stock.get_daily_billboard(start_date=start_date, end_date=end_date)
print(f"龙虎榜数据 ({start_date} 至 {end_date}):")
print(df.head(20))
df.to_csv('/data/billboard.csv', index=False, encoding='utf-8-sig')
```
运行:
```bash
./run-docker.sh run get_billboard.py
```

#### 方法 4：docker-compose
```bash
docker-compose run --rm app python -c "import efinance as ef; print(ef.stock.get_daily_billboard().head())"
```

#### 方法 5：Docker 命令
```bash
docker run --rm ghcr.io/robinspt/efinance:latest python -c "
import efinance as ef
print(ef.stock.get_daily_billboard().head())
"
```

---

### 6. 沪深A股股票季度表现

#### 方法 1：交互式 Shell
```bash
./run-docker.sh shell
```
```python
>>> import efinance as ef
>>> df = ef.stock.get_all_company_performance()
>>> print(df.head(10))
```

#### 方法 2：单行命令
```bash
./run-docker.sh exec "import efinance as ef; print(ef.stock.get_all_company_performance().head(10))"
```

#### 方法 3：Python 脚本
创建 `get_performance.py`:
```python
import efinance as ef

df = ef.stock.get_all_company_performance()
print(f"沪深A股季度表现 (共 {len(df)} 只股票):")
print(df.head(20))

# 筛选净利润增长超过50%的公司
high_growth = df[df['净利润同比增长'] > 50]
print(f"\n净利润增长超过50%的公司 (共 {len(high_growth)} 家):")
print(high_growth.head(20))

df.to_csv('/data/company_performance.csv', index=False, encoding='utf-8-sig')
```
运行:
```bash
./run-docker.sh run get_performance.py
```

#### 方法 4：docker-compose
```bash
docker-compose run --rm app python -c "import efinance as ef; print(ef.stock.get_all_company_performance().head(10))"
```

#### 方法 5：Docker 命令
```bash
docker run --rm ghcr.io/robinspt/efinance:latest python -c "
import efinance as ef
print(ef.stock.get_all_company_performance().head(10))
"
```

---

### 7. 股票历史单子流入数据(日级)

#### 方法 1：交互式 Shell
```bash
./run-docker.sh shell
```
```python
>>> import efinance as ef
>>> # 宁德时代
>>> df = ef.stock.get_history_bill('300750')
>>> print(df.head())
```

#### 方法 2：单行命令
```bash
./run-docker.sh exec "import efinance as ef; print(ef.stock.get_history_bill('300750').head())"
```

#### 方法 3：Python 脚本
创建 `get_history_bill.py`:
```python
import efinance as ef

stock_code = '300750'  # 宁德时代
df = ef.stock.get_history_bill(stock_code)
print(f"股票 {stock_code} 历史单子流入数据:")
print(df.head(20))
df.to_csv(f'/data/{stock_code}_history_bill.csv', index=False, encoding='utf-8-sig')
```
运行:
```bash
./run-docker.sh run get_history_bill.py
```

#### 方法 4：docker-compose
```bash
docker-compose run --rm app python -c "import efinance as ef; print(ef.stock.get_history_bill('300750').head())"
```

#### 方法 5：Docker 命令
```bash
docker run --rm ghcr.io/robinspt/efinance:latest python -c "
import efinance as ef
print(ef.stock.get_history_bill('300750').head())
"
```

---

### 8. 股票最新一个交易日单子流入数据(分钟级)

#### 方法 1：交互式 Shell
```bash
./run-docker.sh shell
```
```python
>>> import efinance as ef
>>> df = ef.stock.get_today_bill('300750')
>>> print(df.head(20))
```

#### 方法 2：单行命令
```bash
./run-docker.sh exec "import efinance as ef; print(ef.stock.get_today_bill('300750').head(20))"
```

#### 方法 3：Python 脚本
创建 `get_today_bill.py`:
```python
import efinance as ef

stock_code = '300750'
df = ef.stock.get_today_bill(stock_code)
print(f"股票 {stock_code} 最新交易日单子流入数据 (分钟级):")
print(df.head(30))
df.to_csv(f'/data/{stock_code}_today_bill.csv', index=False, encoding='utf-8-sig')
```
运行:
```bash
./run-docker.sh run get_today_bill.py
```

#### 方法 4：docker-compose
```bash
docker-compose run --rm app python -c "import efinance as ef; print(ef.stock.get_today_bill('300750').head(20))"
```

#### 方法 5：Docker 命令
```bash
docker run --rm ghcr.io/robinspt/efinance:latest python -c "
import efinance as ef
print(ef.stock.get_today_bill('300750').head(20))
"
```

---

## 二、基金数据

### 1. 基金历史净值信息

#### 方法 1：交互式 Shell
```bash
./run-docker.sh shell
```
```python
>>> import efinance as ef
>>> # 招商中证白酒
>>> df = ef.fund.get_quote_history('161725')
>>> print(df.head())
```

#### 方法 2：单行命令
```bash
./run-docker.sh exec "import efinance as ef; print(ef.fund.get_quote_history('161725').head())"
```

#### 方法 3：Python 脚本
创建 `get_fund_history.py`:
```python
import efinance as ef

fund_code = '161725'  # 招商中证白酒
df = ef.fund.get_quote_history(fund_code)
print(f"基金 {fund_code} 历史净值:")
print(df.head(20))
df.to_csv(f'/data/{fund_code}_fund_history.csv', index=False, encoding='utf-8-sig')
```
运行:
```bash
./run-docker.sh run get_fund_history.py
```

#### 方法 4：docker-compose
```bash
docker-compose run --rm app python -c "import efinance as ef; print(ef.fund.get_quote_history('161725').head())"
```

#### 方法 5：Docker 命令
```bash
docker run --rm ghcr.io/robinspt/efinance:latest python -c "
import efinance as ef
print(ef.fund.get_quote_history('161725').head())
"
```

---

### 2. 基金公开持仓信息

#### 方法 1：交互式 Shell
```bash
./run-docker.sh shell
```
```python
>>> import efinance as ef
>>> df = ef.fund.get_invest_position('161725')
>>> print(df)
```

#### 方法 2：单行命令
```bash
./run-docker.sh exec "import efinance as ef; print(ef.fund.get_invest_position('161725'))"
```

#### 方法 3：Python 脚本
创建 `get_fund_position.py`:
```python
import efinance as ef

fund_code = '161725'
df = ef.fund.get_invest_position(fund_code)
print(f"基金 {fund_code} 公开持仓:")
print(df)
df.to_csv(f'/data/{fund_code}_position.csv', index=False, encoding='utf-8-sig')
```
运行:
```bash
./run-docker.sh run get_fund_position.py
```

#### 方法 4：docker-compose
```bash
docker-compose run --rm app python -c "import efinance as ef; print(ef.fund.get_invest_position('161725'))"
```

#### 方法 5：Docker 命令
```bash
docker run --rm ghcr.io/robinspt/efinance:latest python -c "
import efinance as ef
print(ef.fund.get_invest_position('161725'))
"
```

---

### 3. 多只基金信息

#### 方法 1：交互式 Shell
```bash
./run-docker.sh shell
```
```python
>>> import efinance as ef
>>> df = ef.fund.get_base_info(['161725', '005827'])
>>> print(df)
```

#### 方法 2：单行命令
```bash
./run-docker.sh exec "import efinance as ef; print(ef.fund.get_base_info(['161725', '005827']))"
```

#### 方法 3：Python 脚本
创建 `get_funds_info.py`:
```python
import efinance as ef

fund_codes = ['161725', '005827', '110022']
df = ef.fund.get_base_info(fund_codes)
print(f"基金基本信息 (共 {len(fund_codes)} 只):")
print(df)
df.to_csv('/data/funds_info.csv', index=False, encoding='utf-8-sig')
```
运行:
```bash
./run-docker.sh run get_funds_info.py
```

#### 方法 4：docker-compose
```bash
docker-compose run --rm app python -c "import efinance as ef; print(ef.fund.get_base_info(['161725', '005827']))"
```

#### 方法 5：Docker 命令
```bash
docker run --rm ghcr.io/robinspt/efinance:latest python -c "
import efinance as ef
print(ef.fund.get_base_info(['161725', '005827']))
"
```

---

## 📚 完整示例脚本

运行包含所有功能的示例：

```bash
# 方法 1：使用快捷脚本
./run-docker.sh run examples/all_features_example.py

# 方法 2：使用 docker-compose
docker-compose run --rm app python /scripts/all_features_example.py

# 方法 3：使用 Docker 命令
docker run --rm \
  -v $(pwd)/examples:/scripts:ro \
  ghcr.io/robinspt/efinance:latest \
  python /scripts/all_features_example.py
```

---

## 💡 最佳实践建议

### 新手入门
- 使用 **方法 1**（交互式 Shell）探索功能
- 命令：`./run-docker.sh shell`

### 快速查询
- 使用 **方法 2**（单行命令）快速获取数据
- 命令：`./run-docker.sh exec "..."`

### 批量处理
- 使用 **方法 3**（Python 脚本）处理复杂逻辑
- 命令：`./run-docker.sh run script.py`

### 团队协作
- 使用 **方法 4**（docker-compose）统一环境
- 命令：`docker-compose run --rm app python`

### 自动化集成
- 使用 **方法 5**（Docker 命令）集成到 CI/CD
- 适合定时任务和自动化流程

---

## 📖 相关文档

- **[README.md](README.md)** - 项目主文档
- **[README_DOCKER.md](README_DOCKER.md)** - Docker 构建和推送指南

