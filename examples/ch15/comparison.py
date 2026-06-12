#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Python安全编程对比示例

本文件展示Python中的安全编程实践，包括：
1. 输入验证和消毒
2. 路径遍历防护
3. 安全文件操作
4. 敏感信息处理
5. 日志记录
6. 哈希计算
"""

import os
import re
import hashlib
import logging
import secrets
import getpass
from pathlib import Path
from typing import Optional, Tuple, List


class SecurityValidator:
    """安全验证器类"""
    
    # 危险字符列表
    DANGEROUS_CHARS = r'[\\/:*?"<>|&;`$]'
    
    # 危险模式列表
    DANGEROUS_PATTERNS = [
        r'\.\.',  # 路径遍历
        r'[&|<>^]',  # 命令注入
        r'[;]',  # 命令分隔符
    ]
    
    @staticmethod
    def validate_input(user_input: str) -> bool:
        """
        验证用户输入是否安全
        
        Args:
            user_input: 用户输入字符串
            
        Returns:
            bool: 是否安全
        """
        # 检查空输入
        if not user_input or not user_input.strip():
            return False
        
        # 检查危险字符
        if re.search(SecurityValidator.DANGEROUS_CHARS, user_input):
            return False
        
        # 检查危险模式
        for pattern in SecurityValidator.DANGEROUS_PATTERNS:
            if re.search(pattern, user_input):
                return False
        
        return True
    
    @staticmethod
    def validate_filename(filename: str) -> bool:
        """
        验证文件名是否安全
        
        Args:
            filename: 文件名
            
        Returns:
            bool: 是否安全
        """
        # 检查空文件名
        if not filename or not filename.strip():
            return False
        
        # 检查非法字符
        if re.search(r'[\\/:*?"<>|]', filename):
            return False
        
        # 检查长度
        if len(filename) > 255:
            return False
        
        return True
    
    @staticmethod
    def validate_path(path: str) -> bool:
        """
        验证路径是否安全
        
        Args:
            path: 路径字符串
            
        Returns:
            bool: 是否安全
        """
        # 检查空路径
        if not path or not path.strip():
            return False
        
        # 检查路径遍历
        if '..' in path:
            return False
        
        # 检查危险字符
        if re.search(r'[&|<>^]', path):
            return False
        
        return True


class SafePathHandler:
    """安全路径处理器"""
    
    def __init__(self, base_dir: str):
        """
        初始化安全路径处理器
        
        Args:
            base_dir: 基础目录路径
        """
        self.base_dir = Path(base_dir).resolve()
        
        # 确保基础目录存在
        if not self.base_dir.exists():
            self.base_dir.mkdir(parents=True, exist_ok=True)
    
    def safe_join(self, user_path: str) -> Optional[Path]:
        """
        安全地连接路径
        
        Args:
            user_path: 用户提供的路径
            
        Returns:
            Optional[Path]: 安全路径，如果不安全则返回None
        """
        try:
            # 构建完整路径
            full_path = (self.base_dir / user_path).resolve()
            
            # 验证路径是否在基础目录内
            if not str(full_path).startswith(str(self.base_dir)):
                return None
            
            return full_path
        except (ValueError, OSError):
            return None
    
    def safe_read(self, filename: str) -> Optional[str]:
        """
        安全地读取文件
        
        Args:
            filename: 文件名
            
        Returns:
            Optional[str]: 文件内容，如果不安全则返回None
        """
        # 验证路径
        file_path = self.safe_join(filename)
        if file_path is None:
            return None
        
        # 检查文件是否存在
        if not file_path.exists():
            return None
        
        try:
            return file_path.read_text(encoding='utf-8')
        except (IOError, UnicodeDecodeError):
            return None
    
    def safe_write(self, filename: str, content: str) -> bool:
        """
        安全地写入文件
        
        Args:
            filename: 文件名
            content: 文件内容
            
        Returns:
            bool: 是否成功
        """
        # 验证路径
        file_path = self.safe_join(filename)
        if file_path is None:
            return False
        
        try:
            file_path.write_text(content, encoding='utf-8')
            return True
        except IOError:
            return False


class SecureHasher:
    """安全哈希计算器"""
    
    @staticmethod
    def calculate_md5(file_path: str) -> Optional[str]:
        """
        计算文件的MD5哈希值
        
        Args:
            file_path: 文件路径
            
        Returns:
            Optional[str]: MD5哈希值，如果失败则返回None
        """
        try:
            with open(file_path, 'rb') as f:
                file_hash = hashlib.md5()
                for chunk in iter(lambda: f.read(4096), b""):
                    file_hash.update(chunk)
            return file_hash.hexdigest()
        except (IOError, OSError):
            return None
    
    @staticmethod
    def calculate_sha256(file_path: str) -> Optional[str]:
        """
        计算文件的SHA256哈希值
        
        Args:
            file_path: 文件路径
            
        Returns:
            Optional[str]: SHA256哈希值，如果失败则返回None
        """
        try:
            with open(file_path, 'rb') as f:
                file_hash = hashlib.sha256()
                for chunk in iter(lambda: f.read(4096), b""):
                    file_hash.update(chunk)
            return file_hash.hexdigest()
        except (IOError, OSError):
            return None
    
    @staticmethod
    def hash_password(password: str, salt: Optional[bytes] = None) -> Tuple[bytes, bytes]:
        """
        安全地哈希密码
        
        Args:
            password: 密码
            salt: 盐值（可选）
            
        Returns:
            Tuple[bytes, bytes]: (盐值, 哈希值)
        """
        if salt is None:
            salt = secrets.token_bytes(32)
        
        # 使用PBKDF2进行密码哈希
        key = hashlib.pbkdf2_hmac(
            'sha256',
            password.encode('utf-8'),
            salt,
            100000  # 迭代次数
        )
        
        return salt, key


class AuditLogger:
    """审计日志记录器"""
    
    def __init__(self, log_dir: str):
        """
        初始化审计日志记录器
        
        Args:
            log_dir: 日志目录
        """
        self.log_dir = Path(log_dir)
        self.log_dir.mkdir(parents=True, exist_ok=True)
        
        # 配置日志
        self.logger = logging.getLogger('audit')
        self.logger.setLevel(logging.INFO)
        
        # 创建文件处理器
        log_file = self.log_dir / 'audit.log'
        file_handler = logging.FileHandler(log_file, encoding='utf-8')
        file_handler.setLevel(logging.INFO)
        
        # 创建格式化器
        formatter = logging.Formatter(
            '%(asctime)s - %(levelname)s - %(message)s'
        )
        file_handler.setFormatter(formatter)
        
        # 添加处理器
        self.logger.addHandler(file_handler)
    
    def log_event(self, event_type: str, message: str, user: str = None):
        """
        记录审计事件
        
        Args:
            event_type: 事件类型
            message: 事件消息
            user: 用户名（可选）
        """
        if user is None:
            user = os.getenv('USERNAME', 'unknown')
        
        log_message = f"[{event_type}] User: {user} - {message}"
        self.logger.info(log_message)
    
    def log_security_event(self, event_type: str, message: str):
        """
        记录安全事件
        
        Args:
            event_type: 事件类型
            message: 事件消息
        """
        self.log_event(f"SECURITY_{event_type}", message)
    
    def log_error(self, error_code: str, message: str):
        """
        记录错误事件
        
        Args:
            error_code: 错误代码
            message: 错误消息
        """
        log_message = f"[ERROR] Code: {error_code} - {message}"
        self.logger.error(log_message)


class InputSanitizer:
    """输入消毒器"""
    
    @staticmethod
    def sanitize_filename(filename: str) -> str:
        """
        消毒文件名
        
        Args:
            filename: 原始文件名
            
        Returns:
            str: 消毒后的文件名
        """
        # 移除危险字符
        sanitized = re.sub(r'[\\/:*?"<>|]', '', filename)
        
        # 移除首尾空格
        sanitized = sanitized.strip()
        
        # 限制长度
        if len(sanitized) > 255:
            sanitized = sanitized[:255]
        
        return sanitized
    
    @staticmethod
    def sanitize_input(user_input: str) -> str:
        """
        消毒用户输入
        
        Args:
            user_input: 原始输入
            
        Returns:
            str: 消毒后的输入
        """
        # 移除危险字符
        sanitized = re.sub(r'[&|<>^;]', '', user_input)
        
        # 移除路径遍历
        sanitized = sanitized.replace('..', '')
        
        # 移除首尾空格
        sanitized = sanitized.strip()
        
        return sanitized
    
    @staticmethod
    def escape_command_arg(arg: str) -> str:
        """
        转义命令行参数
        
        Args:
            arg: 原始参数
            
        Returns:
            str: 转义后的参数
        """
        # 使用引号包裹
        if ' ' in arg or any(c in arg for c in '&|<>^'):
            return f'"{arg}"'
        return arg


def demonstrate_input_validation():
    """演示输入验证"""
    print("=" * 60)
    print("输入验证演示")
    print("=" * 60)
    
    validator = SecurityValidator()
    
    # 测试用例
    test_cases = [
        ("", False, "空输入"),
        ("hello_world", True, "正常输入"),
        ("file.txt & del /f /q C:\\*.*", False, "命令注入攻击"),
        ("..\\..\\..\\Windows\\System32\\config\\SAM", False, "路径遍历攻击"),
        ("file:name.txt", False, "包含非法字符"),
        ("normal_file.txt", True, "正常文件名"),
    ]
    
    for test_input, expected, description in test_cases:
        result = validator.validate_input(test_input)
        status = "PASS" if result == expected else "FAIL"
        print(f"[{status}] {description}: '{test_input}' -> {result}")


def demonstrate_path_security():
    """演示路径安全"""
    print("\n" + "=" * 60)
    print("路径安全演示")
    print("=" * 60)
    
    # 创建临时目录
    temp_dir = Path("temp_security_test")
    temp_dir.mkdir(exist_ok=True)
    
    try:
        handler = SafePathHandler(str(temp_dir))
        
        # 测试安全路径
        test_paths = [
            ("file.txt", True, "正常文件"),
            ("..\\..\\secret.txt", False, "路径遍历攻击"),
            ("C:\\Windows\\System32\\cmd.exe", False, "绝对路径"),
            ("subdir\\file.txt", True, "子目录文件"),
        ]
        
        for test_path, expected, description in test_paths:
            result = handler.safe_join(test_path)
            is_safe = result is not None
            status = "PASS" if is_safe == expected else "FAIL"
            print(f"[{status}] {description}: '{test_path}' -> {'安全' if is_safe else '不安全'}")
    
    finally:
        # 清理临时目录
        import shutil
        shutil.rmtree(temp_dir, ignore_errors=True)


def demonstrate_hashing():
    """演示哈希计算"""
    print("\n" + "=" * 60)
    print("哈希计算演示")
    print("=" * 60)
    
    hasher = SecureHasher()
    
    # 创建测试文件
    test_file = Path("test_hash.txt")
    test_file.write_text("Hello, World!", encoding='utf-8')
    
    try:
        # 计算哈希
        md5_hash = hasher.calculate_md5(str(test_file))
        sha256_hash = hasher.calculate_sha256(str(test_file))
        
        print(f"文件: {test_file}")
        print(f"MD5: {md5_hash}")
        print(f"SHA256: {sha256_hash}")
        
        # 测试密码哈希
        password = "secure_password"
        salt, key = hasher.hash_password(password)
        
        print(f"\n密码哈希:")
        print(f"盐值: {salt.hex()[:16]}...")
        print(f"哈希: {key.hex()[:16]}...")
    
    finally:
        # 清理测试文件
        test_file.unlink(missing_ok=True)


def demonstrate_logging():
    """演示日志记录"""
    print("\n" + "=" * 60)
    print("日志记录演示")
    print("=" * 60)
    
    # 创建临时日志目录
    log_dir = Path("temp_logs")
    
    try:
        logger = AuditLogger(str(log_dir))
        
        # 记录各种事件
        logger.log_event("INFO", "用户登录系统")
        logger.log_security_event("LOGIN_SUCCESS", "登录成功")
        logger.log_error("FILE_NOT_FOUND", "找不到文件: test.txt")
        
        print("日志记录完成")
        print(f"日志目录: {log_dir}")
        
        # 显示日志内容
        log_file = log_dir / 'audit.log'
        if log_file.exists():
            print("\n日志内容:")
            print(log_file.read_text(encoding='utf-8'))
    
    finally:
        # 清理临时日志目录
        import shutil
        shutil.rmtree(log_dir, ignore_errors=True)


def demonstrate_sanitization():
    """演示输入消毒"""
    print("\n" + "=" * 60)
    print("输入消毒演示")
    print("=" * 60)
    
    sanitizer = InputSanitizer()
    
    # 测试用例
    test_cases = [
        ("file:name.txt", "文件名消毒"),
        ("  hello world  ", "空格处理"),
        ("file.txt & command", "命令注入消毒"),
        ("..\\..\\path", "路径遍历消毒"),
    ]
    
    for test_input, description in test_cases:
        sanitized = sanitizer.sanitize_input(test_input)
        print(f"{description}:")
        print(f"  输入: '{test_input}'")
        print(f"  输出: '{sanitized}'")
        print()


def main():
    """主函数"""
    print("Python安全编程对比示例")
    print("=" * 60)
    
    try:
        demonstrate_input_validation()
        demonstrate_path_security()
        demonstrate_hashing()
        demonstrate_logging()
        demonstrate_sanitization()
        
        print("\n" + "=" * 60)
        print("所有演示完成")
        print("=" * 60)
        
    except Exception as e:
        print(f"错误: {e}")
        import traceback
        traceback.print_exc()


if __name__ == "__main__":
    main()