#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
测试股票数据获取函数 - Docker版本
测试股票代码: 601399（工商银行）
"""

import os
import time
import random
import efinance as ef
import pandas as pd
from datetime import datetime


def create_data_dir():
    """创建data目录"""
    data_dir = '/data'
    if not os.path.exists(data_dir):
        os.makedirs(data_dir)
        print("✅ 创建data目录")
    return data_dir


def random_sleep():
    """随机等待10-15秒"""
    sleep_time = random.uniform(10, 15)
    print(f"⏳ 等待 {sleep_time:.1f} 秒...")
    time.sleep(sleep_time)


def save_to_csv(df, filename, description, data_dir):
    """保存DataFrame到CSV文件"""
    if df is None or df.empty:
        print(f"❌ {description}: 数据为空")
        return False
    
    filepath = os.path.join(data_dir, filename)
    df.to_csv(filepath, index=False, encoding='utf-8-sig')
    print(f"✅ {description}: 保存成功 ({len(df)} 行, {len(df.columns)} 列)")
    print(f"   文件: {filepath}")
    print(f"   字段: {', '.join(df.columns.tolist())}")
    return True


def test_stock_functions():
    """测试所有股票函数"""
    stock_code = '601399'
    print(f"\n{'='*60}")
    print(f"Docker 环境 - 股票数据获取测试")
    print(f"测试股票代码: {stock_code} (工商银行)")
    print(f"测试时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"{'='*60}\n")
    
    data_dir = create_data_dir()
    
    # 测试计数
    total_tests = 9
    success_count = 0
    
    # 1. 股票基本信息
    print(f"\n[1/{total_tests}] 测试: 股票基本信息")
    try:
        result = ef.stock.get_base_info(stock_code)
        # 转换 Series 为 DataFrame
        if isinstance(result, pd.Series):
            df = result.to_frame().T
        else:
            df = result
        if save_to_csv(df, f'{stock_code}_基本信息.csv', '股票基本信息', data_dir):
            success_count += 1
    except Exception as e:
        print(f"❌ 股票基本信息: 测试失败 - {e}")
    
    random_sleep()
    
    # 2. K线数据（日K）
    print(f"\n[2/{total_tests}] 测试: K线数据（日K）")
    try:
        df = ef.stock.get_quote_history(stock_code, klt=101)  # 101=日K
        if save_to_csv(df, f'{stock_code}_日K线.csv', 'K线数据', data_dir):
            success_count += 1
    except Exception as e:
        print(f"❌ K线数据: 测试失败 - {e}")
    
    random_sleep()
    
    # 3. 最新报价
    print(f"\n[3/{total_tests}] 测试: 最新报价")
    try:
        df = ef.stock.get_latest_quote(stock_code)
        if save_to_csv(df, f'{stock_code}_最新报价.csv', '最新报价', data_dir):
            success_count += 1
    except Exception as e:
        print(f"❌ 最新报价: 测试失败 - {e}")
    
    random_sleep()
    
    # 4. 龙虎榜（获取今天的龙虎榜数据）
    print(f"\n[4/{total_tests}] 测试: 龙虎榜")
    try:
        today = datetime.now().strftime('%Y-%m-%d')
        # 获取今天的龙虎榜数据
        df = ef.stock.get_daily_billboard(start_date=today, end_date=today)
        if df.empty:
            print(f"⚠️  今天({today})暂无龙虎榜数据，获取最新数据...")
            df = ef.stock.get_daily_billboard()
        
        if save_to_csv(df, f'龙虎榜_{today}.csv', '龙虎榜', data_dir):
            success_count += 1
            # 显示上榜日期和股票数量
            if '上榜日期' in df.columns and len(df) > 0:
                latest_date = df['上榜日期'].iloc[0]
                print(f"   上榜日期: {latest_date}, 上榜股票数: {len(df)} 只")
    except Exception as e:
        print(f"❌ 龙虎榜: 测试失败 - {e}")
    
    random_sleep()
    
    # 5. 公司业绩（获取所有公司业绩，然后过滤指定股票）
    print(f"\n[5/{total_tests}] 测试: 公司业绩")
    try:
        # 获取所有公司业绩
        df_all = ef.stock.get_all_company_performance()
        # 过滤指定股票
        df = df_all[df_all['股票代码'] == stock_code]
        if df.empty:
            print(f"⚠️  公司业绩: 未找到该股票的业绩数据")
        else:
            if save_to_csv(df, f'{stock_code}_公司业绩.csv', '公司业绩', data_dir):
                success_count += 1
    except Exception as e:
        print(f"❌ 公司业绩: 测试失败 - {e}")
    
    random_sleep()

    # 6. 股东户数（获取所有股东户数，然后过滤指定股票）
    print(f"\n[6/{total_tests}] 测试: 股东户数")
    try:
        # 获取所有股东户数
        df_all = ef.stock.get_latest_holder_number()
        # 过滤指定股票
        df = df_all[df_all['股票代码'] == stock_code]
        if df.empty:
            print(f"⚠️  股东户数: 未找到该股票的股东户数数据")
        else:
            if save_to_csv(df, f'{stock_code}_股东户数.csv', '股东户数', data_dir):
                success_count += 1
    except Exception as e:
        print(f"❌ 股东户数: 测试失败 - {e}")

    random_sleep()

    # 7. 前十大股东
    print(f"\n[7/{total_tests}] 测试: 前十大股东")
    try:
        df = ef.stock.get_top10_stock_holder_info(stock_code)
        if save_to_csv(df, f'{stock_code}_前十大股东.csv', '前十大股东', data_dir):
            success_count += 1
    except Exception as e:
        print(f"❌ 前十大股东: 测试失败 - {e}")

    random_sleep()

    # 8. 历史资金流向
    print(f"\n[8/{total_tests}] 测试: 历史资金流向")
    try:
        df = ef.stock.get_history_bill(stock_code)
        if save_to_csv(df, f'{stock_code}_历史资金流向.csv', '历史资金流向', data_dir):
            success_count += 1
    except Exception as e:
        print(f"❌ 历史资金流向: 测试失败 - {e}")

    random_sleep()

    # 9. 所属板块
    print(f"\n[9/{total_tests}] 测试: 所属板块")
    try:
        df = ef.stock.get_belong_board(stock_code)
        if save_to_csv(df, f'{stock_code}_所属板块.csv', '所属板块', data_dir):
            success_count += 1
    except Exception as e:
        print(f"❌ 所属板块: 测试失败 - {e}")

    # 测试总结
    print(f"\n{'='*60}")
    print(f"测试完成!")
    print(f"成功: {success_count}/{total_tests}")
    print(f"失败: {total_tests - success_count}/{total_tests}")
    print(f"成功率: {success_count/total_tests*100:.1f}%")
    print(f"{'='*60}\n")

    # 显示生成的文件
    print("📁 生成的文件:")
    try:
        files = sorted([f for f in os.listdir(data_dir) if f.endswith('.csv')])
        for f in files:
            filepath = os.path.join(data_dir, f)
            size = os.path.getsize(filepath)
            if size < 1024:
                size_str = f"{size}B"
            elif size < 1024*1024:
                size_str = f"{size/1024:.1f}KB"
            else:
                size_str = f"{size/1024/1024:.1f}MB"
            print(f"   - {f} ({size_str})")
    except Exception as e:
        print(f"   无法列出文件: {e}")


if __name__ == '__main__':
    test_stock_functions()

