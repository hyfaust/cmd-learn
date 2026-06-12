# 第01章：Hello CMD — 初识命令行脚本

## 学习目标

通过本章学习，你将能够：

1. 理解CMD/BAT脚本的基本概念和用途
2. 编写简单的批处理脚本
3. 使用变量、运算符和特殊变量
4. 掌握命令连接符和转义字符的使用
5. 理解CMD脚本与其他编程语言的差异

!!! note "学习时间"
    预计学习时间：45-60分钟

## 概述

CMD（Command Prompt）是Windows操作系统中的命令行解释器，而BAT（Batch）文件是包含一系列CMD命令的脚本文件。学习CMD/BAT脚本编程可以帮助你：

- 自动化重复性任务
- 系统管理和维护
- 批量处理文件和文件夹
- 编写简单的系统工具

!!! tip "为什么学习CMD脚本？"
    在现代开发中，虽然PowerShell和Python更强大，但CMD脚本仍然是Windows系统管理的基础。理解CMD脚本有助于：
    - 维护遗留系统
    - 编写简单的启动脚本
    - 理解Windows批处理机制
    - 为学习PowerShell打下基础

## 核心概念详解

### 1. CMD.exe 与 cmd.exe 的关系

在Windows系统中，CMD.exe是命令行解释器的可执行文件。在文件系统中，它通常位于：

```bat
C:\Windows\System32\cmd.exe
```

**重要说明：**
- Windows文件系统不区分大小写，所以CMD.exe和cmd.exe指的是同一个文件
- 在脚本中调用时，通常使用小写形式：`cmd`
- 可以通过`where cmd`命令查看cmd.exe的实际位置

```bat
@echo off
echo 查找cmd.exe位置：
where cmd
echo.
echo 当前使用的cmd版本：
cmd /ver
pause
```

!!! warning "注意事项"
    虽然Windows不区分大小写，但为了代码一致性，建议在脚本中使用小写形式`cmd`。

### 2. BAT文件 vs CMD文件的区别

| 特性 | BAT文件 | CMD文件 |
|------|---------|---------|
| 扩展名 | `.bat` | `.cmd` |
| 历史背景 | MS-DOS时代遗留 | Windows NT时代引入 |
| 执行引擎 | cmd.exe | cmd.exe |
| 语法差异 | 基本相同 | 基本相同 |
| 主要区别 | 兼容性更好 | 支持更多现代特性 |

**关键区别：**
- 在现代Windows中，两者功能几乎相同
- CMD文件在某些错误处理上略有不同
- BAT文件在旧版DOS系统中兼容性更好
- 实际开发中，使用`.bat`扩展名更为常见

```bat
:: 这是一个BAT文件示例
@echo off
echo 这是BAT文件
pause
```

```cmd
:: 这是一个CMD文件示例（语法完全相同）
@echo off
echo 这是CMD文件
pause
```

!!! tip "选择建议"
    对于新项目，建议使用`.bat`扩展名，因为它具有更好的兼容性和更广泛的认知度。

### 3. echo 命令详解

`echo`命令是CMD脚本中最常用的命令之一，用于输出文本到控制台。

#### 3.1 基本输出

```bat
@echo off
echo Hello, World!
echo 当前时间：%DATE% %TIME%
pause
```

#### 3.2 输出空行

```bat
@echo off
echo 第一行
echo.  :: 注意：echo后面有一个点号
echo 第三行
pause
```

!!! warning "echo. 的正确写法"
    输出空行时，必须写成`echo.`（echo后面紧跟一个点号），不能有空格。写成`echo .`会输出一个点号。

#### 3.3 开启/关闭回显

```bat
@echo off  :: 关闭命令回显（推荐在脚本开头使用）
echo 这行不会显示命令本身

echo on    :: 开启命令回显
echo 这行会显示命令本身
```

**回显控制：**
- `@echo off`：关闭命令回显，只显示命令输出
- `@`：放在命令前，只对该命令关闭回显
- `echo on`：开启命令回显
- 不带参数的`echo`：显示当前回显状态

```bat
@echo off
echo 关闭回显模式
@echo on
echo 开启回显模式
@echo off
echo 再次关闭回显
pause
```

### 4. set 命令详解

`set`命令用于定义和操作变量。

#### 4.1 定义变量

```bat
@echo off
:: 定义字符串变量
set "name=CMD学习者"
set "greeting=你好"

:: 输出变量
echo %name%
echo %greeting%
pause
```

#### 4.2 使用 /A 进行算术运算

```bat
@echo off
:: 整数运算
set /a "result=2+3"
echo 2+3 = %result%

set /a "result=10*5"
echo 10*5 = %result%

set /a "result=100/3"
echo 100/3 = %result%

:: 复杂运算
set /a "result=(2+3)*4"
echo (2+3)*4 = %result%
pause
```

**支持的运算符：**
- `+`：加法
- `-`：减法
- `*`：乘法
- `/`：除法（整数除法）
- `%`：取模
- `()`：括号改变优先级

#### 4.3 使用 /P 获取用户输入

```bat
@echo off
:: 获取用户输入
set /p "user_name=请输入你的名字: "
echo 你好, %user_name%!

:: 带默认提示的输入
set /p "choice=请选择操作(Y/N): "
echo 你选择了: %choice%
pause
```

!!! tip "变量命名规范"
    - 变量名建议使用有意义的英文单词
    - 避免使用特殊字符和空格
    - 建议使用下划线分隔：`user_name`而不是`username`或`user name`

### 5. 变量引用：%var% 与延迟扩展 !var!

#### 5.1 基本变量引用：%var%

```bat
@echo off
set "message=Hello"
echo %message%
pause
```

#### 5.2 延迟扩展：!var!

在循环或条件语句中，变量在解析时就会被替换，而不是在执行时。这时需要使用延迟扩展。

```bat
@echo off
setlocal EnableDelayedExpansion

set "count=0"
for /l %%i in (1,1,5) do (
    set /a "count+=1"
    echo 当前计数: !count!  :: 使用!而不是%
)

endlocal
pause
```

**何时使用延迟扩展：**
- 在`for`循环内部修改变量
- 在`if`语句块内部修改变量
- 需要在代码块执行时获取变量最新值

```bat
@echo off
setlocal EnableDelayedExpansion

:: 演示延迟扩展的必要性
set "value=initial"
if 1==1 (
    set "value=modified"
    echo 使用%%: %value%    :: 输出: initial（错误）
    echo 使用!: !value!    :: 输出: modified（正确）
)

endlocal
pause
```

!!! warning "延迟扩展的陷阱"
    延迟扩展会扩展`!`字符，如果字符串中包含`!`，需要特别小心：
    ```bat
    setlocal EnableDelayedExpansion
    set "text=Hello! World"
    echo !text!  :: 输出: Hello World（感叹号被吞掉）
    ```

### 6. 注释：REM 和 :: 的区别

#### 6.1 REM 注释

```bat
@echo off
REM 这是一个REM注释
REM REM注释会被回显（如果回显开启）
echo Hello
pause
```

#### 6.2 :: 注释

```bat
@echo off
:: 这是一个::注释
:: ::注释永远不会被回显
echo Hello
pause
```

**主要区别：**

| 特性 | REM | :: |
|------|-----|-----|
| 回显行为 | 如果回显开启，会显示REM命令 | 永远不会被回显 |
| 执行速度 | 稍慢（需要解析） | 更快（直接跳过） |
| 使用场景 | 需要显示注释时 | 一般注释（推荐） |
| 兼容性 | 所有版本 | 某些旧版本可能有问题 |

!!! tip "最佳实践"
    - 日常注释使用`::`
    - 需要调试时临时使用`REM`（可以看到注释被执行）
    - 避免在括号代码块内使用`::`（可能导致语法错误）

### 7. 命令连接符：&、&&、||

#### 7.1 & - 无条件连接

```bat
@echo off
echo 命令1 & echo 命令2 & echo 命令3
pause
```

**特点：**
- 无论前一个命令是否成功，都会执行后续命令
- 适合执行多个独立命令

#### 7.2 && - 成功后执行

```bat
@echo off
dir C:\Windows && echo 目录存在
dir C:\NonExistent && echo 这行不会执行
pause
```

**特点：**
- 只有前一个命令成功（返回码为0）才执行后续命令
- 适合条件执行

#### 7.3 || - 失败后执行

```bat
@echo off
dir C:\NonExistent || echo 目录不存在
dir C:\Windows || echo 这行不会执行
pause
```

**特点：**
- 只有前一个命令失败（返回码非0）才执行后续命令
- 适合错误处理

```bat
@echo off
:: 组合使用示例
dir C:\Windows && echo 成功 || echo 失败
dir C:\NonExistent && echo 成功 || echo 失败
pause
```

!!! note "逻辑理解"
    - `&&`：前一个成功才执行（逻辑与）
    - `||`：前一个失败才执行（逻辑或）
    - 组合使用：`命令1 && 命令2 || 命令3` 表示"如果命令1成功执行命令2，否则执行命令3"

### 8. 转义字符：^ 的使用

在CMD中，`^`是转义字符，用于转义特殊字符。

#### 8.1 转义特殊字符

```bat
@echo off
:: 输出特殊字符
echo 这是^&符号
echo 这是^|符号
echo 这是^<符号
echo 这是^>符号
pause
```

#### 8.2 转义百分号

```bat
@echo off
set "var=value"
echo %var%      :: 输出: value
echo %%var%%    :: 输出: %var%（百分号被转义）
pause
```

#### 8.3 续行符

```bat
@echo off
:: 使用^作为续行符
echo 这是第一行^
这是第二行^
这是第三行
pause
```

**常用转义场景：**
- 输出`&`、`|`、`<`、`>`等特殊字符
- 在字符串中包含百分号`%`
- 将长命令分成多行书写

```bat
@echo off
:: 实际应用示例
echo 文件路径：C:\Program^ Files^ ^(x86^)
echo 数学表达式：2^>1^&3^<5
pause
```

!!! warning "转义注意事项"
    - 在引号内的字符通常不需要转义
    - 转义字符`^`本身需要用`^^`来表示
    - 在`for`循环的某些情况下，转义规则会更复杂

## 数据结构概念

### CMD中的变量本质

CMD中的变量与高级语言有本质区别：

1. **字符串存储**：所有变量都是字符串类型
2. **无类型系统**：没有整数、浮点数等类型区分
3. **延迟解析**：变量在解析时替换，不是运行时
4. **作用域限制**：默认全局，使用`setlocal`创建局部作用域

```bat
@echo off
:: 变量都是字符串
set "number=123"
set "text=hello"
set "mixed=123abc"

:: 即使是数字，也是字符串
echo %number% + %number%  :: 输出: 123 + 123（不是246）

:: 需要用/A进行算术运算
set /a "result=number+number"
echo %result%  :: 输出: 246
pause
```

### 环境变量与局部变量的区别

| 特性 | 环境变量 | 局部变量 |
|------|----------|----------|
| 定义方式 | `set var=value` | `setlocal`后定义的变量 |
| 作用域 | 全局（继承给子进程） | 当前脚本/会话 |
| 生命周期 | 永久（系统环境变量）或会话级 | 脚本结束或`endlocal` |
| 访问方式 | `%var%` | `%var%` |

```bat
@echo off
:: 局部变量示例
setlocal
set "local_var=这是局部变量"
echo %local_var%
endlocal

:: 环境变量示例
set "global_var=这是环境变量"
echo %global_var%
pause
```

### 特殊变量

CMD提供了一些预定义的特殊变量：

```bat
@echo off
:: 参数相关
echo 脚本名称: %~nx0
echo 脚本路径: %~dp0
echo 第一个参数: %1
echo 所有参数: %*

:: 系统变量
echo 当前目录: %CD%
echo 日期: %DATE%
echo 时间: %TIME%
echo 错误码: %ERRORLEVEL%

:: 参数扩展示例
echo 完整路径: %~f0
echo 驱动器: %~d0
echo 路径: %~p0
echo 文件名: %~n0
echo 扩展名: %~x0
pause
```

**常用特殊变量列表：**

| 变量 | 描述 | 示例 |
|------|------|------|
| `%0`~`%9` | 命令行参数 | `%1`是第一个参数 |
| `%*` | 所有参数 | 包含所有命令行参数 |
| `%ERRORLEVEL%` | 上一个命令的返回码 | 0表示成功 |
| `%CD%` | 当前工作目录 | `C:\Users\user` |
| `%DATE%` | 当前日期 | `2026/06/11` |
| `%TIME%` | 当前时间 | `14:30:45.67` |
| `%RANDOM%` | 随机数（0-32767） | 生成随机数 |
| `%~dp0` | 脚本所在目录 | `C:\scripts\` |
| `%~nx0` | 脚本文件名 | `script.bat` |

## 与Python/JavaScript的对比

### 变量定义对比

| 操作 | CMD | Python | JavaScript |
|------|-----|--------|------------|
| 定义变量 | `set "var=value"` | `var = value` | `let var = value;` |
| 常量 | 无原生支持 | `VAR = value`（约定） | `const VAR = value;` |
| 算术运算 | `set /a "result=1+2"` | `result = 1 + 2` | `let result = 1 + 2;` |
| 字符串拼接 | `set "str=%a% %b%"` | `str = f"{a} {b}"` | `let str = \`${a} ${b}\`;` |

### 输出对比

| 语言 | 输出语句 | 示例 |
|------|----------|------|
| CMD | `echo` | `echo Hello` |
| Python | `print()` | `print("Hello")` |
| JavaScript | `console.log()` | `console.log("Hello");` |

### 注释对比

| 语言 | 单行注释 | 多行注释 |
|------|----------|----------|
| CMD | `:: 注释` 或 `REM 注释` | 无原生支持 |
| Python | `# 注释` | `""" 多行注释 """` |
| JavaScript | `// 注释` | `/* 多行注释 */` |

### 条件语句对比

```bat
:: CMD
if "%choice%"=="Y" (
    echo 你选择了是
) else (
    echo 你选择了否
)
```

```python
# Python
if choice == "Y":
    print("你选择了是")
else:
    print("你选择了否")
```

```javascript
// JavaScript
if (choice === "Y") {
    console.log("你选择了是");
} else {
    console.log("你选择了否");
}
```

### 循环对比

```bat
:: CMD - for循环
for /l %%i in (1,1,5) do (
    echo %%i
)
```

```python
# Python - for循环
for i in range(1, 6):
    print(i)
```

```javascript
// JavaScript - for循环
for (let i = 1; i <= 5; i++) {
    console.log(i);
}
```

## 最佳实践和常见陷阱

### 最佳实践

#### 1. 脚本开头总是使用`@echo off`

```bat
@echo off
:: 脚本内容...
```

#### 2. 使用`setlocal`和`endlocal`管理变量作用域

```bat
@echo off
setlocal

:: 脚本内容...

endlocal
```

#### 3. 变量定义时使用引号

```bat
:: 推荐
set "name=John Doe"

:: 不推荐（可能包含尾随空格）
set name=John Doe
```

#### 4. 使用延迟扩展处理循环中的变量

```bat
@echo off
setlocal EnableDelayedExpansion

set "count=0"
for /l %%i in (1,1,5) do (
    set /a "count+=1"
    echo !count!
)

endlocal
```

#### 5. 添加错误检查

```bat
@echo off
:: 执行命令并检查错误码
some_command
if %ERRORLEVEL% neq 0 (
    echo 命令执行失败
    exit /b 1
)
```

### 常见陷阱

#### 1. 变量扩展时机问题

```bat
@echo off
:: 错误示例
set "value=initial"
if 1==1 (
    set "value=modified"
    echo %value%  :: 输出: initial（错误！）
)

:: 正确示例
setlocal EnableDelayedExpansion
set "value=initial"
if 1==1 (
    set "value=modified"
    echo !value!  :: 输出: modified（正确）
)
endlocal
```

#### 2. 特殊字符未转义

```bat
@echo off
:: 错误示例
echo 这是&符号  :: 语法错误

:: 正确示例
echo 这是^&符号
```

#### 3. 路径包含空格

```bat
@echo off
:: 错误示例
cd C:\Program Files  :: 语法错误

:: 正确示例
cd "C:\Program Files"
```

#### 4. 百分号处理

```bat
@echo off
:: 错误示例
echo 100%  :: 可能被解析为变量

:: 正确示例
echo 100%%
```

#### 5. 比较操作符错误

```bat
@echo off
:: 错误示例（使用等号）
if %var% == 1 echo 相等

:: 正确示例（使用equ）
if %var% equ 1 echo 相等
```

!!! warning "调试技巧"
    - 在脚本开头添加`echo on`查看命令执行过程
    - 使用`pause`命令暂停脚本执行
    - 将变量值输出到临时文件进行检查
    - 使用`set`命令查看所有变量

## 练习题

### 练习1：基础变量操作

编写一个脚本，完成以下任务：
1. 定义两个变量：`first_name`和`last_name`
2. 将它们拼接成完整姓名
3. 输出问候语："你好，[姓名]！欢迎学习CMD脚本！"

**要求：**
- 使用`set`命令定义变量
- 使用`echo`输出结果
- 添加适当的注释

!!! tip "提示"
    可以使用`set "full_name=%first_name% %last_name%"`来拼接字符串。

### 练习2：算术计算器

编写一个简单的计算器脚本：
1. 提示用户输入两个数字
2. 计算并显示它们的和、差、积、商
3. 显示计算结果

**要求：**
- 使用`set /p`获取用户输入
- 使用`set /a`进行算术运算
- 处理除零错误

```bat
:: 示例输出
请输入第一个数字: 10
请输入第二个数字: 3
和: 13
差: 7
积: 30
商: 3
```

### 练习3：系统信息显示

编写一个脚本显示当前系统信息：
1. 显示当前日期和时间
2. 显示当前工作目录
3. 显示脚本所在目录
4. 显示用户名（环境变量`%USERNAME%`）

**要求：**
- 使用特殊变量`%DATE%`、`%TIME%`、`%CD%`
- 使用`%~dp0`获取脚本路径
- 使用`%USERNAME%`获取用户名
- 格式化输出，使其易于阅读

### 练习4：命令连接符练习

编写一个脚本演示命令连接符的使用：
1. 使用`&&`连接两个命令，只有第一个成功才执行第二个
2. 使用`||`连接两个命令，只有第一个失败才执行第二个
3. 使用`&`连接三个命令，无条件执行
4. 组合使用`&&`和`||`实现简单的条件逻辑

**示例：**
```bat
:: 检查目录是否存在，不存在则创建
dir C:\TestDir && echo 目录存在 || echo 目录不存在
```

### 练习5：延迟扩展挑战

编写一个脚本，演示延迟扩展的必要性：
1. 创建一个从1到10的循环
2. 在循环中计算累加和
3. 显示每一步的累加结果

**要求：**
- 必须使用延迟扩展`!var!`
- 显示清晰的步骤信息
- 解释为什么需要延迟扩展

```bat
:: 示例输出
步骤1: 累加和 = 1
步骤2: 累加和 = 3
步骤3: 累加和 = 6
...
步骤10: 累加和 = 55
```

## 下一步学习

完成本章学习后，你将掌握CMD脚本的基础知识。在下一章中，我们将学习：

1. 文件和目录管理命令
2. 文件属性操作
3. 目录遍历和搜索
4. 文件内容处理

!!! note "学习建议"
    - 动手实践每个示例代码
    - 完成所有练习题
    - 尝试修改示例代码，观察不同行为
    - 记录遇到的问题和解决方案

## 附录：常用命令速查表

| 命令 | 描述 | 示例 |
|------|------|------|
| `echo` | 输出文本 | `echo Hello` |
| `set` | 定义变量 | `set var=value` |
| `set /a` | 算术运算 | `set /a result=1+2` |
| `set /p` | 用户输入 | `set /p input=请输入: ` |
| `if` | 条件判断 | `if exist file.txt echo 存在` |
| `for` | 循环 | `for %%i in (*.txt) do echo %%i` |
| `dir` | 列出目录 | `dir C:\Windows` |
| `cd` | 切换目录 | `cd C:\Users` |
| `copy` | 复制文件 | `copy file1.txt file2.txt` |
| `move` | 移动文件 | `move file.txt C:\Backup\` |
| `del` | 删除文件 | `del file.txt` |
| `mkdir` | 创建目录 | `mkdir NewFolder` |
| `rmdir` | 删除目录 | `rmdir EmptyFolder` |
| `pause` | 暂停脚本 | `pause` |
| `exit` | 退出脚本 | `exit /b 0` |

---

**章节总结：**
本章介绍了CMD/BAT脚本编程的基础知识，包括变量、运算符、特殊变量、注释、命令连接符和转义字符。通过对比其他编程语言，帮助你理解CMD脚本的特点。掌握这些基础知识后，你将能够编写简单的批处理脚本，并为后续学习打下坚实基础。