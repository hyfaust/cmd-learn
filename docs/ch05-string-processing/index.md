# 第05章 字符串处理 — 文本的艺术

## 你将学到什么

完成本章后，你将能够：

- 掌握CMD字符串操作的完整语法
- 实现子串截取、替换、查找等核心操作
- 处理特殊字符和编码问题
- 使用正则表达式进行模式匹配
- 编写健壮的字符串处理脚本

## 前置要求

- 理解变量和基本命令（第01-04章）
- 熟悉`set`命令和环境变量概念
- 了解基本的批处理语法

## 预计时间

- 学习时间：45-60分钟
- 练习时间：30-45分钟

## 最终结果

通过本章学习，你将能够编写出处理用户输入、解析日志文件、格式化输出的实用脚本。

---

## 字符串处理的重要性

在批处理脚本编程中，字符串处理是最核心的技能之一。无论是解析用户输入、处理文件路径、格式化输出，还是分析日志文件，都离不开字符串操作。

CMD提供了强大的字符串操作语法，虽然不如Python或JavaScript那样直观，但掌握后你会发现它非常高效。

!!! note "字符串是文本处理的基石"
    在CMD中，几乎所有的数据都是以字符串形式存在的。掌握字符串处理就是掌握了CMD脚本编程的核心。

---

## 核心概念详解

### 1. 子串截取

子串截取是字符串处理中最基础的操作，CMD使用独特的语法来实现。

#### 基本语法

```bat
%variable:~start,length%
```

- **start**: 起始索引（从0开始）
- **length**: 截取长度（可选，省略则截取到末尾）

#### 正数索引（从左开始）

```bat
@echo off
set "str=Hello, World!"
echo 原始字符串: %str%
echo 前5个字符: %str:~0,5%
echo 从索引7开始: %str:~7%
echo 从索引2到5: %str:~2,3%
```

**输出：**
```
原始字符串: Hello, World!
前5个字符: Hello
从索引7开始: World!
从索引2到5: llo
```

#### 负数索引（从右开始）

```bat
@echo off
set "str=Hello, World!"
echo 最后6个字符: %str:~-6%
echo 最后3个字符: %str:~-3%
echo 倒数第5个字符开始: %str:~-5,2%
```

**输出：**
```
最后6个字符: World!
最后3个字符: ld!
倒数第5个字符开始: rl
```

#### 省略length参数

```bat
@echo off
set "str=Hello, World!"
echo 从索引7到末尾: %str:~7%
echo 从倒数第6个到末尾: %str:~-6%
```

!!! tip "索引记忆技巧"
    正数索引：从左往右数，第一个字符索引为0  
    负数索引：从右往左数，最后一个字符索引为-1

---

### 2. 字符串替换

字符串替换使用`%var:old=new%`语法，这是CMD中最常用的字符串操作之一。

#### 基本替换

```bat
@echo off
set "str=Hello World Hello CMD"
echo 原始字符串: %str%
echo 替换Hello为Hi: %str:Hello=Hi%
```

**输出：**
```
原始字符串: Hello World Hello CMD
替换Hello为Hi: Hi World Hi CMD
```

#### 替换所有匹配

CMD的字符串替换会自动替换所有匹配的子串，不需要循环或正则表达式。

```bat
@echo off
set "str=aaa.bbb.ccc"
echo 替换点为横杠: %str:.=-%
echo 删除所有点: %str:.=%
```

**输出：**
```
替换点为横杠: aaa-bbb-ccc
删除所有点: aaabbbccc
```

#### 删除子串

将替换部分留空即可删除子串：

```bat
@echo off
set "str=Hello World"
echo 删除World: %str: World=%
echo 删除Hello: %str:Hello =%
```

!!! warning "注意空格"
    替换时会精确匹配空格。`%str:Hello=%`不会匹配"Hello "，因为缺少空格。

---

### 3. 字符串长度计算

CMD没有内置的字符串长度函数，需要使用循环技巧来实现。

#### 方法一：使用for循环（精确字符数）

```bat
@echo off
setlocal EnableDelayedExpansion
set "str=Hello World"
set "len=0"
set "tmp=%str%"
:count_loop
if defined tmp (
    set "tmp=%tmp:~1%"
    set /a "len+=1"
    goto :count_loop
)
echo 字符串 "%str%" 的长度是: %len%
endlocal
```

**输出：**
```
字符串 "Hello World" 的长度是: 11
```

#### 方法二：使用for命令（单词数）

```bat
@echo off
set "str=Hello World CMD Batch"
set "count=0"
for %%A in (%str%) do set /a "count+=1"
echo 单词数: %count%
```

**输出：**
```
单词数: 4
```

!!! tip "性能考虑"
    对于很长的字符串，循环计算长度会比较慢。如果需要频繁计算长度，考虑使用临时文件或其他优化方法。

---

### 4. 字符串拼接

CMD中字符串拼接非常简单，直接连接即可。

#### 基本拼接

```bat
@echo off
set "first=Hello"
set "second=World"
set "full=%first% %second%"
echo %full%

:: 使用set命令
set "greeting=Hello"
set "greeting=%greeting%, World!"
echo %greeting%
```

**输出：**
```
Hello World
Hello, World!
```

#### 多行拼接

```bat
@echo off
set "line1=第一行"
set "line2=第二行"
set "line3=第三行"
echo %line1%
echo %line2%
echo %line3%

:: 使用&符号连接
echo %line1% & echo %line2% & echo %line3%
```

---

### 5. 大小写转换

CMD没有直接的大小写转换命令，但可以通过`for /F`和字符串替换实现。

#### 转换为大写

```bat
@echo off
setlocal EnableDelayedExpansion
set "str=hello world"
for %%A in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    set "str=!str:%%A=%%A!"
)
echo 大写: %str%
```

#### 转换为小写

```bat
@echo off
setlocal EnableDelayedExpansion
set "str=HELLO WORLD"
for %%A in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do (
    set "str=!str:%%A=%%A!"
)
echo 小写: %str%
```

!!! warning "中文字符问题"
    大小写转换主要针对英文字母。中文字符没有大小写概念，但需要注意编码问题。

---

### 6. 特殊字符处理

CMD中有许多特殊字符需要转义处理，这是字符串处理中最容易出错的地方。

#### 需要转义的特殊字符

| 字符 | 转义方式 | 说明 |
|------|----------|------|
| `%` | `%%` | 百分号需要双写 |
| `!` | `^!`（延迟扩展下） | 感叹号需要转义 |
| `&` | `^&` | 命令连接符 |
| `|` | `^|` | 管道符 |
| `<` | `^<` | 输入重定向 |
| `>` | `^>` | 输出重定向 |
| `(` | `^(` | 左括号 |
| `)` | `^)` | 右括号 |
| `^` | `^^` | 脱字符本身 |

#### 示例代码

```bat
@echo off
setlocal EnableDelayedExpansion

echo === 特殊字符转义演示 ===
echo 使用 ^ 转义特殊字符:
echo ^& 表示 AND
echo ^| 表示 OR
echo ^< 表示输入
echo ^> 表示输出
echo.

echo 百分号: 100%%
echo 双引号: "quoted text"

:: 延迟扩展下的感叹号
set "var=test"
echo 感叹号（延迟扩展下）: !var!
echo 感叹号转义: ^!

endlocal
```

!!! warning "延迟扩展的影响"
    当启用延迟扩展（`setlocal EnableDelayedExpansion`）时，`!`会被解析为变量引用。如果需要显示字面量感叹号，必须使用`^!`转义。

---

### 7. 字符串查找

CMD提供了`find`和`findstr`两个命令用于字符串查找。

#### find命令

```bat
@echo off
echo === find命令演示 ===
echo Hello World | find "World"
echo.
echo Hello World | find "xyz"
if errorlevel 1 echo 未找到
```

**输出：**
```
=== find命令演示 ===
Hello World

未找到
```

#### findstr命令

```bat
@echo off
echo === findstr命令演示 ===
echo apple banana cherry | findstr "apple"
echo.

:: 忽略大小写
echo Hello World | findstr /I "hello"
echo.

:: 显示行号
echo line1
echo line2
echo line3 | findstr /N "line"
```

#### 从文件查找

```bat
@echo off
echo === 从文件查找 ===
:: 查找包含echo的行
findstr /I /N "echo" "%~dp0..\ch01\hello.bat" 2>nul
echo.

:: 查找多个模式
echo apple banana cherry | findstr "apple cherry"
```

---

### 8. 正则表达式

`findstr`支持有限的正则表达式功能。

#### 基本正则语法

```bat
@echo off
echo === 正则表达式演示 ===

:: 数字匹配
echo abc123def | findstr /R "[0-9]"
echo.

:: 字母匹配
echo 123abc456 | findstr /R "[a-z]"
echo.

:: 以特定字符开头
echo hello world | findstr /R "^hello"
echo.

:: 以特定字符结尾
echo hello world | findstr /R "world$"
```

#### 常用正则模式

| 模式 | 说明 | 示例 |
|------|------|------|
| `[0-9]` | 数字 | 匹配任何数字 |
| `[a-z]` | 小写字母 | 匹配任何小写字母 |
| `[A-Z]` | 大写字母 | 匹配任何大写字母 |
| `[a-zA-Z]` | 所有字母 | 匹配任何字母 |
| `^` | 行开头 | 匹配行首 |
| `$` | 行结尾 | 匹配行尾 |
| `.` | 任意字符 | 匹配单个字符 |

!!! note "findstr正则限制"
    findstr的正则功能有限，不支持量词（如`+`、`*`、`?`）、分组等高级特性。复杂正则表达式需要使用其他工具。

---

### 9. 字符串修剪

去除字符串首尾空格是常见需求，CMD有专门的技巧。

#### 使用for /F

```bat
@echo off
setlocal EnableDelayedExpansion
set "str=   Hello World   "
echo 原始: [%str%]

:: 去除首尾空格
for /f "tokens=*" %%a in ("%str%") do set "trimmed=%%a"
echo 修剪后: [%trimmed%]
endlocal
```

**输出：**
```
原始: [   Hello World   ]
修剪后: [Hello World]
```

#### 去除前导空格

```bat
@echo off
setlocal EnableDelayedExpansion
set "str=   Hello World"
echo 原始: [%str%]

:: 使用循环去除前导空格
:trim_loop
if "!str:~0,1!"==" " (
    set "str=!str:~1!"
    goto :trim_loop
)
echo 修剪后: [%str%]
endlocal
```

#### 去除尾随空格

```bat
@echo off
setlocal EnableDelayedExpansion
set "str=Hello World   "
echo 原始: [%str%]

:: 使用循环去除尾随空格
:trim_tail_loop
if "!str:~-1!"==" " (
    set "str=!str:~0,-1!"
    goto :trim_tail_loop
)
echo 修剪后: [%str%]
endlocal
```

---

## 数据结构概念

### CMD字符串的本质

CMD中的字符串本质上是字节数组，具有以下特点：

1. **无Unicode支持**：CMD主要支持ANSI编码（在中文Windows上是GBK编码）
2. **字节级操作**：子串截取是基于字节的，不是基于字符的
3. **长度限制**：单个环境变量最大长度约8192字符

```bat
@echo off
:: 中文字符演示
set "str=你好世界"
echo 原始: %str%
echo 前2个字符: %str:~0,2%
echo.

:: 注意：中文字符在GBK编码中占2个字节
echo 前2个字节: %str:~0,2%  （可能是乱码）
echo 前1个字符: %str:~0,1%  （显示不完整）
```

### 空字符串和未定义变量

CMD中，空字符串和未定义变量有重要区别：

```bat
@echo off
:: 空字符串 - 变量已定义但值为空
set "empty="
echo 空字符串: [%empty%]

:: 未定义变量 - 变量不存在
echo 未定义变量: [%undefined_var%]

:: 检查变量是否定义
if defined empty (
    echo empty变量已定义
) else (
    echo empty变量未定义
)

if defined undefined_var (
    echo undefined_var变量已定义
) else (
    echo undefined_var变量未定义
)
```

**输出：**
```
空字符串: []
未定义变量: []
empty变量已定义
undefined_var变量未定义
```

!!! warning "变量为空时的陷阱"
    当变量为空时，字符串操作可能导致语法错误：
    ```bat
    set "str="
    echo %str:~0,5%  :: 这会报错，因为str为空
    ```
    解决方案：使用延迟扩展或先检查变量是否为空。

### 字符串操作的性能考虑

1. **循环操作**：对于很长的字符串，循环计算长度会比较慢
2. **多次替换**：每次替换都会创建新字符串，避免不必要的替换
3. **延迟扩展**：使用延迟扩展会影响性能，只在必要时启用

---

## 与其他语言的对比

### 字符串操作API对比表

| 功能 | CMD | Python | JavaScript | C | Lua |
|------|-----|--------|------------|---|-----|
| **子串截取** | `%var:~start,length%` | `var[start:end]` | `var.substring(start, end)` | `strncpy()` | `string.sub(s, i, j)` |
| **字符串长度** | 循环计算 | `len(var)` | `var.length` | `strlen()` | `string.len(s)` |
| **字符串替换** | `%var:old=new%` | `var.replace(old, new)` | `var.replace(old, new)` | 自定义函数 | `string.gsub(s, p, r)` |
| **查找子串** | `findstr` | `var.find(sub)` | `var.indexOf(sub)` | `strstr()` | `string.find(s, p)` |
| **大小写转换** | 循环替换 | `var.upper()/lower()` | `var.toUpperCase()` | `toupper()` | `string.upper(s)` |
| **去除空格** | `for /F`技巧 | `var.strip()` | `var.trim()` | 自定义函数 | 自定义函数 |
| **分割字符串** | `for /F "tokens="` | `var.split(sep)` | `var.split(sep)` | `strtok()` | 自定义函数 |
| **连接字符串** | 直接拼接 | `sep.join(list)` | `array.join(sep)` | `strcat()` | `..` 操作符 |

### 关键差异分析

#### 1. 语法复杂度

```bat
@echo off
:: CMD - 需要特殊语法
set "str=Hello World"
echo %str:~0,5%

# Python - 直观易懂
str = "Hello World"
print(str[0:5])

// JavaScript - 类似Python
let str = "Hello World";
console.log(str.substring(0, 5));
```

#### 2. 错误处理

```bat
@echo off
:: CMD - 变量为空时可能出错
set "str="
:: echo %str:~0,5%  :: 这会报错

# Python - 更好的错误处理
str = ""
print(str[0:5])  # 正常返回空字符串
```

#### 3. Unicode支持

```bat
@echo off
:: CMD - 有限的Unicode支持
set "str=你好世界"
echo %str:~0,2%  :: 可能显示乱码

# Python - 完整的Unicode支持
str = "你好世界"
print(str[0:2])  # 正确显示"你好"

// JavaScript - 原生Unicode支持
let str = "你好世界";
console.log(str.substring(0, 2));  // 正确显示"你好"
```

---

## 最佳实践和常见陷阱

### 1. 变量为空时的安全检查

```bat
@echo off
setlocal EnableDelayedExpansion

set "str="

:: 错误的做法 - 可能出错
:: echo %str:~0,5%

:: 正确的做法 - 先检查变量
if defined str (
    if not "!str!"=="" (
        echo 字符串: %str%
        echo 前5个字符: %str:~0,5%
    ) else (
        echo 变量为空字符串
    )
) else (
    echo 变量未定义
)

endlocal
```

### 2. 特殊字符的安全处理

```bat
@echo off
setlocal EnableDelayedExpansion

:: 包含特殊字符的字符串
set "str=Hello & World | Test < Input > Output"

:: 错误的做法 - 特殊字符会被解析
:: echo %str%

:: 正确的做法 - 使用延迟扩展
echo %str%

:: 或者使用引号
echo "%str%"

endlocal
```

### 3. 中文字符的编码处理

```bat
@echo off
:: 设置代码页为UTF-8（如果需要）
:: chcp 65001

:: 中文字符串操作
set "str=你好世界，欢迎学习CMD"
echo 原始字符串: %str%
echo 前4个字符: %str:~0,4%

:: 注意：在GBK编码中，中文字符占2个字节
:: 所以索引可能需要调整
echo 前2个中文字符: %str:~0,4%

:: 使用for循环处理中文字符
for /f "delims=" %%a in ("%str%") do (
    echo 处理中文: %%a
)
```

!!! warning "编码陷阱"
    在中文Windows系统上，CMD默认使用GBK编码。如果文件保存为UTF-8编码，可能会出现乱码。建议：
    1. 使用`chcp 65001`切换到UTF-8代码页
    2. 或者确保文件使用GBK编码保存

### 4. 延迟扩展的影响

```bat
@echo off
setlocal EnableDelayedExpansion

set "var=Hello"
set "str=This is !var!"

:: 启用延迟扩展后，!var!会被解析
echo 延迟扩展: %str%

:: 如果需要显示字面量感叹号
set "str2=This is !important!"
echo 感叹号转义: !str2!

:: 或者禁用延迟扩展
setlocal DisableDelayedExpansion
set "str3=This is !important!"
echo 无延迟扩展: %str3%

endlocal
```

---

## 练习题

### 练习1：基础字符串操作

编写一个脚本，实现以下功能：
1. 接收用户输入的字符串
2. 显示字符串长度
3. 显示前3个字符和后3个字符
4. 将字符串中的空格替换为下划线

```bat
@echo off
setlocal EnableDelayedExpansion

:: 在此编写你的代码
set /p "input=请输入字符串: "

:: TODO: 实现字符串处理功能
echo 原始字符串: %input%
:: 1. 计算字符串长度
:: 2. 显示前3个字符
:: 3. 显示后3个字符
:: 4. 替换空格为下划线

endlocal
```

### 练习2：日志分析器

编写一个脚本，分析简单的日志文件格式：
1. 假设日志格式为：`[日期] [时间] [级别] 消息`
2. 提取日期、时间、级别和消息
3. 统计不同级别的日志数量

```bat
@echo off
setlocal EnableDelayedExpansion

:: 模拟日志数据
set "log1=[2024-01-15] [10:30:45] [INFO] 系统启动"
set "log2=[2024-01-15] [10:31:20] [ERROR] 文件未找到"
set "log3=[2024-01-15] [10:32:00] [INFO] 处理完成"

:: TODO: 实现日志分析
echo 分析日志...
:: 1. 提取每条日志的各个字段
:: 2. 统计INFO、ERROR、WARNING等的数量
:: 3. 显示统计结果

endlocal
```

### 练习3：字符串格式化器

编写一个脚本，将字符串格式化为表格形式：
1. 接收多行输入
2. 对齐每行的内容
3. 添加边框和标题

```bat
@echo off
setlocal EnableDelayedExpansion

:: 模拟数据
set "data1=姓名:张三"
set "data2=年龄:25"
set "data3=城市:北京"

:: TODO: 实现表格格式化
echo +--------+--------+
echo ^| 字段   ^| 值     ^|
echo +--------+--------+
:: 1. 解析每行数据
:: 2. 计算字段宽度
:: 3. 生成对齐的表格
echo +--------+--------+

endlocal
```

### 练习4：密码强度检查器

编写一个脚本，检查密码强度：
1. 接收密码输入
2. 检查长度（至少8个字符）
3. 检查是否包含数字
4. 检查是否包含特殊字符
5. 显示密码强度等级

```bat
@echo off
setlocal EnableDelayedExpansion

set /p "password=请输入密码: "

:: TODO: 实现密码强度检查
echo 检查密码强度...
:: 1. 检查长度
:: 2. 检查是否包含数字（使用findstr）
:: 3. 检查是否包含特殊字符
:: 4. 计算强度分数
:: 5. 显示结果

endlocal
```

### 练习5：文件路径处理

编写一个脚本，处理文件路径：
1. 接收文件路径输入
2. 提取文件名、扩展名、目录名
3. 将反斜杠转换为正斜杠
4. 检查路径是否为绝对路径

```bat
@echo off
setlocal EnableDelayedExpansion

set /p "filepath=请输入文件路径: "

:: TODO: 实现路径处理
echo 处理路径: %filepath%
:: 1. 提取文件名（使用%~nx1）
:: 2. 提取扩展名（使用%~x1）
:: 3. 提取目录名（使用%~dp1）
:: 4. 路径格式转换
:: 5. 检查是否为绝对路径

endlocal
```

---

## 总结

### 核心知识点回顾

1. **子串截取**：`%var:~start,length%` 是CMD字符串操作的基础
2. **字符串替换**：`%var:old=new%` 可以替换所有匹配的子串
3. **长度计算**：需要使用循环技巧，没有内置函数
4. **特殊字符**：必须使用`^`转义，延迟扩展下`!`也需要转义
5. **编码问题**：CMD主要支持ANSI编码，中文字符处理需要特别注意

### 下一步学习

掌握了字符串处理后，你可以继续学习：

1. **文件I/O操作**（第06章）：将字符串处理应用于文件操作
2. **函数编写**（第07章）：创建可重用的字符串处理函数
3. **数据结构**（第08章）：使用字符串构建复杂数据结构

### 额外资源

- **CMD字符串操作参考**：Microsoft官方文档
- **findstr命令详解**：`findstr /?` 查看帮助
- **编码处理**：研究`chcp`命令和代码页概念

---

## 附录：示例代码

本章所有示例代码都可以在 `examples/ch05/` 目录中找到：

1. `substring.bat` - 子串截取演示
2. `replace.bat` - 字符串替换演示
3. `length.bat` - 字符串长度计算
4. `special_chars.bat` - 特殊字符处理
5. `findstr_demo.bat` - findstr查找演示
6. `trim.bat` - 字符串修剪演示

**对比语言代码：**
- `comparison.py` - Python字符串操作对比
- `comparison.js` - JavaScript字符串操作对比
- `comparison.c` - C语言字符串操作对比
- `comparison.lua` - Lua字符串操作对比

运行这些示例代码可以帮助你更好地理解CMD字符串处理的各个方面。

---

!!! tip "实践建议"
    学习字符串处理最好的方法是动手实践。尝试修改示例代码，观察不同操作的效果。当遇到问题时，参考本章的最佳实践和常见陷阱部分。