# comparison.py
# Python 进程和服务管理对比
# 使用 psutil 库实现与 CMD 类似的功能
# 安装: pip install psutil

import psutil
import time
from datetime import datetime

def get_process_list():
    """获取所有进程列表 - 对比 CMD 的 tasklist"""
    print("=" * 60)
    print("所有进程列表 (对比 tasklist)")
    print("=" * 60)
    print(f"{'PID':<10} {'名称':<30} {'内存使用(MB)':<15} {'状态':<10}")
    print("-" * 60)
    
    for proc in psutil.process_iter(['pid', 'name', 'memory_info', 'status']):
        try:
            info = proc.info
            mem_mb = info['memory_info'].rss / 1024 / 1024 if info['memory_info'] else 0
            print(f"{info['pid']:<10} {info['name']:<30} {mem_mb:<15.2f} {info['status']:<10}")
        except (psutil.NoSuchProcess, psutil.AccessDenied):
            pass

def find_process_by_name(name):
    """按名称查找进程 - 对比 CMD 的 tasklist /fi "imagename eq xxx" """
    print(f"\n查找进程: {name}")
    print("-" * 40)
    
    found = False
    for proc in psutil.process_iter(['pid', 'name']):
        try:
            if proc.info['name'].lower() == name.lower():
                print(f"  PID: {proc.info['pid']}")
                found = True
        except (psutil.NoSuchProcess, psutil.AccessDenied):
            pass
    
    if not found:
        print("  未找到该进程")

def get_process_details(pid):
    """获取进程详细信息 - 对比 CMD 的 tasklist /v"""
    try:
        proc = psutil.Process(pid)
        info = proc.as_dict(['pid', 'name', 'status', 'cpu_percent', 
                            'memory_info', 'create_time', 'cmdline'])
        
        print(f"\n进程详细信息 (PID: {pid})")
        print("-" * 40)
        print(f"  名称: {info['name']}")
        print(f"  状态: {info['status']}")
        print(f"  CPU使用率: {info['cpu_percent']}%")
        print(f"  内存使用: {info['memory_info'].rss / 1024 / 1024:.2f} MB")
        print(f"  创建时间: {datetime.fromtimestamp(info['create_time'])}")
        print(f"  命令行: {' '.join(info['cmdline']) if info['cmdline'] else 'N/A'}")
    except psutil.NoSuchProcess:
        print(f"  进程 PID {pid} 不存在")

def kill_process(pid=None, name=None):
    """终止进程 - 对比 CMD 的 taskkill"""
    if pid:
        try:
            proc = psutil.Process(pid)
            proc.terminate()
            print(f"已终止进程 PID: {pid}")
        except psutil.NoSuchProcess:
            print(f"进程 PID {pid} 不存在")
    elif name:
        for proc in psutil.process_iter(['pid', 'name']):
            try:
                if proc.info['name'].lower() == name.lower():
                    proc.terminate()
                    print(f"已终止进程: {name} (PID: {proc.pid})")
            except (psutil.NoSuchProcess, psutil.AccessDenied):
                pass

def get_system_info():
    """获取系统信息 - 对比 CMD 的 systeminfo"""
    print("=" * 60)
    print("系统信息 (对比 systeminfo)")
    print("=" * 60)
    
    # CPU信息
    print(f"\nCPU 信息:")
    print(f"  物理核心数: {psutil.cpu_count(logical=False)}")
    print(f"  逻辑核心数: {psutil.cpu_count(logical=True)}")
    print(f"  CPU使用率: {psutil.cpu_percent(interval=1)}%")
    
    # 内存信息
    mem = psutil.virtual_memory()
    print(f"\n内存信息:")
    print(f"  总内存: {mem.total / 1024 / 1024 / 1024:.2f} GB")
    print(f"  可用内存: {mem.available / 1024 / 1024 / 1024:.2f} GB")
    print(f"  内存使用率: {mem.percent}%")
    
    # 磁盘信息
    print(f"\n磁盘信息:")
    for partition in psutil.disk_partitions():
        try:
            usage = psutil.disk_usage(partition.mountpoint)
            print(f"  {partition.mountpoint}: {usage.total / 1024 / 1024 / 1024:.2f} GB "
                  f"(使用率: {usage.percent}%)")
        except:
            pass
    
    # 启动时间
    boot_time = datetime.fromtimestamp(psutil.boot_time())
    print(f"\n系统启动时间: {boot_time}")

def monitor_process(name, interval=5, duration=60):
    """监控进程 - 对比 CMD 的进程监控脚本"""
    print(f"\n开始监控进程: {name}")
    print(f"监控间隔: {interval} 秒")
    print(f"监控时长: {duration} 秒")
    print("-" * 40)
    
    start_time = time.time()
    check_count = 0
    
    while time.time() - start_time < duration:
        check_count += 1
        found = False
        
        for proc in psutil.process_iter(['pid', 'name', 'memory_info']):
            try:
                if proc.info['name'].lower() == name.lower():
                    mem_mb = proc.info['memory_info'].rss / 1024 / 1024
                    print(f"[{datetime.now().strftime('%H:%M:%S')}] "
                          f"运行中 - PID: {proc.pid}, 内存: {mem_mb:.2f} MB")
                    found = True
            except (psutil.NoSuchProcess, psutil.AccessDenied):
                pass
        
        if not found:
            print(f"[{datetime.now().strftime('%H:%M:%S')}] 进程未运行")
        
        time.sleep(interval)
    
    print(f"\n监控结束，共检查 {check_count} 次")

def get_services():
    """获取服务列表（仅Windows） - 对比 CMD 的 sc query"""
    if hasattr(psutil, 'win_service_iter'):
        print("\n服务列表 (对比 sc query)")
        print("-" * 60)
        
        for service in psutil.win_service_iter():
            try:
                info = service.as_dict()
                print(f"  {info['name']}: {info['status']}")
            except:
                pass

def main():
    """主函数 - 演示各种功能"""
    print("Python 进程管理演示 (使用 psutil)")
    print("对比 CMD 的 tasklist, taskkill, systeminfo 等命令")
    print()
    
    # 1. 获取进程列表
    get_process_list()
    
    # 2. 查找特定进程
    find_process_by_name("python.exe")
    
    # 3. 获取系统信息
    get_system_info()
    
    # 4. 获取服务列表（仅Windows）
    get_services()
    
    print("\n" + "=" * 60)
    print("演示完成")
    print("=" * 60)

if __name__ == "__main__":
    main()
