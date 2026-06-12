# 第02章 文件与目录管理 — 操作文件系统

## 概述

文件系统操作是CMD/BAT脚本中最常用的场景之一。无论是批量重命名文件、整理目录结构，还是自动化备份任务，都离不开对文件和目录的熟练操作。本章将系统讲解CMD中用于文件系统操作的核心命令，帮助你掌握高效管理文件系统的技能。

## 学习目标

完成本章学习后，你将能够：

- 使用`mkdir`、`rmdir`、`cd`等命令管理目录结构
- 使用`copy`、`move`、`ren`、`del`等命令操作文件
- 使用`type`、`more`、`tree`等命令查看文件内容和目录结构
- 使用`attrib`命令管理文件属性
- 熟练运用通配符`*`和`?`进行批量操作
- 理解绝对路径与相对路径的区别，掌握`%~dp0`的妙用
- 使用`for`循环和`dir`命令遍历目录

## 预计学习时间

- 阅读本章内容：30分钟
- 完成所有示例和练习：45分钟

## 核心概念详解

### 目录操作

目录（文件夹）是文件系统的基本组织单元。CMD提供了强大的目录管理命令。

#### 创建目录：`mkdir` / `md`

`mkdir`（或简写`md`）用于创建新目录。

```bat
:: 创建单个目录
mkdir mydir

:: 创建多级目录（一次性创建完整路径）
mkdir path\to\deep\dir

:: 使用变量创建目录
set "DIR_NAME=my_folder"
mkdir "%DIR_NAME%"
```

**参数说明：**

| 参数 | 说明 |
|------|------|
| 无参数 | 创建指定目录 |
| 路径 | 创建指定路径的目录 |
| `2>nul` | 抑制"目录已存在"错误 |

#### 删除目录：`rmdir` / `rd`

`rmdir`（或简写`rd`）用于删除目录。

```bat
:: 删除空目录
rmdir mydir

:: 删除目录及其所有内容（危险操作！）
rmdir /s /q mydir

:: 使用简写形式
rd /s /q mydir
```

**参数说明：**

| 参数 | 说明 |
|------|------|
| `/s` | 删除目录树（包括所有子目录和文件） |
| `/q` | 安静模式，不询问确认 |
| 无参数 | 仅删除空目录 |

!!! warning "危险操作"
    `rmdir /s /q` 会**永久删除**指定目录及其所有内容，且不会询问确认。请务必谨慎使用，建议先用`dir`命令确认目录内容。

#### 切换目录：`cd` / `chdir`

`cd`（或完整形式`chdir`）用于切换当前工作目录。

```bat
:: 切换到指定目录
cd C:\Users

:: 切换到上级目录
cd ..

:: 切换到根目录
cd \

:: 切换到用户主目录
cd /d %USERPROFILE%

:: 显示当前目录
cd
```

**重要特性：**

- `cd` 只能在同一驱动器内切换目录
- 使用 `/d` 参数可以同时切换驱动器和目录
- 不带参数的 `cd` 命令会显示当前目录路径

#### 目录栈：`pushd` / `popd`

`pushd`和`popd`提供了目录栈功能，允许你临时切换目录后再返回。

```bat
:: 保存当前目录并切换到新目录
pushd C:\Windows\System32

:: 执行一些操作...
dir *.dll

:: 返回之前保存的目录
popd
```

**使用场景：**

- 需要在多个目录间频繁切换时
- 脚本中需要临时进入某个目录执行操作后返回
- 替代复杂的`cd`命令组合

### 文件操作

#### 复制文件：`copy`

`copy`命令用于复制文件。

```bat
:: 复制单个文件
copy source.txt destination.txt

:: 复制到另一个目录
copy source.txt C:\backup\

:: 复制并覆盖（默认会询问）
copy /Y source.txt destination.txt

:: 合并多个文件
copy file1.txt + file2.txt combined.txt

:: 复制所有文本文件
copy *.txt C:\backup\
```

**常用参数：**

| 参数 | 说明 |
|------|------|
| `/Y` | 覆盖时不提示确认 |
| `/-Y` | 覆盖时提示确认 |
| `/V` | 验证复制的文件是否正确 |
| `/A` | 表示ASCII文本文件 |
| `/B` | 表示二进制文件 |

#### 移动文件：`move`

`move`命令用于移动文件（也可用于重命名）。

```bat
:: 移动文件到另一个目录
move file.txt C:\backup\

:: 移动并重命名
move old.txt new_location\new.txt

:: 移动多个文件
move *.txt C:\backup\

:: 覆盖目标文件
move /Y source.txt destination.txt
```

#### 重命名文件：`ren` / `rename`

`ren`（或完整形式`rename`）用于重命名文件或目录。

```bat
:: 重命名文件
ren old.txt new.txt

:: 重命名目录
ren old_folder new_folder

:: 使用通配符批量重命名
ren *.txt *.bak

:: 添加前缀
ren file.txt prefix_file.txt
```

!!! tip "批量重命名技巧"
    `ren`命令支持通配符，可以实现简单的批量重命名。但对于复杂的重命名需求，建议使用`for`循环或PowerShell。

#### 删除文件：`del` / `erase`

`del`（或`erase`）用于删除文件。

```bat
:: 删除单个文件
del file.txt

:: 删除多个文件
del *.txt

:: 安静删除（不询问）
del /Q *.txt

:: 删除只读文件
del /F readonly.txt

:: 删除所有文件（不包括子目录）
del /Q *.*
```

**参数说明：**

| 参数 | 说明 |
|------|------|
| `/P` | 删除每个文件前提示确认 |
| `/Q` | 安静模式，不询问 |
| `/F` | 强制删除只读文件 |
| `/S` | 删除指定目录及所有子目录中的文件 |
| `/A` | 根据属性选择要删除的文件 |

!!! warning "删除操作不可逆"
    `del`命令删除的文件不会进入回收站，而是直接永久删除。请谨慎使用，尤其是配合通配符时。

### 文件查看

#### 显示文件内容：`type`

`type`命令用于显示文本文件的内容。

```bat
:: 显示文件内容
type file.txt

:: 显示多个文件内容
type file1.txt file2.txt

:: 与more命令结合使用（分页显示）
type large_file.txt | more
```

#### 分页显示：`more`

`more`命令用于分页显示文本内容，适合查看大文件。

```bat
:: 分页显示文件内容
more file.txt

:: 从管道接收输入
dir | more

:: 显示文件内容并显示行号
more /c file.txt
```

**交互按键：**

| 按键 | 功能 |
|------|------|
| `Space` | 显示下一页 |
| `Enter` | 显示下一行 |
| `Q` | 退出 |
| `F` | 显示下一文件 |
| `=` | 显示行号 |

#### 显示目录树：`tree`

`tree`命令以树状结构显示目录。

```bat
:: 显示目录结构
tree

:: 显示目录和文件
tree /F

:: 显示ASCII字符的树
tree /A

:: 指定显示深度
tree /F /L 2
```

**参数说明：**

| 参数 | 说明 |
|------|------|
| `/F` | 显示每个目录中的文件名 |
| `/A` | 使用ASCII字符而不是扩展字符 |
| `/L` | 指定显示的最大深度级别 |

### 文件属性

`attrib`命令用于显示或修改文件属性。

#### 文件属性位

在FAT/NTFS文件系统中，每个文件都有属性位：

| 属性 | 标志 | 说明 |
|------|------|------|
| 只读 | `R` | 文件只能读取，不能修改 |
| 隐藏 | `H` | 文件在默认目录列表中不显示 |
| 系统 | `S` | 操作系统文件 |
| 归档 | `A` | 文件自上次备份后被修改过 |

#### 使用attrib命令

```bat
:: 显示文件属性
attrib file.txt

:: 显示所有文件属性
attrib *.*

:: 设置只读属性
attrib +R file.txt

:: 移除只读属性
attrib -R file.txt

:: 设置多个属性
attrib +R +H file.txt

:: 显示隐藏文件
dir /a:h

:: 显示系统文件
dir /a:s
```

**属性操作符：**

| 操作符 | 说明 |
|--------|------|
| `+` | 设置属性 |
| `-` | 移除属性 |
| 无操作符 | 显示属性 |

### 通配符

CMD支持两个通配符：`*`和`?`。

#### 星号通配符 `*`

`*`匹配任意数量的字符（包括零个字符）。

```bat
:: 匹配所有.txt文件
dir *.txt

:: 匹配以"report"开头的文件
dir report*

:: 匹配所有文件
dir *.*

:: 匹配所有文件（不带扩展名）
dir *.
```

#### 问号通配符 `?`

`?`匹配单个字符。

```bat
:: 匹配单个字符
dir ?.txt

:: 匹配恰好3个字符的文件名
dir ???.txt

:: 匹配类似file1.txt, file2.txt等
dir file?.txt

:: 匹配类似data01.txt, data02.txt等
dir data??.txt
```

#### 通配符组合使用

```bat
:: 匹配所有.jpg和.png文件
dir *.jpg *.png

:: 匹配以a开头、以.txt结尾的文件
dir a*.txt

:: 匹配文件名恰好3个字符、任意扩展名的文件
dir ???.*
```

!!! tip "通配符限制"
    CMD的通配符功能相对简单，不支持正则表达式。对于复杂的模式匹配，建议使用`for`命令配合`findstr`或转向PowerShell。

### 路径类型

#### 绝对路径

绝对路径从驱动器根目录开始，完整描述文件位置。

```bat
:: 绝对路径示例
C:\Users\John\Documents\file.txt
D:\Backup\2024\
\\Server\Share\file.txt
```

**特点：**
- 以驱动器字母（如`C:`）或UNC路径（`\\`）开头
- 位置固定，不受当前目录影响
- 长度较长，但更可靠

#### 相对路径

相对路径基于当前工作目录描述文件位置。

```bat
:: 相对路径示例
file.txt           :: 当前目录下的文件
.\file.txt         :: 同上，显式指定当前目录
..\file.txt        :: 上级目录下的文件
subfolder\file.txt :: 子目录下的文件
```

**特点：**
- 不以驱动器字母或`\\`开头
- 位置相对于当前工作目录
- 更短，但依赖于当前目录上下文

#### `%~dp0` 的妙用

`%~dp0`是一个特殊变量，表示批处理文件所在的驱动器和路径。

```bat
@echo off
:: 显示批处理文件所在目录
echo 脚本位置: %~dp0

:: 使用脚本目录作为基准路径
set "SCRIPT_DIR=%~dp0"
set "CONFIG_FILE=%SCRIPT_DIR%config.ini"
set "LOG_DIR=%SCRIPT_DIR%logs"

:: 创建相对于脚本目录的目录
mkdir "%LOG_DIR%" 2>nul

:: 复制文件到脚本目录
copy "%CONFIG_FILE%" "%SCRIPT_DIR%backup\"
```

**为什么使用`%~dp0`？**

- **可靠性**：不依赖于用户从哪里运行脚本
- **可移植性**：脚本可以在任何位置工作
- **安全性**：确保操作的是脚本目录内的文件

**`%~dp0` 与其他变量的区别：**

| 变量 | 含义 | 示例 |
|------|------|------|
| `%~dp0` | 脚本文件所在驱动器和路径 | `C:\scripts\` |
| `%cd%` | 当前工作目录 | `C:\Users\John\` |
| `%~f0` | 脚本文件的完整路径 | `C:\scripts\my.bat` |
| `%~n0` | 脚本文件名（不含扩展名） | `my` |
| `%~x0` | 脚本文件扩展名 | `.bat` |

!!! tip "最佳实践"
    在编写可移植的批处理脚本时，强烈建议使用`%~dp0`作为路径基准，而不是依赖`%cd%`。这样可以确保脚本无论从哪个目录运行都能正确工作。

### 目录遍历

#### 使用 `for /R` 递归遍历

`for /R`命令递归遍历目录树。

```bat
:: 递归遍历所有.txt文件
for /R "%~dp0" %%f in (*.txt) do (
    echo %%f
)

:: 递归遍历所有文件
for /R "C:\data" %%f in (*.*) do (
    echo 处理: %%f
)

:: 递归遍历特定类型的文件
for /R "%~dp0" %%f in (*.jpg, *.png, *.gif) do (
    echo 图片: %%f
)
```

#### 使用 `for /D` 遍历目录

`for /D`命令遍历匹配的目录。

```bat
:: 遍历当前目录下的所有子目录
for /D %%d in (*) do (
    echo 目录: %%d
)

:: 遍历特定模式的目录
for /D %%d in (project_*) do (
    echo 项目: %%d
)

:: 遍历多级目录
for /D %%d in (C:\Users\*) do (
    echo 用户: %%d
    for /D %%s in ("%%d\Documents\*") do (
        echo   文档: %%s
    )
)
```

#### 使用 `dir /S /B` 递归列出

`dir /S /B`命令递归列出所有文件和目录。

```bat
:: 递归列出所有文件（简洁格式）
dir /S /B

:: 递归列出所有.txt文件
dir /S /B *.txt

:: 递归列出所有目录
dir /S /B /AD

:: 递归列出所有文件（包含大小信息）
dir /S *.txt

:: 将结果保存到文件
dir /S /B *.log > filelist.txt
```

**参数说明：**

| 参数 | 说明 |
|------|------|
| `/S` | 递归处理子目录 |
| `/B` | 使用简洁格式（只显示路径） |
| `/AD` | 只显示目录 |
| `/A-D` | 只显示文件（不显示目录） |

#### 遍历技巧组合

```bat
:: 使用for循环处理dir命令的输出
for /f "delims=" %%f in ('dir /S /B *.txt') do (
    echo 处理文件: %%f
    type "%%f"
)

:: 使用for循环过滤特定文件
for /f "delims=" %%f in ('dir /S /B *.log ^| findstr /i "error"') do (
    echo 错误日志: %%f
)

:: 遍历并统计文件数量
set count=0
for /f "delims=" %%f in ('dir /S /B *.txt') do (
    set /a count+=1
)
echo 总文件数: %count%
```

## 数据结构概念

### 文件系统树形结构

文件系统采用树形结构组织数据，从根目录开始分支。

```
C:\ (根目录)
├── Users\
│   ├── John\
│   │   ├── Documents\
│   │   │   ├── report.txt
│   │   │   └── data.csv
│   │   └── Pictures\
│   │       ├── photo.jpg
│   │       └── screenshot.png
│   └── Public\
│       └── Music\
└── Windows\
    ├── System32\
    │   ├── cmd.exe
    │   └── notepad.exe
    └── Temp\
```

**关键概念：**

- **节点**：每个文件或目录都是一个节点
- **路径**：从根到节点的路径是唯一的
- **父节点**：每个节点（除根）都有一个父目录
- **叶子节点**：文件节点，没有子节点
- **分支节点**：目录节点，可以有子节点

### 文件句柄概念

在CMD中，文件操作相对有限，但仍涉及文件句柄：

```bat
:: 标准文件句柄
:: 0 = stdin (标准输入)
:: 1 = stdout (标准输出)
:: 2 = stderr (标准错误)

:: 重定向示例
echo output > file.txt      :: 重定向stdout
command 2> error.log         :: 重定向stderr
command > all.log 2>&1       :: 合并stdout和stderr

:: 使用文件句柄
echo test > file.txt
type file.txt
```

**CMD文件操作的限制：**

- 没有真正的文件指针操作
- 不能随机访问文件内容
- 文件读写是整块操作
- 没有二进制模式支持（需要外部工具）

### FAT/NTFS文件属性位

Windows文件系统使用属性位控制文件行为：

| 属性位 | 位置 | 说明 | 典型用途 |
|--------|------|------|----------|
| 只读 (R) | bit 0 | 禁止修改文件 | 保护重要配置文件 |
| 隐藏 (H) | bit 1 | 文件不显示在默认列表 | 隐藏系统文件 |
| 系统 (S) | bit 2 | 操作系统文件 | 系统关键文件 |
| 归档 (A) | bit 3 | 文件自备份后被修改 | 备份软件判断 |

**属性操作示例：**

```bat
:: 查看文件属性
attrib file.txt
:: 输出: A    R    C:\path\file.txt

:: 设置只读属性
attrib +R file.txt

:: 设置隐藏属性
attrib +H file.txt

:: 同时设置多个属性
attrib +R +H +S file.txt

:: 移除所有属性
attrib -R -H -S file.txt
```

## 与其他语言的对比

### Python对比

Python通过`os`和`shutil`模块提供文件系统操作。

| 操作 | CMD | Python |
|------|-----|--------|
| 创建目录 | `mkdir dir` | `os.makedirs('dir')` |
| 删除目录 | `rmdir /s /q dir` | `shutil.rmtree('dir')` |
| 复制文件 | `copy src dst` | `shutil.copy2('src', 'dst')` |
| 移动文件 | `move src dst` | `shutil.move('src', 'dst')` |
| 删除文件 | `del file` | `os.remove('file')` |
| 遍历目录 | `for /R ...` | `os.walk('.')` |
| 文件属性 | `attrib file` | `os.stat('file')` |
| 路径操作 | `%~dp0` | `os.path.dirname(__file__)` |

**Python优势：**
- 更丰富的路径操作（`pathlib`模块）
- 异常处理机制
- 跨平台支持
- 更强大的文件操作API

### JavaScript (Node.js) 对比

Node.js通过`fs`模块提供文件系统操作。

| 操作 | CMD | Node.js |
|------|-----|---------|
| 创建目录 | `mkdir dir` | `fs.mkdirSync('dir', {recursive: true})` |
| 删除目录 | `rmdir /s /q dir` | `fs.rmSync('dir', {recursive: true})` |
| 复制文件 | `copy src dst` | `fs.copyFileSync('src', 'dst')` |
| 移动文件 | `move src dst` | `fs.renameSync('src', 'dst')` |
| 删除文件 | `del file` | `fs.unlinkSync('file')` |
| 遍历目录 | `for /R ...` | `fs.readdirSync('.')` |
| 读取文件 | `type file` | `fs.readFileSync('file', 'utf8')` |

**Node.js优势：**
- 异步I/O操作
- 流式处理大文件
- 更好的错误处理
- 丰富的第三方库（如`glob`、`fs-extra`）

### C语言对比

C语言通过`stdio.h`、`direct.h`和`io.h`提供文件操作。

| 操作 | CMD | C语言 |
|------|-----|-------|
| 创建目录 | `mkdir dir` | `_mkdir("dir")` |
| 删除目录 | `rmdir dir` | `_rmdir("dir")` |
| 复制文件 | `copy src dst` | 需要手动实现 |
| 删除文件 | `del file` | `remove("file")` |
| 重命名 | `ren old new` | `rename("old", "new")` |
| 文件属性 | `attrib file` | `_chmod("file", mode)` |

**C语言特点：**
- 底层控制
- 跨平台需要条件编译
- 手动内存管理
- 性能最优

### Lua (LuaJIT) 对比

Lua通过`lfs`（LuaFileSystem）模块或FFI提供文件操作。

| 操作 | CMD | Lua (lfs) |
|------|-----|-----------|
| 创建目录 | `mkdir dir` | `lfs.mkdir("dir")` |
| 删除目录 | `rmdir dir` | `lfs.rmdir("dir")` |
| 删除文件 | `del file` | `os.remove("file")` |
| 遍历目录 | `for /R ...` | `lfs.dir(".")` |
| 文件属性 | `attrib file` | `lfs.attributes("file")` |
| 改变目录 | `cd dir` | `lfs.chdir("dir")` |

**Lua特点：**
- 轻量级脚本语言
- 嵌入式使用场景
- FFI可调用C函数
- 简洁的语法

## 最佳实践

### 路径含空格时的处理

Windows路径经常包含空格，必须使用引号包裹。

```bat
:: ❌ 错误：路径含空格会导致解析错误
copy C:\My Documents\file.txt C:\Backup Folder\

:: ✅ 正确：使用引号包裹路径
copy "C:\My Documents\file.txt" "C:\Backup Folder\"

:: ❌ 错误：变量展开后路径可能含空格
set DIR=C:\My Folder
copy file.txt %DIR%

:: ✅ 正确：变量使用时也要加引号
set "DIR=C:\My Folder"
copy file.txt "%DIR%"
```

**最佳实践：**

- **始终**用双引号包裹路径，即使路径不含空格
- 使用`set "VAR=value"`语法设置变量（引号在等号两边）
- 在`for`循环中使用`"delims="`保留完整路径

### 中文路径编码问题

CMD默认使用ANSI编码（中文Windows是GBK），可能与UTF-8冲突。

```bat
:: 问题：UTF-8编码的文件名在CMD中显示为乱码
:: 解决方案1：使用chcp切换代码页
chcp 65001
dir

:: 解决方案2：使用短文件名（8.3格式）
dir /X

:: 解决方案3：使用PowerShell（更好的Unicode支持）
powershell -Command "Get-ChildItem"
```

**建议：**
- 尽量避免在路径中使用中文（尤其是脚本文件）
- 如果必须使用中文路径，确保文件编码与系统代码页一致
- 考虑使用短文件名（8.3格式）作为替代

### 相对路径的基准

理解相对路径的基准非常重要。

```bat
:: 场景：用户从C:\Users\John运行脚本C:\Scripts\my.bat

@echo off
:: %cd% = C:\Users\John（用户运行脚本的目录）
echo 当前目录: %cd%

:: %~dp0 = C:\Scripts\（脚本所在目录）
echo 脚本目录: %~dp0

:: ❌ 错误：使用%cd%作为基准
copy config.txt backup\      :: 会复制C:\Users\John\config.txt

:: ✅ 正确：使用%~dp0作为基准
copy "%~dp0config.txt" "%~dp0backup\"
```

**最佳实践：**

- 始终使用`%~dp0`作为脚本内路径的基准
- 使用`pushd "%~dp0"`确保当前目录是脚本目录
- 文档中明确说明脚本的运行方式

### 安全操作习惯

```bat
@echo off
setlocal enabledelayedexpansion

:: 1. 使用变量管理路径
set "BASE_DIR=%~dp0sandbox"
set "BACKUP_DIR=%~dp0backup"

:: 2. 创建目录前检查是否存在
if not exist "%BASE_DIR%" (
    mkdir "%BASE_DIR%"
    echo 创建目录: %BASE_DIR%
)

:: 3. 删除前先列出内容
echo 即将删除以下文件:
dir /s /b "%BASE_DIR%"
echo.
set /p "confirm=确认删除？(Y/N): "
if /i "%confirm%"=="Y" (
    rd /s /q "%BASE_DIR%"
    echo 删除完成
) else (
    echo 取消删除
)

:: 4. 使用错误处理
copy important.txt backup.txt >nul 2>&1
if errorlevel 1 (
    echo 复制失败！
    exit /b 1
)

endlocal
```

## 常见陷阱

### 陷阱1：忘记处理路径中的空格

```bat
:: ❌ 错误
set DIR=C:\My Folder
mkdir %DIR%          :: 会创建两个目录: C:\My 和 Folder

:: ✅ 正确
set "DIR=C:\My Folder"
mkdir "%DIR%"        :: 创建一个目录: C:\My Folder
```

### 陷阱2：`%cd%` vs `%~dp0` 混淆

```bat
:: 假设脚本位于 C:\Scripts\test.bat
:: 用户从 C:\Users\John 运行: C:\Scripts\test.bat

echo %cd%    :: 输出: C:\Users\John
echo %~dp0   :: 输出: C:\Scripts\

:: ❌ 错误：依赖%cd%
copy file.txt backup\   :: 在C:\Users\John中查找

:: ✅ 正确：使用%~dp0
copy "%~dp0file.txt" "%~dp0backup\"
```

### 陷阱3：通配符匹配隐藏文件

```bat
:: 默认情况下，dir不显示隐藏文件
dir *.txt

:: 要显示隐藏文件，需要使用/A参数
dir /a:h *.txt

:: 要显示所有文件（包括隐藏和系统）
dir /a *.txt
```

### 陷阱4：`del` 命令的危险性

```bat
:: ❌ 危险：删除所有文件
del *.*

:: ✅ 安全：先查看再删除
dir *.*
:: 确认内容后
del /q *.*

:: ❌ 危险：在错误目录中删除
cd /d C:\important
del *.txt

:: ✅ 安全：使用变量和检查
set "TARGET=C:\important"
if exist "%TARGET%\*.txt" (
    dir "%TARGET%\*.txt"
    del /q "%TARGET%\*.txt"
)
```

### 陷阱5：`rd /s /q` 的不可逆性

```bat
:: ❌ 危险：不可逆删除
rd /s /q "C:\data"

:: ✅ 安全：删除前备份
xcopy "C:\data" "C:\backup\data" /s /e /i
rd /s /q "C:\data"

:: ✅ 更安全：使用变量和确认
set "DELETE_DIR=C:\data"
echo 即将删除: %DELETE_DIR%
dir /s "%DELETE_DIR%"
set /p "confirm=确认删除？(Y/N): "
if /i "%confirm%"=="Y" (
    rd /s /q "%DELETE_DIR%"
)
```

## 练习题

### 练习1：目录结构创建

编写一个批处理脚本，创建以下目录结构：

```
project\
├── src\
│   ├── main\
│   └── test\
├── docs\
├── data\
│   ├── input\
│   └── output\
└── backup\
```

要求：
- 使用`%~dp0`作为基准路径
- 如果目录已存在，不显示错误信息
- 创建完成后显示完整的目录树

### 练习2：文件备份脚本

编写一个批处理脚本，实现以下功能：

1. 在脚本目录下创建`backup`目录
2. 复制当前目录下所有`.txt`文件到`backup`目录
3. 为每个备份文件添加日期后缀（如`file_2024-01-15.txt`）
4. 显示备份文件列表和总大小

提示：使用`%date%`变量获取日期，注意日期格式可能因系统而异。

### 练习3：文件清理脚本

编写一个批处理脚本，清理指定目录中的临时文件：

1. 删除所有`.tmp`文件
2. 删除所有`__pycache__`目录（递归）
3. 删除所有`.log`文件中超过7天的文件
4. 显示删除的文件数量和释放的空间

提示：使用`forfiles`命令可以根据日期筛选文件。

### 练习4：文件属性管理

编写一个批处理脚本：

1. 创建一个测试文件
2. 设置文件为只读和隐藏属性
3. 尝试删除该文件（观察错误）
4. 移除只读属性后删除文件
5. 记录所有操作步骤到日志文件

### 练习5：目录遍历统计

编写一个批处理脚本，统计指定目录的信息：

1. 统计文件总数（递归）
2. 统计目录总数（递归）
3. 按文件扩展名分类统计
4. 找出最大的5个文件
5. 找出最近修改的5个文件

## 总结

本章介绍了CMD中文件与目录管理的核心命令和技巧：

- **目录操作**：`mkdir`、`rmdir`、`cd`、`pushd`/`popd`
- **文件操作**：`copy`、`move`、`ren`、`del`
- **文件查看**：`type`、`more`、`tree`
- **文件属性**：`attrib`和属性位
- **通配符**：`*`和`?`的使用
- **路径管理**：绝对路径、相对路径、`%~dp0`
- **目录遍历**：`for /R`、`for /D`、`dir /S /B`

掌握这些命令是编写实用批处理脚本的基础。在实际应用中，务必注意路径处理、错误处理和安全性。

## 下一步

- [第03章 条件判断与逻辑控制](../ch03-conditionals/index.md)
- [第05章 字符串处理](../ch05-string-processing/index.md)
- [第06章 文件输入输出](../ch06-file-io/index.md)

## 附录

### 命令速查表

| 命令 | 说明 | 常用参数 |
|------|------|----------|
| `mkdir` / `md` | 创建目录 | 路径 |
| `rmdir` / `rd` | 删除目录 | `/s`, `/q` |
| `cd` / `chdir` | 切换目录 | `/d` |
| `pushd` | 保存并切换目录 | 路径 |
| `popd` | 返回保存的目录 | 无 |
| `copy` | 复制文件 | `/Y`, `/V` |
| `move` | 移动文件 | `/Y` |
| `ren` / `rename` | 重命名 | 无 |
| `del` / `erase` | 删除文件 | `/Q`, `/F`, `/S` |
| `type` | 显示文件内容 | 无 |
| `more` | 分页显示 | `/c` |
| `tree` | 显示目录树 | `/F`, `/A` |
| `attrib` | 文件属性 | `+R`, `-R`, `+H`, `-H` |
| `dir` | 列出目录内容 | `/S`, `/B`, `/A` |

### 常用变量

| 变量 | 说明 | 示例输出 |
|------|------|----------|
| `%~dp0` | 脚本所在驱动器和路径 | `C:\scripts\` |
| `%cd%` | 当前工作目录 | `C:\Users\John\` |
| `%~f0` | 脚本完整路径 | `C:\scripts\my.bat` |
| `%~n0` | 脚本文件名 | `my` |
| `%~x0` | 脚本扩展名 | `.bat` |
| `%date%` | 当前日期 | `2024-01-15` |
| `%time%` | 当前时间 | `14:30:25.50` |