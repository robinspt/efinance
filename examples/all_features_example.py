#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
efinance 完整功能示例
展示所有股票和基金数据获取功能
"""

import efinance as ef
import sys
import os


def safe_execute(func_name, func, *args, **kwargs):
    """安全执行函数，捕获异常"""
    try:
        print(f"\n{'='*60}")
        print(f"执行: {func_name}")
        print('='*60)
        result = func(*args, **kwargs)
        if result is not None and hasattr(result, 'head'):
            print(result.head(10))
        elif result is not None:
            print(result)
        return result
    except Exception as e:
        print(f"❌ 错误: {e}")
        return None


def stock_basic_examples(stock_code='688802'):
    """股票基础数据示例"""
    print("\n" + "🔹"*30)
    print("📊 股票基础数据")
    print("🔹"*30)

    # 1. 股票基本信息
    safe_execute(
        "1. 获取股票基本信息",
        ef.stock.get_base_info,
        stock_code
    )

    # 2. 股票日K线数据
    df = safe_execute(
        f"2. 获取股票日K线数据 ({stock_code})",
        ef.stock.get_quote_history,
        stock_code
    )

    # 保存数据
    if df is not None:
        try:
            output_file = f'/data/{stock_code}_daily.csv'
            df.to_csv(output_file, index=False, encoding='utf-8-sig')
            print(f"✅ 数据已保存到: {output_file}")
        except Exception as e:
            print(f"❌ 保存失败: {e}")

    # 3. 5分钟K线数据
    safe_execute(
        f"3. 获取5分钟K线数据 ({stock_code})",
        ef.stock.get_quote_history,
        stock_code,
        klt=5
    )

    # 4. 最新报价
    safe_execute(
        f"4. 获取最新报价 ({stock_code})",
        ef.stock.get_latest_quote,
        stock_code
    )

    # 5. 行情快照
    safe_execute(
        f"5. 获取行情快照 ({stock_code})",
        ef.stock.get_quote_snapshot,
        stock_code
    )


def stock_market_examples():
    """股票市场数据示例"""
    print("\n" + "🔹"*30)
    print("📈 股票市场数据")
    print("🔹"*30)

    # 1. 沪深A股实时行情
    safe_execute(
        "1. 获取沪深A股实时行情 (前10条)",
        ef.stock.get_realtime_quotes
    )

    # 2. 龙虎榜
    safe_execute(
        "2. 获取股票龙虎榜",
        ef.stock.get_daily_billboard
    )

    # 3. 公司业绩
    safe_execute(
        "3. 获取沪深A股公司业绩 (前10条)",
        ef.stock.get_all_company_performance
    )

    # 4. 最新股东户数
    safe_execute(
        "4. 获取最新股东户数 (前10条)",
        ef.stock.get_latest_holder_number
    )


def stock_capital_flow_examples(stock_code='300750'):
    """股票资金流向示例"""
    print("\n" + "🔹"*30)
    print("💰 股票资金流向")
    print("🔹"*30)

    # 1. 历史资金流向
    safe_execute(
        f"1. 获取历史资金流向 ({stock_code} - 宁德时代)",
        ef.stock.get_history_bill,
        stock_code
    )

    # 2. 今日资金流向
    safe_execute(
        f"2. 获取今日资金流向 ({stock_code})",
        ef.stock.get_today_bill,
        stock_code
    )


def stock_holder_examples(stock_code='600519'):
    """股票股东信息示例"""
    print("\n" + "🔹"*30)
    print("👥 股票股东信息")
    print("🔹"*30)

    # 1. 前十大股东
    safe_execute(
        f"1. 获取前十大股东信息 ({stock_code} - 贵州茅台)",
        ef.stock.get_top10_stock_holder_info,
        stock_code
    )


def stock_board_examples(stock_code='600519'):
    """股票板块信息示例"""
    print("\n" + "🔹"*30)
    print("📋 股票板块信息")
    print("🔹"*30)

    # 1. 所属板块
    safe_execute(
        f"1. 获取所属板块 ({stock_code})",
        ef.stock.get_belong_board,
        stock_code
    )


def fund_basic_examples(fund_code='161725'):
    """基金基础数据示例"""
    print("\n" + "🔹"*30)
    print("🏦 基金基础数据")
    print("🔹"*30)

    # 1. 基金基本信息
    safe_execute(
        f"1. 获取基金基本信息 ({fund_code} - 招商中证白酒)",
        ef.fund.get_base_info,
        fund_code
    )

    # 2. 多只基金信息
    safe_execute(
        "2. 获取多只基金基本信息",
        ef.fund.get_base_info,
        [fund_code, '005827']
    )

    # 3. 基金历史净值
    safe_execute(
        f"3. 获取基金历史净值 ({fund_code})",
        ef.fund.get_quote_history,
        fund_code
    )

    # 4. 基金经理信息
    safe_execute(
        f"4. 获取基金经理信息 ({fund_code})",
        ef.fund.get_fund_manager,
        fund_code
    )


def fund_position_examples(fund_code='161725'):
    """基金持仓信息示例"""
    print("\n" + "🔹"*30)
    print("📊 基金持仓信息")
    print("🔹"*30)

    # 1. 持仓信息
    safe_execute(
        f"1. 获取基金持仓信息 ({fund_code})",
        ef.fund.get_invest_position,
        fund_code
    )

    # 2. 行业分布
    safe_execute(
        f"2. 获取基金行业分布 ({fund_code})",
        ef.fund.get_industry_distribution,
        fund_code
    )

    # 3. 资产类型占比
    safe_execute(
        f"3. 获取资产类型占比 ({fund_code})",
        ef.fund.get_types_percentage,
        fund_code
    )


def fund_performance_examples(fund_code='161725'):
    """基金业绩数据示例"""
    print("\n" + "🔹"*30)
    print("📈 基金业绩数据")
    print("🔹"*30)

    # 1. 实时涨跌幅
    safe_execute(
        f"1. 获取基金实时涨跌幅 ({fund_code})",
        ef.fund.get_realtime_increase_rate,
        [fund_code, '005827']
    )

    # 2. 阶段涨跌
    safe_execute(
        f"2. 获取基金阶段涨跌 ({fund_code})",
        ef.fund.get_period_change,
        fund_code
    )


def main():
    """主函数"""
    print("\n" + "="*70)
    print("🚀 efinance 完整功能示例")
    print("="*70)

    # 检查命令行参数
    stock_code = '688802'
    fund_code = '161725'

    if len(sys.argv) > 1:
        stock_code = sys.argv[1]
        print(f"📌 使用命令行参数股票代码: {stock_code}")

    if len(sys.argv) > 2:
        fund_code = sys.argv[2]
        print(f"📌 使用命令行参数基金代码: {fund_code}")

    print(f"\n默认股票代码: {stock_code}")
    print(f"默认基金代码: {fund_code}")

    # ========== 股票数据示例 ==========
    print("\n" + "🔸"*35)
    print("📊 股票数据获取示例")
    print("🔸"*35)

    stock_basic_examples(stock_code)
    stock_market_examples()
    stock_capital_flow_examples('300750')
    stock_holder_examples('600519')
    stock_board_examples('600519')

    # ========== 基金数据示例 ==========
    print("\n" + "🔸"*35)
    print("🏦 基金数据获取示例")
    print("🔸"*35)

    fund_basic_examples(fund_code)
    fund_position_examples(fund_code)
    fund_performance_examples(fund_code)

    # ========== 完成 ==========
    print("\n" + "="*70)
    print("✅ 所有示例执行完成！")
    print("="*70)
    print(f"\n💾 数据文件保存在: /data/ 目录")
    print(f"📝 查看保存的文件: ls -lh /data/")


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n⚠️  用户中断执行")
        sys.exit(0)
    except Exception as e:
        print(f"\n❌ 错误: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

