#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Python对比实现 - 与CMD/BAT脚本功能对比
演示Python如何实现与CMD脚本相同的功能
"""

import os
import sys
import json
import shutil
import logging
import platform
import subprocess
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional, Tuple
import re

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('python_comparison.log', encoding='utf-8'),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)


class SystemInfoCollector:
    """
    系统信息收集器 - 对应 sysinfo_collector.bat
    Python实现更加简洁和跨平台
    """
    
    def __init__(self, output_dir: str = 'output'):
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(exist_ok=True)
        self.report_file = self.output_dir / 'sysinfo_report.html'
    
    def collect_system_info(self) -> Dict:
        """收集系统信息"""
        logger.info("开始收集系统信息...")
        
        info = {
            'os': self._get_os_info(),
            'cpu': self._get_cpu_info(),
            'memory': self._get_memory_info(),
            'disk': self._get_disk_info(),
            'network': self._get_network_info(),
            'timestamp': datetime.now().isoformat()
        }
        
        logger.info("系统信息收集完成")
        return info
    
    def _get_os_info(self) -> Dict:
        """获取操作系统信息"""
        return {
            'system': platform.system(),
            'release': platform.release(),
            'version': platform.version(),
            'machine': platform.machine(),
            'processor': platform.processor(),
            'platform': platform.platform()
        }
    
    def _get_cpu_info(self) -> Dict:
        """获取CPU信息"""
        try:
            # Windows特定命令
            if platform.system() == 'Windows':
                result = subprocess.run(
                    ['wmic', 'cpu', 'get', 'Name,NumberOfCores,NumberOfLogicalProcessors'],
                    capture_output=True, text=True, encoding='gbk'
                )
                # 解析输出（简化处理）
                lines = result.stdout.strip().split('\n')
                if len(lines) > 1:
                    parts = lines[1].split()
                    return {
                        'name': ' '.join(parts[:-2]) if len(parts) > 2 else 'Unknown',
                        'cores': int(parts[-2]) if parts[-2].isdigit() else 0,
                        'threads': int(parts[-1]) if parts[-1].isdigit() else 0
                    }
            else:
                # Linux/Mac
                result = subprocess.run(['nproc'], capture_output=True, text=True)
                return {'cores': int(result.stdout.strip()), 'threads': int(result.stdout.strip())}
        except Exception as e:
            logger.error(f"获取CPU信息失败: {e}")
            return {'name': 'Unknown', 'cores': 0, 'threads': 0}
    
    def _get_memory_info(self) -> Dict:
        """获取内存信息"""
        try:
            if platform.system() == 'Windows':
                result = subprocess.run(
                    ['wmic', 'memorychip', 'get', 'Capacity,Speed'],
                    capture_output=True, text=True, encoding='gbk'
                )
                lines = result.stdout.strip().split('\n')
                if len(lines) > 1:
                    parts = lines[1].split()
                    total_mb = int(parts[0]) // (1024 * 1024) if parts[0].isdigit() else 0
                    speed = int(parts[1]) if len(parts) > 1 and parts[1].isdigit() else 0
                    return {'total_mb': total_mb, 'speed_mhz': speed}
            else:
                # Linux/Mac
                with open('/proc/meminfo', 'r') as f:
                    for line in f:
                        if 'MemTotal' in line:
                            total_kb = int(line.split()[1])
                            return {'total_mb': total_kb // 1024, 'speed_mhz': 0}
        except Exception as e:
            logger.error(f"获取内存信息失败: {e}")
        return {'total_mb': 0, 'speed_mhz': 0}
    
    def _get_disk_info(self) -> List[Dict]:
        """获取磁盘信息"""
        disks = []
        try:
            if platform.system() == 'Windows':
                result = subprocess.run(
                    ['wmic', 'diskdrive', 'get', 'Model,Size,MediaType'],
                    capture_output=True, text=True, encoding='gbk'
                )
                lines = result.stdout.strip().split('\n')[1:]  # 跳过标题行
                for line in lines:
                    if line.strip():
                        parts = line.split()
                        if len(parts) >= 3:
                            size_gb = int(parts[-1]) // (1024**3) if parts[-1].isdigit() else 0
                            disks.append({
                                'model': ' '.join(parts[:-2]),
                                'size_gb': size_gb,
                                'type': parts[-2]
                            })
            else:
                # Linux/Mac
                result = subprocess.run(['df', '-h'], capture_output=True, text=True)
                lines = result.stdout.strip().split('\n')[1:]
                for line in lines:
                    parts = line.split()
                    if len(parts) >= 6:
                        disks.append({
                            'filesystem': parts[0],
                            'size': parts[1],
                            'used': parts[2],
                            'available': parts[3],
                            'mountpoint': parts[5]
                        })
        except Exception as e:
            logger.error(f"获取磁盘信息失败: {e}")
        return disks
    
    def _get_network_info(self) -> Dict:
        """获取网络信息"""
        try:
            if platform.system() == 'Windows':
                result = subprocess.run(
                    ['ipconfig'],
                    capture_output=True, text=True, encoding='gbk'
                )
                # 简化处理，实际应该解析输出
                return {'raw_output': result.stdout[:500]}
            else:
                result = subprocess.run(['ifconfig'], capture_output=True, text=True)
                return {'raw_output': result.stdout[:500]}
        except Exception as e:
            logger.error(f"获取网络信息失败: {e}")
            return {'raw_output': 'Failed to get network info'}
    
    def generate_html_report(self, info: Dict) -> None:
        """生成HTML报告"""
        logger.info(f"生成HTML报告到: {self.report_file}")
        
        html_content = f"""
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>系统信息报告</title>
    <style>
        body {{ font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }}
        .container {{ max-width: 800px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }}
        h1 {{ color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; }}
        h2 {{ color: #34495e; margin-top: 30px; }}
        table {{ width: 100%; border-collapse: collapse; margin: 10px 0; }}
        th, td {{ padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }}
        th {{ background-color: #3498db; color: white; }}
        tr:hover {{ background-color: #f5f5f5; }}
        .timestamp {{ color: #666; font-size: 0.9em; text-align: right; }}
    </style>
</head>
<body>
    <div class="container">
        <h1>系统信息报告 (Python生成)</h1>
        <p class="timestamp">生成时间: {info['timestamp']}</p>
        
        <h2>操作系统信息</h2>
        <table>
            <tr><th>项目</th><th>值</th></tr>
            <tr><td>系统</td><td>{info['os']['system']}</td></tr>
            <tr><td>版本</td><td>{info['os']['version']}</td></tr>
            <tr><td>平台</td><td>{info['os']['platform']}</td></tr>
            <tr><td>机器类型</td><td>{info['os']['machine']}</td></tr>
        </table>
        
        <h2>CPU信息</h2>
        <table>
            <tr><th>项目</th><th>值</th></tr>
            <tr><td>处理器</td><td>{info['cpu']['name']}</td></tr>
            <tr><td>核心数</td><td>{info['cpu']['cores']}</td></tr>
            <tr><td>线程数</td><td>{info['cpu']['threads']}</td></tr>
        </table>
        
        <h2>内存信息</h2>
        <table>
            <tr><th>项目</th><th>值</th></tr>
            <tr><td>总内存</td><td>{info['memory']['total_mb']} MB</td></tr>
            <tr><td>内存速度</td><td>{info['memory']['speed_mhz']} MHz</td></tr>
        </table>
    </div>
</body>
</html>
"""
        
        with open(self.report_file, 'w', encoding='utf-8') as f:
            f.write(html_content)
        
        logger.info(f"HTML报告生成完成: {self.report_file}")


class LogAnalyzer:
    """
    日志分析工具 - 对应 log_analyzer.bat
    Python实现更加灵活和强大
    """
    
    def __init__(self, log_file: str):
        self.log_file = Path(log_file)
        self.stats = {
            'total_lines': 0,
            'error_count': 0,
            'warning_count': 0,
            'info_count': 0,
            'debug_count': 0,
            'fatal_count': 0
        }
        self.error_messages = []
        self.fatal_messages = []
    
    def analyze(self) -> Dict:
        """分析日志文件"""
        logger.info(f"开始分析日志文件: {self.log_file}")
        
        if not self.log_file.exists():
            logger.error(f"日志文件不存在: {self.log_file}")
            return self.stats
        
        with open(self.log_file, 'r', encoding='utf-8') as f:
            for line_num, line in enumerate(f, 1):
                self.stats['total_lines'] += 1
                self._analyze_line(line.strip())
        
        logger.info(f"日志分析完成，共 {self.stats['total_lines']} 行")
        return self.stats
    
    def _analyze_line(self, line: str) -> None:
        """分析单行日志"""
        line_upper = line.upper()
        
        if '[ERROR]' in line_upper:
            self.stats['error_count'] += 1
            self.error_messages.append(line)
        elif '[WARNING]' in line_upper:
            self.stats['warning_count'] += 1
        elif '[INFO]' in line_upper:
            self.stats['info_count'] += 1
        elif '[DEBUG]' in line_upper:
            self.stats['debug_count'] += 1
        elif '[FATAL]' in line_upper:
            self.stats['fatal_count'] += 1
            self.fatal_messages.append(line)
    
    def generate_report(self, output_file: str = 'analysis_report.txt') -> None:
        """生成分析报告"""
        logger.info(f"生成分析报告到: {output_file}")
        
        error_rate = 0
        if self.stats['total_lines'] > 0:
            error_rate = (self.stats['error_count'] + self.stats['fatal_count']) * 100 / self.stats['total_lines']
        
        report_content = f"""
============================================================
                    日志分析报告
============================================================
生成时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
日志文件: {self.log_file}
============================================================

【基本信息】
总行数: {self.stats['total_lines']}

【日志级别统计】
┌─────────────┬──────────┐
│ 日志级别    │ 数量     │
├─────────────┼──────────┤
│ FATAL       │ {self.stats['fatal_count']:<8} │
│ ERROR       │ {self.stats['error_count']:<8} │
│ WARNING     │ {self.stats['warning_count']:<8} │
│ INFO        │ {self.stats['info_count']:<8} │
│ DEBUG       │ {self.stats['debug_count']:<8} │
└─────────────┴──────────┘

【错误率分析】
错误率: {error_rate:.1f}%
"""
        
        if error_rate > 10:
            report_content += "[警告] 错误率较高，建议检查系统状态！\n"
        elif error_rate > 5:
            report_content += "[注意] 错误率中等，建议关注。\n"
        else:
            report_content += "[正常] 错误率在正常范围内。\n"
        
        if self.error_messages:
            report_content += "\n【错误详情】\n"
            report_content += "-" * 60 + "\n"
            for msg in self.error_messages[:10]:  # 只显示前10个错误
                report_content += f"{msg}\n"
            report_content += "-" * 60 + "\n"
        
        if self.fatal_messages:
            report_content += "\n【严重错误详情】\n"
            report_content += "-" * 60 + "\n"
            for msg in self.fatal_messages:
                report_content += f"{msg}\n"
            report_content += "-" * 60 + "\n"
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(report_content)
        
        logger.info(f"分析报告生成完成: {output_file}")


class FileBatchProcessor:
    """
    文件批量处理工具 - 对应 file_batch.bat
    Python实现更加简洁和安全
    """
    
    def __init__(self, target_dir: str):
        self.target_dir = Path(target_dir)
        if not self.target_dir.exists():
            self.target_dir.mkdir(parents=True)
            logger.info(f"创建目标目录: {self.target_dir}")
    
    def list_files(self, pattern: str = '*') -> List[Path]:
        """列出文件"""
        files = list(self.target_dir.glob(pattern))
        logger.info(f"找到 {len(files)} 个文件匹配模式: {pattern}")
        return files
    
    def add_prefix(self, prefix: str, pattern: str = '*.*') -> List[Tuple[Path, Path]]:
        """添加前缀"""
        changes = []
        for file_path in self.list_files(pattern):
            new_name = f"{prefix}{file_path.name}"
            new_path = file_path.parent / new_name
            changes.append((file_path, new_path))
            logger.debug(f"计划重命名: {file_path.name} -> {new_name}")
        return changes
    
    def add_suffix(self, suffix: str, pattern: str = '*.*') -> List[Tuple[Path, Path]]:
        """添加后缀"""
        changes = []
        for file_path in self.list_files(pattern):
            stem = file_path.stem
            suffix_with_dot = f"{suffix}{file_path.suffix}" if not suffix.startswith('.') else f"{suffix}{file_path.suffix}"
            new_name = f"{stem}{suffix_with_dot}"
            new_path = file_path.parent / new_name
            changes.append((file_path, new_path))
            logger.debug(f"计划重命名: {file_path.name} -> {new_name}")
        return changes
    
    def add_sequence(self, prefix: str = '', start: int = 1, digits: int = 3, pattern: str = '*.*') -> List[Tuple[Path, Path]]:
        """添加序号"""
        changes = []
        for i, file_path in enumerate(self.list_files(pattern), start):
            seq_num = str(i).zfill(digits)
            new_name = f"{prefix}{seq_num}_{file_path.name}"
            new_path = file_path.parent / new_name
            changes.append((file_path, new_path))
            logger.debug(f"计划重命名: {file_path.name} -> {new_name}")
        return changes
    
    def execute_changes(self, changes: List[Tuple[Path, Path]], dry_run: bool = True) -> None:
        """执行文件操作"""
        if dry_run:
            logger.info("预览模式 - 不会实际修改文件")
            for old_path, new_path in changes:
                print(f"{old_path.name} -> {new_path.name}")
        else:
            logger.info("执行模式 - 开始修改文件")
            for old_path, new_path in changes:
                try:
                    old_path.rename(new_path)
                    logger.info(f"重命名成功: {old_path.name} -> {new_path.name}")
                except Exception as e:
                    logger.error(f"重命名失败: {old_path.name} -> {new_path.name}: {e}")


class BackupSystem:
    """
    简易备份系统 - 对应 backup_system.bat
    Python实现支持增量备份和压缩
    """
    
    def __init__(self, source_dir: str, backup_dir: str = 'backup'):
        self.source_dir = Path(source_dir)
        self.backup_dir = Path(backup_dir)
        self.backup_dir.mkdir(exist_ok=True)
        self.backup_log = self.backup_dir / 'backup.log'
    
    def incremental_backup(self, timestamp: str = None) -> Path:
        """增量备份"""
        if timestamp is None:
            timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        
        backup_path = self.backup_dir / f'backup_{timestamp}'
        backup_path.mkdir(exist_ok=True)
        
        logger.info(f"开始增量备份到: {backup_path}")
        
        backed_up = 0
        for file_path in self.source_dir.rglob('*'):
            if file_path.is_file():
                # 检查是否需要备份（简化实现）
                dest_file = backup_path / file_path.name
                if not dest_file.exists() or file_path.stat().st_mtime > dest_file.stat().st_mtime:
                    shutil.copy2(file_path, dest_file)
                    backed_up += 1
                    logger.debug(f"备份文件: {file_path.name}")
        
        logger.info(f"增量备份完成，备份了 {backed_up} 个文件")
        return backup_path
    
    def full_backup(self, timestamp: str = None) -> Path:
        """全量备份"""
        if timestamp is None:
            timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        
        backup_path = self.backup_dir / f'full_backup_{timestamp}'
        backup_path.mkdir(exist_ok=True)
        
        logger.info(f"开始全量备份到: {backup_path}")
        
        # 使用shutil.copytree进行全量备份
        for item in self.source_dir.iterdir():
            dest = backup_path / item.name
            if item.is_dir():
                shutil.copytree(item, dest, dirs_exist_ok=True)
            else:
                shutil.copy2(item, dest)
        
        logger.info(f"全量备份完成")
        return backup_path
    
    def list_backups(self) -> List[Path]:
        """列出所有备份"""
        backups = []
        for item in self.backup_dir.iterdir():
            if item.is_dir() and ('backup_' in item.name or 'full_backup_' in item.name):
                backups.append(item)
        
        backups.sort(key=lambda x: x.name)
        logger.info(f"找到 {len(backups)} 个备份")
        return backups
    
    def restore_backup(self, backup_path: Path, target_dir: Path = None) -> None:
        """恢复备份"""
        if target_dir is None:
            target_dir = self.source_dir
        
        logger.info(f"开始恢复备份: {backup_path} 到 {target_dir}")
        
        for item in backup_path.iterdir():
            dest = target_dir / item.name
            if item.is_dir():
                shutil.copytree(item, dest, dirs_exist_ok=True)
            else:
                shutil.copy2(item, dest)
        
        logger.info(f"备份恢复完成")


class DeployScript:
    """
    自动化部署脚本 - 对应 deploy.bat
    Python实现支持配置文件和错误处理
    """
    
    def __init__(self, config_file: str = 'config/deploy_config.ini'):
        self.config_file = Path(config_file)
        self.config = self._load_config()
        self.deploy_log = Path('output/deploy.log')
        self.deploy_log.parent.mkdir(exist_ok=True)
    
    def _load_config(self) -> Dict:
        """加载配置文件"""
        config = {}
        if self.config_file.exists():
            # 简化实现，实际应该使用configparser
            with open(self.config_file, 'r', encoding='utf-8') as f:
                for line in f:
                    line = line.strip()
                    if line and not line.startswith('#') and not line.startswith('['):
                        if '=' in line:
                            key, value = line.split('=', 1)
                            config[key.strip()] = value.strip()
        else:
            # 默认配置
            config = {
                'app_name': 'MyApplication',
                'app_version': '1.0.0',
                'deploy_steps': 'backup,stop,deploy,start,verify',
                'health_check_url': 'http://localhost:8080/health',
                'rollback_enabled': 'true'
            }
        
        return config
    
    def execute_step(self, step: str) -> bool:
        """执行部署步骤"""
        logger.info(f"执行步骤: {step}")
        
        try:
            if step == 'backup':
                return self._step_backup()
            elif step == 'stop':
                return self._step_stop()
            elif step == 'deploy':
                return self._step_deploy()
            elif step == 'start':
                return self._step_start()
            elif step == 'verify':
                return self._step_verify()
            else:
                logger.error(f"未知步骤: {step}")
                return False
        except Exception as e:
            logger.error(f"步骤 {step} 执行失败: {e}")
            return False
    
    def _step_backup(self) -> bool:
        """备份步骤"""
        logger.info("创建备份...")
        # 模拟备份操作
        return True
    
    def _step_stop(self) -> bool:
        """停止步骤"""
        logger.info("停止应用...")
        # 模拟停止操作
        return True
    
    def _step_deploy(self) -> bool:
        """部署步骤"""
        logger.info("部署新版本...")
        # 模拟部署操作
        return True
    
    def _step_start(self) -> bool:
        """启动步骤"""
        logger.info("启动应用...")
        # 模拟启动操作
        return True
    
    def _step_verify(self) -> bool:
        """验证步骤"""
        logger.info("验证部署...")
        # 模拟验证操作
        return True
    
    def full_deploy(self) -> bool:
        """执行完整部署"""
        logger.info("开始完整部署")
        
        steps = self.config.get('deploy_steps', '').split(',')
        for step in steps:
            step = step.strip()
            if not step:
                continue
            
            if not self.execute_step(step):
                logger.error(f"部署失败于步骤: {step}")
                if self.config.get('rollback_enabled', 'false').lower() == 'true':
                    logger.info("自动回滚已启用，开始回滚...")
                    self.rollback()
                return False
        
        logger.info("部署完成")
        return True
    
    def rollback(self) -> None:
        """回滚部署"""
        logger.info("执行回滚...")
        # 模拟回滚操作
        logger.info("回滚完成")


def main():
    """主函数 - 演示各个功能"""
    print("=" * 60)
    print("                    Python对比实现演示")
    print("=" * 60)
    
    # 1. 系统信息收集器
    print("\n1. 系统信息收集器")
    collector = SystemInfoCollector()
    info = collector.collect_system_info()
    collector.generate_html_report(info)
    print(f"   系统信息报告已生成: {collector.report_file}")
    
    # 2. 日志分析工具
    print("\n2. 日志分析工具")
    log_file = 'logs/sample.log'
    if Path(log_file).exists():
        analyzer = LogAnalyzer(log_file)
        stats = analyzer.analyze()
        analyzer.generate_report('output/python_analysis_report.txt')
        print(f"   日志分析完成，错误数: {stats['error_count']}")
    else:
        print(f"   日志文件不存在: {log_file}")
    
    # 3. 文件批量处理
    print("\n3. 文件批量处理")
    processor = FileBatchProcessor('test_files')
    changes = processor.add_prefix('backup_')
    processor.execute_changes(changes, dry_run=True)
    
    # 4. 备份系统
    print("\n4. 备份系统")
    backup_system = BackupSystem('test_files')
    backups = backup_system.list_backups()
    print(f"   现有备份数: {len(backups)}")
    
    # 5. 部署脚本
    print("\n5. 部署脚本")
    deploy = DeployScript()
    print(f"   应用名称: {deploy.config.get('app_name', 'Unknown')}")
    print(f"   部署步骤: {deploy.config.get('deploy_steps', 'None')}")
    
    print("\n" + "=" * 60)
    print("                    演示完成")
    print("=" * 60)


if __name__ == '__main__':
    main()