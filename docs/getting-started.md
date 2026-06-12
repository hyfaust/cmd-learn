# 快速开始

!!! info "5分钟上手 CMD/BAT 编程"
    本章将带你快速搭建开发环境，创建并运行你的第一个 BAT 文件，掌握基本的调试技巧。

## 🛠️ 安装和准备

### 1. 确认 CMD 可用

Windows 系统自带 CMD.exe，无需额外安装。按下 `Win + R`，输入 `cmd`，回车即可打开。

```cmd
:: 检查 CMD 版本
Microsoft Windows [版本 10.0.19045.3803]
(c) Microsoft Corporation。保留所有权利。

C:\Users\YourName>
```

!!! tip "多种打开方式"

    - **方法1**：`Win + R` → 输入 `cmd` → 回车
    - **方法2**：在文件资源管理器地址栏输入 `cmd` → 回车（在当前目录打开）
    - **方法3**：按住 `Shift` 键，右键点击文件夹 → 选择"在此处打开 PowerShell 窗口"
    - **方法4**：使用 Windows Terminal（推荐，支持多标签）

### 2. 创建工作目录

建议创建一个专门的学习目录：

```cmd
:: 创建学习目录
mkdir C:\Users\%USERNAME%\cmd_learn

:: 进入学习目录
cd C:\Users\%USERNAME%\cmd_learn

:: 创建子目录结构
mkdir examples
mkdir projects
mkdir temp

:: 查看目录结构
tree /F
```

### 3. 配置文本编辑器

=== "VS Code（推荐）"

    **安装步骤**
    
    1. 下载 [VS Code](https://code.visualstudio.com/)
    2. 安装时勾选"添加到 PATH"
    3. 安装完成后重启 CMD
    
    **推荐插件**
    
    - **Batch Runner**：一键运行 BAT 文件
    - **Batch Script**：语法高亮和自动补全
    - **Code Runner**：支持多种语言运行
    
    **快速打开**
    
    ```cmd
    :: 在当前目录打开 VS Code
    code .
    
    :: 打开特定文件
    code hello.bat
    ```

=== "Notepad++"

    **安装步骤**
    
    1. 下载 [Notepad++](https://notepad-plus-plus.org/)
    2. 默认安装即可
    
    **优势**
    
    - 轻量级，启动快
    - 内置批处理语法高亮
    - 支持列编辑模式
    
    **快速打开**
    
    ```cmd
    :: 打开文件
    notepad++ hello.bat
    ```

=== "Windows Terminal"

    **安装步骤**
    
    1. 从 Microsoft Store 安装 Windows Terminal
    2. 或使用 `winget install Microsoft.WindowsTerminal`
    
    **优势**
    
    - 多标签页支持
    - 自定义主题和字体
    - 支持 CMD、PowerShell、WSL 切换
    
    **配置**
    
    在设置中添加 CMD 配置文件：
    ```json
    {
        "name": "CMD",
        "commandline": "cmd.exe",
        "startingDirectory": "%USERPROFILE%"
    }
    ```

## 📝 第一个 BAT 文件

### 创建 hello.bat

使用你喜欢的编辑器创建 `hello.bat`：

```bat
@echo off
chcp 65001 >nul
title 我的第一个BAT程序
color 0A

echo ========================================
echo        欢迎来到 CMD/BAT 编程世界！
echo ========================================
echo.
echo 当前时间: %date% %time%
echo 当前目录: %cd%
echo 用户名: %username%
echo 计算机名: %computername%
echo.

echo 正在执行第一个命令...
timeout /t 2 >nul
echo 命令执行完成！

echo.
echo 按任意键退出...
pause >nul
```

### 运行和调试

**方法1：双击运行**

直接双击 `hello.bat` 文件即可运行。

**方法2：命令行运行**

```cmd
:: 进入文件所在目录
cd C:\Users\%USERNAME%\cmd_learn

:: 运行 BAT 文件
hello.bat

:: 或者指定完整路径
C:\Users\%USERNAME%\cmd_learn\hello.bat
```

**方法3：调试模式运行**

```cmd
:: 开启回显，查看每条命令的执行
echo on
hello.bat

:: 或者修改 BAT 文件，移除 @echo off
```

!!! warning "常见问题"

    **问题1：中文乱码**
    
    解决方案：在脚本开头添加 `chcp 65001 >nul` 切换到 UTF-8 编码
    
    **问题2：权限不足**
    
    解决方案：右键点击 CMD，选择"以管理员身份运行"
    
    **问题3：路径包含空格**
    
    解决方案：使用双引号包裹路径，如 `cd "C:\My Folder"`

## 🔧 常用开发工具

### VS Code 插件配置

创建 `.vscode\settings.json` 配置文件：

```json
{
    "batch-runner.runInTerminal": true,
    "batch-runner.cwd": "${workspaceFolder}",
    "editor.tabSize": 4,
    "editor.insertSpaces": false,
    "files.encoding": "utf8",
    "files.eol": "\r\n"
}
```

创建 `.vscode\launch.json` 调试配置：

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Run Batch File",
            "type": "node",
            "request": "launch",
            "program": "${file}",
            "console": "integratedTerminal"
        }
    ]
}
```

### 实用工具推荐

| 工具 | 用途 | 获取方式 |
|------|------|----------|
| **BatchMan** | BAT 文件编辑器 | 官网下载 |
| **Bat To Exe Converter** | 将 BAT 转换为 EXE | 官网下载 |
| **Resource Hacker** | 编辑 EXE 资源 | 官网下载 |
| **Process Monitor** | 监控进程活动 | Sysinternals |

## 🐛 调试技巧

### 1. Echo 调试法

最简单的调试方法是在关键位置添加 `echo` 语句：

```bat
@echo off
echo [DEBUG] 脚本开始执行
echo [DEBUG] 当前目录: %cd%

set "file=test.txt"
echo [DEBUG] 文件名: %file%

if exist "%file%" (
    echo [DEBUG] 文件存在
) else (
    echo [DEBUG] 文件不存在
)

echo [DEBUG] 脚本执行完毕
```

### 2. Pause 断点

在可疑位置插入 `pause` 命令，暂停执行查看状态：

```bat
@echo off
echo 第一步：准备数据
pause  :: 检查第一步是否正确

echo 第二步：处理数据
pause  :: 检查第二步是否正确

echo 第三步：保存结果
pause  :: 检查第三步是否正确
```

### 3. 错误重定向到文件

将错误信息保存到日志文件：

```bat
@echo off
set "logfile=debug.log"

echo [%date% %time%] 脚本开始 > "%logfile%"

:: 执行命令并重定向错误
some_command 2>> "%logfile%"

echo [%date% %time%] 脚本结束 >> "%logfile%"

:: 查看日志
type "%logfile%"
```

### 4. 使用命令回显

开启命令回显查看实际执行的命令：

```bat
@echo off
echo 开启命令回显...
echo on

:: 这些命令会被显示出来
dir /b *.txt
findstr /i "test" *.txt

@echo off
echo 命令回显已关闭
```

### 5. 调试脚本模板

创建一个调试模板 `debug_template.bat`：

```bat
@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: 调试模式开关
set "DEBUG=1"

:: 调试函数
:debug
if "%DEBUG%"=="1" (
    echo [DEBUG %time%] %~1
)
goto :eof

:: 主程序
call :debug "脚本开始执行"
call :debug "当前目录: %cd%"

:: 你的代码在这里
call :debug "处理完成"

call :debug "脚本结束"
pause
```

## 💡 学习建议

!!! tip "高效学习方法"

    **1. 动手实践**
    
    每个示例都要亲手运行，不要只看不练。复制粘贴虽然方便，但手动输入能加深记忆。
    
    **2. 理解原理**
    
    不要死记硬背命令，理解命令的工作原理。例如，`for` 循环为什么需要 `%%` 变量？
    
    **3. 多做实验**
    
    尝试修改示例代码，看看会发生什么。错误是最好的老师。
    
    **4. 记录笔记**
    
    遇到问题和解决方案时，记录下来。建立自己的知识库。
    
    **5. 参考文档**
    
    善用 `command /?` 查看命令帮助。例如 `for /?` 查看 for 循环的详细用法。

## 🎯 练习任务

完成以下练习，检验你的学习成果：

### 练习1：系统信息脚本

创建一个脚本，显示以下系统信息：
- 操作系统版本
- CPU 信息
- 内存信息
- 磁盘空间
- 网络配置

### 练习2：目录列表脚本

创建一个脚本，列出当前目录下的：
- 所有文件（按大小排序）
- 所有文件夹
- 最近修改的 5 个文件

### 练习3：简单计算器

创建一个简单的计算器脚本，支持：
- 加法
- 减法
- 乘法
- 除法

!!! note "练习提示"

    如果遇到困难，可以：
    
    1. 使用 `command /?` 查看命令帮助
    2. 参考本教程的其他章节
    3. 在搜索引擎中查找解决方案
    4. 参考附录中的命令速查表

## 📚 下一步

恭喜你完成了快速开始！现在你已经：

- ✅ 搭建了开发环境
- ✅ 创建并运行了第一个 BAT 文件
- ✅ 掌握了基本的调试技巧
- ✅ 了解了常用开发工具

接下来，让我们进入 [第1章：Hello CMD](ch01-hello-cmd/index.md)，开始系统学习 CMD/BAT 编程！

---

!!! quote "继续前进"

    > "千里之行，始于足下。"
    
    你已经迈出了第一步，接下来的每一步都会让你更接近目标。保持好奇心，享受编程的乐趣！
