# 第03章：条件与流程控制 — 程序的判断力

## 概述

在编程中，条件判断是程序能够根据不同的情况做出不同反应的核心能力。就像人类会根据天气决定是否带伞一样，程序也需要根据不同的条件执行不同的代码路径。在CMD批处理中，`if` 语句是实现条件判断的主要工具。

本章将深入讲解CMD中的条件判断机制，包括：
- `if` 语句的各种用法
- 比较运算符和字符串/数值比较的区别
- 文件存在性检查和错误级别检查
- 用户交互式选择
- 条件组合的简化写法

通过本章学习，你将能够编写出能够根据条件做出智能决策的批处理脚本。

## 核心概念详解

### 1. if 语句基础

`if` 语句是CMD中最基本的条件判断结构。它有三种主要用法：

#### 字符串比较

```bat
if "%variable%"=="value" (
    echo 条件成立
) else (
    echo 条件不成立
)
```

**关键点**：
- 必须使用双引号包裹变量和比较值
- `==` 进行字符串比较
- 注意空格敏感性：`if "%var%"=="value"` 与 `if "%var%" == "value"` 是不同的

#### 数值比较

```bat
set /a "num=42"
if %num% GTR 40 echo 大于40
if %num% LSS 50 echo 小于50
if %num% EQU 42 echo 等于42
```

**数值比较运算符**：
- `EQU` - 等于 (Equal)
- `NEQ` - 不等于 (Not Equal)
- `LSS` - 小于 (Less Than)
- `LEQ` - 小于等于 (Less or Equal)
- `GTR` - 大于 (Greater Than)
- `GEQ` - 大于等于 (Greater or Equal)

#### 文件存在性检查

```bat
if exist "filename.txt" (
    echo 文件存在
) else (
    echo 文件不存在
)
```

**支持通配符**：
```bat
if exist "*.txt" echo 存在txt文件
if exist "C:\Windows\*" echo Windows目录存在
```

### 2. 比较运算符详解

#### `==` 与 `EQU` 的区别

这是CMD中一个常见的混淆点：

```bat
@echo off
set "str1=10"
set "str2=010"

:: 字符串比较
if "%str1%"=="%str2%" (
    echo 字符串相等
) else (
    echo 字符串不相等
)

:: 数值比较
if %str1% EQU %str2% (
    echo 数值相等
) else (
    echo 数值不相等
)
```

**输出结果**：
```
字符串不相等
数值相等
```

**原理解释**：
- `==` 进行**字典序比较**（字符串比较），逐个字符比较ASCII码
- `EQU` 进行**数值比较**，先将字符串转换为数字再比较
- 字符串"10"和"010"在字典序中不同，但数值都是10

#### 字典序比较原理

字典序比较就像查字典：
1. 从左到右逐个字符比较
2. 比较字符的ASCII码值
3. 第一个不同的字符决定结果
4. 如果一个字符串是另一个的前缀，较短的字符串"更小"

示例：
```
"apple" < "banana"  (因为 'a' < 'b')
"abc" < "abcd"      (因为"abc"是"abcd"的前缀)
"10" < "2"          (因为 '1' < '2'，字典序比较)
```

### 3. if defined — 检查变量是否定义

```bat
@echo off
set "myvar=hello"

if defined myvar (
    echo myvar已定义，值为: %myvar%
) else (
    echo myvar未定义
)

:: 清除变量
set "myvar="
if defined myvar (
    echo myvar已定义
) else (
    echo myvar未定义
)
```

**优势**：
- 不需要担心变量值中的特殊字符
- 不需要引号包裹
- 更安全，避免变量未定义时的错误

### 4. if exist — 检查文件/目录是否存在

```bat
@echo off
:: 检查文件
if exist "%~dp0if_basics.bat" (
    echo if_basics.bat 存在
) else (
    echo if_basics.bat 不存在
)

:: 检查目录
if exist "%~dp0..\ch02" (
    echo ch02目录存在
)

:: 检查多个文件
if exist "*.txt" if exist "*.bat" (
    echo 同时存在txt和bat文件
)
```

**特殊路径变量**：
- `%~dp0` - 当前脚本所在目录（带反斜杠）
- `%~f0` - 当前脚本的完整路径
- `%~nx0` - 当前脚本的文件名和扩展名

### 5. if errorlevel — 检查错误级别

ERRORLEVEL是CMD中非常重要的机制，它存储了上一个命令的退出码。

```bat
@echo off
:: 执行命令并检查错误码
dir "%~dp0nonexistent" >nul 2>&1
if errorlevel 1 (
    echo 命令执行失败，ERRORLEVEL=%ERRORLEVEL%
) else (
    echo 命令执行成功
)
```

**常见的ERRORLEVEL值**：
- `0` - 成功
- `1` - 一般性错误
- `2` - 语法错误
- `9009` - 命令未找到

**重要特性**：
- `if errorlevel N` 检查的是 `ERRORLEVEL >= N`
- 要检查确切值，使用 `if %ERRORLEVEL% EQU N`

### 6. 嵌套 if 与 if ... else ...

CMD的if语句支持嵌套，但语法有特殊要求：

```bat
@echo off
set /a "score=85"

if %score% GEQ 90 (
    echo 优秀
) else if %score% GEQ 80 (
    echo 良好
) else if %score% GEQ 60 (
    echo 及格
) else (
    echo 不及格
)
```

**语法要点**：
- `else` 必须与 `)` 在同一行
- `else if` 可以写在同一行
- 括号内的命令可以跨多行

### 7. choice 命令 — 用户交互式选择

`choice` 命令提供了简单的用户交互方式：

```bat
@echo off
echo 请选择操作:
echo 1. 查看当前目录
echo 2. 查看当前时间
echo 3. 退出
choice /c 123 /n /m "请输入选择: "
if errorlevel 3 goto :end
if errorlevel 2 (
    echo 当前时间: %TIME%
    goto :end
)
if errorlevel 1 (
    dir "%~dp0" /b
)
:end
echo 操作完成
```

**参数说明**：
- `/c 123` - 定义可选字符为1、2、3
- `/n` - 不显示提示符
- `/m "text"` - 显示提示信息
- `/t N` - 默认选择等待N秒
- `/d choice` - 默认选择

### 8. 条件组合：&& 和 ||

CMD提供了简化的条件组合语法：

```bat
:: && - 前一个命令成功时执行
dir *.txt && echo 存在txt文件

:: || - 前一个命令失败时执行
dir *.xyz || echo 不存在xyz文件

:: 组合使用
dir *.txt && echo 存在 || echo 不存在
```

**逻辑原理**：
- `&&` 是逻辑与：前一个命令返回ERRORLEVEL=0时执行
- `||` 是逻辑或：前一个命令返回ERRORLEVEL≠0时执行
- 可以组合形成简单的if-else逻辑

## 数据结构概念

### ERRORLEVEL 机制

ERRORLEVEL是一个特殊的环境变量，存储了上一个外部命令的退出码：

```bat
@echo off
:: 查看当前ERRORLEVEL
echo 当前ERRORLEVEL: %ERRORLEVEL%

:: 执行命令会改变ERRORLEVEL
dir >nul
echo dir命令后的ERRORLEVEL: %ERRORLEVEL%

:: 错误命令
nonexistentcommand >nul 2>&1
echo 错误命令后的ERRORLEVEL: %ERRORLEVEL%
```

**重要特性**：
1. **自动更新**：每个外部命令执行后都会更新ERRORLEVEL
2. **持久性**：直到下一个命令执行前保持不变
3. **继承性**：子进程会继承父进程的ERRORLEVEL
4. **范围**：通常0-255，0表示成功

### 布尔逻辑在CMD中的实现

CMD没有真正的布尔类型，但通过以下方式实现布尔逻辑：

```bat
:: 使用ERRORLEVEL表示真假
:: 0 = true (成功), 非0 = false (失败)

:: 逻辑与 (&&)
command1 && command2  :: command1成功时执行command2

:: 逻辑或 (||)
command1 || command2  :: command1失败时执行command2

:: 逻辑非
if not condition (
    echo 条件不成立
)
```

### 字符串比较的字典序原理

字典序比较基于ASCII码值：

```bat
@echo off
:: 字符串比较示例
set "str1=apple"
set "str2=banana"

if "%str1%" LSS "%str2%" (
    echo "%str1%" 小于 "%str2%"
) else (
    echo "%str1%" 大于等于 "%str2%"
)
```

**ASCII码比较规则**：
1. 数字(0-9): 48-57
2. 大写字母(A-Z): 65-90
3. 小写字母(a-z): 97-122
4. 空格: 32

## 流程图

### if 判断流程

```mermaid
graph TD
    A[开始] --> B{条件判断}
    B -->|条件成立| C[执行代码块1]
    B -->|条件不成立| D{是否有else?}
    D -->|是| E[执行代码块2]
    D -->|否| F[跳过]
    C --> G[继续执行]
    E --> G
    F --> G
    G --> H[结束]
```

### 嵌套if流程

```mermaid
graph TD
    A[开始] --> B{条件1}
    B -->|成立| C[执行块1]
    B -->|不成立| D{条件2}
    D -->|成立| E[执行块2]
    D -->|不成立| F{条件3}
    F -->|成立| G[执行块3]
    F -->|不成立| H[执行else块]
    C --> I[继续]
    E --> I
    G --> I
    H --> I
    I --> J[结束]
```

## 与Python/JavaScript的对比

### if语句语法对比

#### Python
```python
# Python if/elif/else
score = 85

if score >= 90:
    print("优秀")
elif score >= 80:
    print("良好")
elif score >= 60:
    print("及格")
else:
    print("不及格")
```

#### JavaScript
```javascript
// JavaScript if/else if/else
let score = 85;

if (score >= 90) {
    console.log("优秀");
} else if (score >= 80) {
    console.log("良好");
} else if (score >= 60) {
    console.log("及格");
} else {
    console.log("不及格");
}
```

#### CMD
```bat
@echo off
set /a "score=85"

if %score% GEQ 90 (
    echo 优秀
) else if %score% GEQ 80 (
    echo 良好
) else if %score% GEQ 60 (
    echo 及格
) else (
    echo 不及格
)
```

**主要区别**：
1. **语法结构**：CMD使用括号，Python使用缩进，JavaScript使用花括号
2. **比较运算符**：CMD使用`GEQ`、`LSS`等，Python/JS使用`>=`、`<`等
3. **变量声明**：CMD需要`set /a`，Python直接赋值，JS使用`let/const`
4. **字符串比较**：CMD使用`==`，Python使用`==`，JS使用`===`

### 文件检查对比

#### Python
```python
import os

if os.path.exists("file.txt"):
    print("文件存在")
else:
    print("文件不存在")
```

#### JavaScript (Node.js)
```javascript
const fs = require('fs');

if (fs.existsSync('file.txt')) {
    console.log('文件存在');
} else {
    console.log('文件不存在');
}
```

#### CMD
```bat
@echo off
if exist "file.txt" (
    echo 文件存在
) else (
    echo 文件不存在
)
```

## 最佳实践和常见陷阱

### 1. 变量为空时的处理

**错误示例**：
```bat
@echo off
set "name="
if %name%==test echo 匹配
```

**问题**：变量为空时，`if %name%==test` 会变成 `if ==test`，导致语法错误。

**正确做法**：
```bat
@echo off
set "name="
if "%name%"=="test" echo 匹配
```

**最佳实践**：
- **始终使用引号包裹变量**：`if "%var%"=="value"`
- **使用defined检查**：`if defined var`
- **设置默认值**：`if not defined var set "var=default"`

### 2. if 语句中的空格敏感性

**问题示例**：
```bat
:: 正确
if "%var%"=="value" echo OK

:: 错误 - 多余的空格
if "%var%" == "value" echo OK

:: 错误 - 缺少空格
if"%var%"=="value" echo OK
```

**规则**：
- `if` 后面必须有空格
- 比较运算符前后不能有多余空格
- `(` 前面要有空格

### 3. 延迟扩展在条件中的影响

**问题场景**：
```bat
@echo off
set "var=old"
(
    set "var=new"
    if "%var%"=="new" echo 延迟扩展问题
)
```

**问题**：括号内的变量在解析时已经展开，不会反映括号内的修改。

**解决方案**：
```bat
@echo off
setlocal EnableDelayedExpansion
set "var=old"
(
    set "var=new"
    if "!var!"=="new" echo 延迟扩展正常工作
)
endlocal
```

### 4. 比较运算符的选择

**建议**：
- 字符串比较：使用 `==`
- 数值比较：使用 `EQU`、`LSS`、`GTR` 等
- 文件检查：使用 `exist`
- 变量检查：使用 `defined`

### 5. 错误处理模式

**推荐模式**：
```bat
@echo off
:: 执行命令并检查结果
somecommand >nul 2>&1
if errorlevel 1 (
    echo 命令执行失败
    exit /b 1
)

:: 或者使用 && ||
somecommand >nul 2>&1 && (
    echo 成功
) || (
    echo 失败
    exit /b 1
)
```

## 练习题

### 练习1：基础判断
编写一个批处理脚本，检查用户输入的数字是否为偶数。

**要求**：
- 使用 `set /p` 获取用户输入
- 使用数值比较运算符
- 输出判断结果

### 练习2：文件类型检查
编写一个脚本，检查指定目录下是否存在特定类型的文件。

**要求**：
- 使用 `if exist` 和通配符
- 检查 `.txt`、`.bat`、`.log` 三种类型
- 统计每种类型的文件数量

### 练习3：多条件判断
编写一个成绩评定脚本，根据分数输出等级。

**等级标准**：
- 90-100：优秀 (A)
- 80-89：良好 (B)
- 70-79：中等 (C)
- 60-69：及格 (D)
- 0-59：不及格 (F)

**要求**：
- 输入验证（0-100范围）
- 使用嵌套 `if ... else if ...`

### 练习4：用户菜单系统
编写一个交互式菜单脚本，提供3个选项。

**菜单选项**：
1. 显示系统信息
2. 显示当前目录内容
3. 退出程序

**要求**：
- 使用 `choice` 命令
- 循环显示菜单直到用户选择退出
- 每个选项都有实际功能

### 练习5：错误处理
编写一个脚本，尝试创建目录并处理可能出现的错误。

**要求**：
- 使用 `mkdir` 命令
- 检查ERRORLEVEL
- 处理目录已存在的情况
- 提供友好的错误信息

## 总结

本章我们学习了CMD中的条件判断和流程控制：

1. **if语句基础**：字符串比较、数值比较、文件检查
2. **比较运算符**：`==` vs `EQU` 的区别
3. **特殊检查**：`defined`、`exist`、`errorlevel`
4. **用户交互**：`choice` 命令
5. **条件组合**：`&&` 和 `||` 的简化写法

**关键要点**：
- 始终使用引号包裹变量
- 理解字符串比较和数值比较的区别
- 合理使用ERRORLEVEL进行错误处理
- 掌握条件组合的简化语法

在下一章中，我们将学习循环结构，让程序能够重复执行任务。

## 下一步

- [第04章：循环与迭代 — 重复的艺术](../ch04-loops/index.md)

## 附加资源

- [CMD条件语句官方文档](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/if)
- [ERRORLEVEL参考](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/errorlevel)
- [CMD运算符参考](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/call)