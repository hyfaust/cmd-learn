"""
comparison.py - Python任务调度实现对比
本脚本展示Python中任务调度的多种实现方式
包括schedule库和APScheduler库
"""

import time
import datetime
import threading
from typing import Callable, Optional

# ============================================================
# 方法1: 使用schedule库（轻量级）
# ============================================================

try:
    import schedule
    
    def schedule_demo():
        """演示schedule库的基本用法"""
        print("=== schedule库演示 ===")
        
        # 定义任务函数
        def job_daily():
            print(f"[{datetime.datetime.now()}] 执行每日任务")
        
        def job_hourly():
            print(f"[{datetime.datetime.now()}] 执行每小时任务")
        
        def job_every_minutes():
            print(f"[{datetime.datetime.now()}] 执行每分钟任务")
        
        # 设置任务调度
        schedule.every().day.at("02:00").do(job_daily)  # 每天凌晨2点
        schedule.every().hour.do(job_hourly)  # 每小时
        schedule.every(1).minutes.do(job_every_minutes)  # 每分钟
        
        print("已设置3个定时任务，运行中...")
        print("按Ctrl+C停止")
        
        # 运行调度器
        try:
            while True:
                schedule.run_pending()
                time.sleep(1)
        except KeyboardInterrupt:
            print("\n调度器已停止")
    
    def schedule_advanced_demo():
        """演示schedule库的高级用法"""
        print("\n=== schedule高级功能 ===")
        
        # 带参数的任务
        def task_with_params(name: str, count: int):
            print(f"[{datetime.datetime.now()}] 任务 {name} 执行第 {count} 次")
        
        # 使用闭包包装带参数的任务
        schedule.every(2).seconds.do(task_with_params, name="测试任务", count=1)
        
        # 取消任务
        job = schedule.every(1).seconds.do(lambda: print("可取消任务"))
        schedule.every(5).seconds.do(job.cancel)
        
        print("运行5秒后停止...")
        end_time = time.time() + 5
        while time.time() < end_time:
            schedule.run_pending()
            time.sleep(0.1)
        
        print("高级功能演示完成")

except ImportError:
    print("schedule库未安装，请运行: pip install schedule")
    def schedule_demo():
        pass
    def schedule_advanced_demo():
        pass

# ============================================================
# 方法2: 使用APScheduler库（功能强大）
# ============================================================

try:
    from apscheduler.schedulers.background import BackgroundScheduler
    from apscheduler.triggers.cron import CronTrigger
    from apscheduler.triggers.interval import IntervalTrigger
    from apscheduler.triggers.date import DateTrigger
    
    def apscheduler_demo():
        """演示APScheduler库的基本用法"""
        print("\n=== APScheduler库演示 ===")
        
        # 创建后台调度器
        scheduler = BackgroundScheduler()
        
        # 定义任务函数
        def job_cron():
            print(f"[{datetime.datetime.now()}] Cron任务执行")
        
        def job_interval():
            print(f"[{datetime.datetime.now()}] 间隔任务执行")
        
        def job_date():
            print(f"[{datetime.datetime.now()}] 定时任务执行")
        
        # 添加Cron任务（每天凌晨2点）
        scheduler.add_job(
            job_cron,
            CronTrigger(hour=2, minute=0),
            id='daily_job',
            name='每日任务'
        )
        
        # 添加间隔任务（每30秒）
        scheduler.add_job(
            job_interval,
            IntervalTrigger(seconds=30),
            id='interval_job',
            name='间隔任务'
        )
        
        # 添加定时任务（5秒后执行一次）
        scheduler.add_job(
            job_date,
            DateTrigger(run_date=datetime.datetime.now() + datetime.timedelta(seconds=5)),
            id='date_job',
            name='定时任务'
        )
        
        # 启动调度器
        scheduler.start()
        print("APScheduler已启动，运行10秒...")
        
        # 显示任务列表
        print("\n当前任务列表:")
        for job in scheduler.get_jobs():
            print(f"  - {job.name} (ID: {job.id})")
        
        # 运行10秒
        time.sleep(10)
        
        # 停止调度器
        scheduler.shutdown()
        print("APScheduler已停止")
    
    def apscheduler_advanced_demo():
        """演示APScheduler的高级功能"""
        print("\n=== APScheduler高级功能 ===")
        
        scheduler = BackgroundScheduler()
        
        # 任务执行监听器
        def job_listener(event):
            if event.exception:
                print(f"任务执行失败: {event.exception}")
            else:
                print(f"任务执行成功: {event.job_id}")
        
        scheduler.add_listener(job_listener)
        
        # 带错误处理的任务
        def risky_job():
            import random
            if random.random() < 0.5:
                raise ValueError("随机错误")
            print("任务执行成功")
        
        scheduler.add_job(
            risky_job,
            IntervalTrigger(seconds=2),
            id='risky_job',
            max_instances=1,
            misfire_grace_time=10
        )
        
        scheduler.start()
        print("运行5秒后停止...")
        time.sleep(5)
        scheduler.shutdown()
        print("高级功能演示完成")

except ImportError:
    print("APScheduler库未安装，请运行: pip install apscheduler")
    def apscheduler_demo():
        pass
    def apscheduler_advanced_demo():
        pass

# ============================================================
# 方法3: 使用threading.Timer（内置）
# ============================================================

def timer_demo():
    """演示使用threading.Timer实现定时任务"""
    print("\n=== threading.Timer演示 ===")
    
    def delayed_task():
        print(f"[{datetime.datetime.now()}] 延迟任务执行")
    
    # 创建定时器（3秒后执行）
    timer = threading.Timer(3.0, delayed_task)
    timer.start()
    
    print("定时器已启动，3秒后执行任务...")
    time.sleep(4)
    print("演示完成")

# ============================================================
# 方法4: 使用sched模块（内置）
# ============================================================

def sched_demo():
    """演示使用sched模块实现定时任务"""
    print("\n=== sched模块演示 ===")
    
    import sched
    
    scheduler = sched.scheduler(time.time, time.sleep)
    
    def print_event(msg):
        print(f"[{datetime.datetime.now()}] {msg}")
    
    # 调度任务
    scheduler.enter(1, 1, print_event, ("1秒后执行",))
    scheduler.enter(2, 1, print_event, ("2秒后执行",))
    scheduler.enter(3, 1, print_event, ("3秒后执行",))
    
    print("开始执行调度任务...")
    scheduler.run()
    print("演示完成")

# ============================================================
# 实用工具函数
# ============================================================

class TaskScheduler:
    """自定义任务调度器类"""
    
    def __init__(self):
        self.tasks = []
        self.running = False
    
    def add_task(self, func: Callable, interval: float, name: str = ""):
        """添加定时任务"""
        task = {
            'func': func,
            'interval': interval,
            'name': name or func.__name__,
            'last_run': 0,
            'run_count': 0
        }
        self.tasks.append(task)
        print(f"已添加任务: {task['name']} (间隔: {interval}秒)")
    
    def run(self, duration: float = None):
        """运行调度器"""
        self.running = True
        start_time = time.time()
        
        print(f"调度器开始运行...")
        if duration:
            print(f"运行时长: {duration}秒")
        
        try:
            while self.running:
                current_time = time.time()
                
                for task in self.tasks:
                    if current_time - task['last_run'] >= task['interval']:
                        try:
                            task['func']()
                            task['last_run'] = current_time
                            task['run_count'] += 1
                        except Exception as e:
                            print(f"任务 {task['name']} 执行失败: {e}")
                
                if duration and (current_time - start_time) >= duration:
                    break
                
                time.sleep(0.1)
        
        except KeyboardInterrupt:
            print("\n调度器被中断")
        finally:
            self.running = False
            print("调度器已停止")
    
    def stop(self):
        """停止调度器"""
        self.running = False
    
    def get_stats(self):
        """获取任务统计信息"""
        print("\n任务统计:")
        for task in self.tasks:
            print(f"  - {task['name']}: 执行次数 {task['run_count']}")

# ============================================================
# 与CMD对比分析
# ============================================================

def comparison_analysis():
    """分析Python与CMD任务调度的差异"""
    print("\n=== Python vs CMD 任务调度对比 ===")
    
    comparison = {
        "持久化": {
            "CMD": "系统级持久化（任务计划程序）",
            "Python": "内存级（需额外存储）"
        },
        "精确度": {
            "CMD": "分钟级",
            "Python": "秒级甚至毫秒级"
        },
        "复杂调度": {
            "CMD": "基本（每日、每周等）",
            "Python": "强大（Cron表达式、复杂条件）"
        },
        "错误处理": {
            "CMD": "有限",
            "Python": "完整（异常处理、重试机制）"
        },
        "监控": {
            "CMD": "基本日志",
            "Python": "完整监控（指标、警报）"
        },
        "跨平台": {
            "CMD": "仅Windows",
            "Python": "跨平台"
        },
        "依赖": {
            "CMD": "无",
            "Python": "需要Python环境"
        }
    }
    
    for feature, details in comparison.items():
        print(f"\n{feature}:")
        for lang, description in details.items():
            print(f"  {lang}: {description}")

# ============================================================
# 主程序
# ============================================================

if __name__ == "__main__":
    print("Python任务调度实现对比")
    print("=" * 50)
    
    # 显示对比分析
    comparison_analysis()
    
    # 运行各个演示
    print("\n" + "=" * 50)
    print("开始运行演示（按Ctrl+C跳过）")
    print("=" * 50)
    
    try:
        # 方法1: schedule
        schedule_demo()
        schedule_advanced_demo()
        
        # 方法2: APScheduler
        apscheduler_demo()
        apscheduler_advanced_demo()
        
        # 方法3: threading.Timer
        timer_demo()
        
        # 方法4: sched模块
        sched_demo()
        
        # 自定义调度器演示
        print("\n=== 自定义调度器演示 ===")
        custom_scheduler = TaskScheduler()
        custom_scheduler.add_task(
            lambda: print(f"[{datetime.datetime.now()}] 自定义任务1"),
            interval=1,
            name="自定义任务1"
        )
        custom_scheduler.add_task(
            lambda: print(f"[{datetime.datetime.now()}] 自定义任务2"),
            interval=2,
            name="自定义任务2"
        )
        custom_scheduler.run(duration=5)
        custom_scheduler.get_stats()
        
    except KeyboardInterrupt:
        print("\n演示被用户中断")
    
    print("\n" + "=" * 50)
    print("演示完成！")
    print("=" * 50)