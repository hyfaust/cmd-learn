# 附录：速查表与参考资源

!!! info "随时查阅的参考资料"
    本附录提供 CMD/BAT 编程中常用的速查表、参考资源和实用信息，方便你在学习和工作中快速查阅。

## 📋 CMD 命令速查表

### 文件操作命令

| 命令 | 功能 | 示例 |
|------|------|------|
| `copy` | 复制文件 | `copy file1.txt file2.txt` |
| `xcopy` | 复制文件和目录树 | `xcopy /s /e src dest` |
| `robocopy` | 强大的文件复制工具 | `robocopy src dest /mir` |
| `move` | 移动文件 | `move file.txt C:\backup\` |
| `ren` | 重命名文件 | `ren old.txt new.txt` |
| `del` | 删除文件 | `del /q *.tmp` |
| `erase` | 删除文件（同 del） | `erase file.txt` |
| `type` | 显示文件内容 | `type file.txt` |
| `more` | 分页显示文件内容 | `more file.txt` |
| `find` | 在文件中搜索字符串 | `find "text" file.txt` |
| `findstr` | 在文件中搜索字符串（支持正则） | `findstr /i "pattern" *.txt` |
| `comp` | 比较两个文件 | `comp file1.txt file2.txt` |
| `fc` | 比较文件并显示差异 | `fc file1.txt file2.txt` |
| `attrib` | 显示或更改文件属性 | `attrib +r file.txt` |
| `compact` | 显示或更改 NTFS 压缩 | `compact /c file.txt` |
| `cipher` | 显示或更改加密 | `cipher /e file.txt` |

### 目录操作命令

| 命令 | 功能 | 示例 |
|------|------|------|
| `cd` | 更改当前目录 | `cd C:\Windows` |
| `chdir` | 更改当前目录（同 cd） | `chdir /d D:\` |
| `dir` | 显示目录中的文件和子目录 | `dir /a /s` |
| `md` | 创建目录 | `md new_folder` |
| `mkdir` | 创建目录（同 md） | `mkdir "New Folder"` |
| `rd` | 删除目录 | `rd /s /q folder` |
| `rmdir` | 删除目录（同 rd） | `rmdir folder` |
| `tree` | 以图形显示目录结构 | `tree /F` |
| `pushd` | 保存当前目录并更改 | `pushd C:\temp` |
| `popd` | 恢复由 pushd 保存的目录 | `popd` |
| `path` | 显示或设置 PATH 环境变量 | `path` |
| `vol` | 显示磁盘卷标和序列号 | `vol C:` |
| `label` | 创建、更改或删除磁盘卷标 | `label C: MyDisk` |

### 网络命令

| 命令 | 功能 | 示例 |
|------|------|------|
| `ping` | 测试网络连接 | `ping google.com` |
| `ipconfig` | 显示网络配置 | `ipconfig /all` |
| `tracert` | 跟踪路由 | `tracert google.com` |
| `nslookup` | 查询 DNS 记录 | `nslookup google.com` |
| `netstat` | 显示网络统计 | `netstat -an` |
| `nbtstat` | 显示 NetBIOS 统计 | `nbtstat -n` |
| `arp` | 显示和修改 ARP 表 | `arp -a` |
| `route` | 显示和修改路由表 | `route print` |
| `net use` | 连接网络共享 | `net use Z: \\server\share` |
| `net share` | 管理共享资源 | `net share` |
| `net view` | 显示共享资源 | `net view \\server` |
| `ftp` | FTP 客户端 | `ftp ftp.example.com` |
| `telnet` | Telnet 客户端 | `telnet host 23` |
| `netsh` | 网络配置工具 | `netsh interface ip show config` |
| `curl` | URL 传输工具（Win10+） | `curl -O http://example.com/file` |

### 系统命令

| 命令 | 功能 | 示例 |
|------|------|------|
| `systeminfo` | 显示系统信息 | `systeminfo` |
| `tasklist` | 显示进程列表 | `tasklist /v` |
| `taskkill` | 终止进程 | `taskkill /im notepad.exe` |
| `sc` | 服务控制 | `sc query` |
| `net start` | 启动服务 | `net start servicename` |
| `net stop` | 停止服务 | `net stop servicename` |
| `reg` | 注册表操作 | `reg query HKLM\Software` |
| `wmic` | WMI 命令行 | `wmic cpu get name` |
| `shutdown` | 关机或重启 | `shutdown /r /t 0` |
| `logoff` | 注销 | `logoff` |
| `chkdsk` | 检查磁盘 | `chkdsk C: /f` |
| `defrag` | 磁盘碎片整理 | `defrag C:` |
| `sfc` | 系统文件检查器 | `sfc /scannow` |
| `dism` | 部署映像服务和管理 | `dism /online /cleanup-image /restorehealth` |
| `gpupdate` | 更新组策略 | `gpupdate /force` |
| `whoami` | 显示当前用户 | `whoami /all` |
| `hostname` | 显示计算机名 | `hostname` |
| `ver` | 显示 Windows 版本 | `ver` |
| `date` | 显示或设置日期 | `date /t` |
| `time` | 显示或设置时间 | `time /t` |
| `cls` | 清除屏幕 | `cls` |
| `exit` | 退出 CMD | `exit` |
| `help` | 显示命令帮助 | `help dir` |
| `cmd /?` | 显示 CMD 帮助 | `cmd /?` |

### 字符串处理命令

| 命令 | 功能 | 示例 |
|------|------|------|
| `echo` | 显示消息 | `echo Hello World` |
| `set` | 设置环境变量 | `set var=value` |
| `set /a` | 算术运算 | `set /a result=1+2` |
| `set /p` | 用户输入 | `set /p name="Enter name: "` |
| `for` | 循环命令 | `for %%i in (*.txt) do echo %%i` |
| `if` | 条件判断 | `if exist file.txt echo Found` |
| `choice` | 用户选择 | `choice /c YN` |
| `prompt` | 更改命令提示符 | `prompt $P$G` |
| `title` | 设置窗口标题 | `title My Script` |
| `color` | 设置控制台颜色 | `color 0A` |
| `mode` | 配置系统设备 | `mode con cols=80 lines=25` |
| `sort` | 排序输入 | `sort < file.txt` |
| `more` | 分页显示 | `type file.txt | more` |

## 🔣 特殊字符速查表

### 转义字符

| 字符 | 转义形式 | 说明 |
|------|----------|------|
| `%` | `%%` | 在批处理文件中转义百分号 |
| `^` | `^^` | 转义特殊字符 |
| `&` | `^&` | 转义命令连接符 |
| `\|` | `^\|` | 转义管道符 |
| `>` | `^>` | 转义重定向符 |
| `<` | `^<` | 转义输入重定向符 |
| `(` | `^(` | 转义左括号 |
| `)` | `^)` | 转义右括号 |
| `"` | `""` | 在某些上下文中转义引号 |

### 通配符

| 字符 | 说明 | 示例 |
|------|------|------|
| `*` | 匹配任意字符（包括空） | `*.txt` 匹配所有 txt 文件 |
| `?` | 匹配单个字符 | `file?.txt` 匹配 file1.txt |
| `[...]` | 匹配方括号中的字符 | `[abc].txt` 匹配 a.txt |
| `[!...]` | 匹配不在方括号中的字符 | `[!abc].txt` 匹配 d.txt |

### 重定向符

| 字符 | 说明 | 示例 |
|------|------|------|
| `>` | 输出重定向（覆盖） | `echo text > file.txt` |
| `>>` | 输出重定向（追加） | `echo text >> file.txt` |
| `<` | 输入重定向 | `sort < file.txt` |
| `2>` | 错误重定向（覆盖） | `command 2> error.log` |
| `2>>` | 错误重定向（追加） | `command 2>> error.log` |
| `2>&1` | 错误合并到标准输出 | `command > all.log 2>&1` |
| `>&` | 重定向句柄 | `command 2>&1` |

### 管道符

| 字符 | 说明 | 示例 |
|------|------|------|
| `\|` | 管道，将前命令输出作为后命令输入 | `dir \| find "txt"` |
| `&&` | 前命令成功后执行后命令 | `mkdir folder && cd folder` |
| `\|\|` | 前命令失败后执行后命令 | `command \|\| echo Failed` |
| `&` | 顺序执行命令 | `command1 & command2` |
| `()` | 命令分组 | `(command1 & command2) > file.txt` |

## 🌐 环境变量速查表

### 系统变量

| 变量 | 说明 | 示例值 |
|------|------|--------|
| `%ALLUSERSPROFILE%` | 所有用户配置文件路径 | `C:\ProgramData` |
| `%APPDATA%` | 当前用户应用程序数据路径 | `C:\Users\User\AppData\Roaming` |
| `%CommonProgramFiles%` | 公共程序文件路径 | `C:\Program Files\Common Files` |
| `%CommonProgramFiles(x86)%` | 公共程序文件路径（32位） | `C:\Program Files (x86)\Common Files` |
| `%CommonProgramW6432%` | 公共程序文件路径（64位） | `C:\Program Files\Common Files` |
| `%ComSpec%` | 命令解释器路径 | `C:\Windows\System32\cmd.exe` |
| `%HOMEDRIVE%` | 用户主目录驱动器 | `C:` |
| `%HOMEPATH%` | 用户主目录路径 | `\Users\User` |
| `%LOCALAPPDATA%` | 本地应用程序数据路径 | `C:\Users\User\AppData\Local` |
| `%ProgramData%` | 程序数据路径 | `C:\ProgramData` |
| `%ProgramFiles%` | 程序文件路径 | `C:\Program Files` |
| `%ProgramFiles(x86)%` | 程序文件路径（32位） | `C:\Program Files (x86)` |
| `%ProgramW6432%` | 程序文件路径（64位） | `C:\Program Files` |
| `%SystemDrive%` | 系统驱动器 | `C:` |
| `%SystemRoot%` | 系统根目录 | `C:\Windows` |
| `%TEMP%` | 临时文件目录 | `C:\Users\User\AppData\Local\Temp` |
| `%TMP%` | 临时文件目录（同 TEMP） | `C:\Users\User\AppData\Local\Temp` |
| `%USERPROFILE%` | 用户配置文件路径 | `C:\Users\User` |
| `%windir%` | Windows 目录 | `C:\Windows` |

### 用户变量

| 变量 | 说明 | 示例值 |
|------|------|--------|
| `%USERNAME%` | 当前用户名 | `User` |
| `%USERDOMAIN%` | 用户域 | `WORKGROUP` |
| `%LOGONSERVER%` | 登录服务器 | `\\DC01` |
| `%HOMESHARE%` | 用户主目录共享路径 | `\\server\share` |
| `%PATH%` | 可执行文件搜索路径 | `C:\Windows\System32;...` |
| `%PATHEXT%` | 可执行文件扩展名 | `.COM;.EXE;.BAT;.CMD` |
| `%PSModulePath%` | PowerShell 模块路径 | `C:\Users\User\Documents\...` |

### 动态变量

| 变量 | 说明 | 示例值 |
|------|------|--------|
| `%CD%` | 当前目录 | `C:\Users\User` |
| `%DATE%` | 当前日期 | `2026-06-11` |
| `%TIME%` | 当前时间 | `14:30:00.00` |
| `%RANDOM%` | 随机数（0-32767） | `12345` |
| `%ERRORLEVEL%` | 当前错误级别 | `0` |
| `%CMDCMDLINE%` | 原始命令行 | `cmd.exe` |
| `%CMDEXTVERSION%` | 命令扩展版本 | `2` |
| `%HIGHESTNUMANODENUMBER%` | 最高 NUMA 节点号 | `0` |
| `%NUMBER_OF_PROCESSORS%` | 处理器数量 | `8` |
| `%OS%` | 操作系统名称 | `Windows_NT` |
| `%PROCESSOR_ARCHITECTURE%` | 处理器架构 | `AMD64` |
| `%PROCESSOR_IDENTIFIER%` | 处理器标识符 | `Intel64 Family 6 Model...` |
| `%PROCESSOR_LEVEL%` | 处理器级别 | `6` |
| `%PROCESSOR_REVISION%` | 处理器修订版本 | `8e09` |

## ❌ 错误代码速查表

### 常见 ERRORLEVEL 值

| 代码 | 说明 | 常见场景 |
|------|------|----------|
| `0` | 成功 | 命令执行成功 |
| `1` | 一般错误 | 未知错误 |
| `2` | 找不到文件 | 文件不存在 |
| `3` | 找不到路径 | 路径不存在 |
| `5` | 拒绝访问 | 权限不足 |
| `8` | 内存不足 | 系统内存不足 |
| `10` | 环境不正确 | 环境变量错误 |
| `11` | 格式不正确 | 文件格式错误 |
| `12` | 访问码无效 | 访问权限错误 |
| `13` | 数据无效 | 数据格式错误 |
| `15` | 驱动器不存在 | 驱动器未找到 |
| `16` | 无法删除目录 | 目录非空或权限不足 |
| `17` | 不是同一设备 | 跨设备操作 |
| `18` | 没有更多文件 | 搜索完成 |
| `32` | 共享冲突 | 文件被占用 |
| `33` | 锁定冲突 | 文件被锁定 |
| `80` | 文件已存在 | 文件名冲突 |
| `87` | 参数不正确 | 命令参数错误 |
| `112` | 磁盘空间不足 | 磁盘已满 |
| `123` | 文件名、目录名或卷标语法不正确 | 路径格式错误 |
| `145` | 目录不为空 | 目录非空 |
| `161` | 路径无效 | 路径格式错误 |
| `183` | 文件已存在 | 文件名冲突 |
| `193` | 不是有效的 Win32 应用程序 | 程序损坏或格式错误 |
| `206` | 文件名或扩展名太长 | 路径过长 |
| `267` | 目录名无效 | 目录名格式错误 |
| `999` | 自定义错误 | 脚本自定义错误 |

### 网络命令错误代码

| 代码 | 说明 |
|------|------|
| `0` | 成功 |
| `1` | 连接被拒绝 |
| `2` | 连接超时 |
| `3` | 目标不可达 |
| `4` | 一般故障 |
| `5` | 参数错误 |
| `6` | 内存不足 |
| `7` | 权限不足 |
| `8` | 资源不可用 |
| `9` | 超时 |
| `10` | 连接已关闭 |
| `11` | 连接被重置 |
| `12` | 连接被中断 |

## 🔍 常用正则表达式（findstr 支持）

### 基本正则表达式

| 表达式 | 说明 | 示例 |
|--------|------|------|
| `.` | 匹配任意单个字符 | `f.d` 匹配 `fad`、`fbd` |
| `*` | 匹配前一个字符零次或多次 | `fo*d` 匹配 `fd`、`fod`、`food` |
| `^` | 匹配行首 | `^Hello` 匹配以 Hello 开头的行 |
| `$` | 匹配行尾 | `end$` 匹配以 end 结尾的行 |
| `[charset]` | 匹配方括号中的字符 | `[abc]` 匹配 a、b 或 c |
| `[^charset]` | 匹配不在方括号中的字符 | `[^abc]` 匹配除 a、b、c 外的字符 |
| `[x-y]` | 匹配范围内的字符 | `[a-z]` 匹配小写字母 |
| `\` | 转义特殊字符 | `\.` 匹配点号 |
| `\<` | 匹配单词开头 | `\<word` 匹配以 word 开头的单词 |
| `\>` | 匹配单词结尾 | `word\>` 匹配以 word 结尾的单词 |

### 常用正则表达式模式

```cmd
:: 匹配 IP 地址
findstr /r "[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*" file.txt

:: 匹配邮箱地址
findstr /r "[a-zA-Z0-9._%+-]*@[a-zA-Z0-9.-]*\.[a-zA-Z]*" file.txt

:: 匹配日期格式 (YYYY-MM-DD)
findstr /r "[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]" file.txt

:: 匹配 URL
findstr /r "http[s]*://[a-zA-Z0-9./-]*" file.txt

:: 匹配数字
findstr /r "[0-9][0-9]*" file.txt

:: 匹配字母
findstr /r "[a-zA-Z][a-zA-Z]*" file.txt

:: 匹配空行
findstr /r "^$" file.txt

:: 匹配包含特定单词的行
findstr /i "error" file.txt

:: 匹配以大写字母开头的行
findstr /r "^[A-Z]" file.txt

:: 匹配文件扩展名
findstr /r "\.txt$" file.txt
```

### findstr 选项

| 选项 | 说明 |
|------|------|
| `/C:string` | 使用指定字符串作为搜索模式 |
| `/G:file` | 从指定文件获取搜索模式 |
| `/F:file` | 从指定文件获取文件列表 |
| `/D:dir` | 搜索指定目录 |
| `/R` | 使用正则表达式 |
| `/I` | 忽略大小写 |
| `/S` | 搜索子目录 |
| `/V` | 显示不包含匹配项的行 |
| `/N` | 显示行号 |
| `/M` | 只显示文件名 |
| `/L` | 使用文字搜索字符串 |
| `/B` | 匹配行首 |
| `/E` | 匹配行尾 |
| `/O` | 显示偏移量 |
| `/P` | 跳过不可打印字符 |
| `/OFF` | 不跳过带有脱机属性集的文件 |
| `/A:attr` | 具有指定属性的文件 |
| `/X` | 打印完全匹配的行 |

## 📚 推荐资源

### 官方文档

| 资源 | 链接 | 说明 |
|------|------|------|
| Microsoft 命令行参考 | [learn.microsoft.com](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/windows-commands) | 官方命令行文档 |
| CMD 命令帮助 | `cmd /?` | 本地帮助文档 |
| Windows 脚本宿主 | [MSDN](https://learn.microsoft.com/zh-cn/previous-versions/windows/scripting/default) | 脚本编程参考 |
| PowerShell 文档 | [learn.microsoft.com](https://learn.microsoft.com/zh-cn/powershell/) | PowerShell 参考 |

### 社区资源

| 资源 | 链接 | 说明 |
|------|------|------|
| Stack Overflow | [stackoverflow.com](https://stackoverflow.com/) | 编程问答社区 |
| Super User | [superuser.com](https://superuser.com/) | 计算机问答社区 |
| Reddit - r/Batch | [reddit.com/r/Batch](https://www.reddit.com/r/Batch/) | 批处理脚本社区 |
| SS64 | [ss64.com](https://ss64.com/) | 命令行参考网站 |
| Batchography | [lallouslab.net](https://lallouslab.net/) | 批处理编程博客 |
| DosTips | [forums.dostips.com](https://forums.dostips.com/) | DOS 技巧论坛 |

### 进阶书籍

| 书名 | 作者 | 说明 |
|------|------|------|
| 《Windows 批处理脚本编程》 | 未知 | 批处理脚本编程指南 |
| 《Windows 命令行详解》 | 未知 | 命令行参考手册 |
| 《Windows PowerShell 实战指南》 | 未知 | PowerShell 进阶学习 |
| 《Windows 系统管理脚本编程》 | 未知 | 系统管理自动化 |
| 《批处理脚本编程入门》 | 未知 | 批处理编程入门 |

### 在线工具

| 工具 | 链接 | 说明 |
|------|------|------|
| CMD 在线运行 | [tio.run](https://tio.run/#batch) | 在线运行批处理脚本 |
| 正则表达式测试 | [regex101.com](https://regex101.com/) | 正则表达式测试工具 |
| ASCII 表 | [asciitable.com](https://www.asciitable.com/) | ASCII 码参考表 |
| 字符编码转换 | [convertstring.com](https://www.convertstring.com/) | 字符编码转换工具 |

## 🛠️ 实用脚本模板

### 环境检查脚本

```bat
@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo         环境检查脚本
echo ========================================
echo.

:: 检查操作系统版本
echo [1] 操作系统版本:
ver
echo.

:: 检查系统信息
echo [2] 系统信息:
systeminfo | findstr /B /C:"OS 名称" /C:"OS 版本" /C:"系统类型"
echo.

:: 检查网络配置
echo [3] 网络配置:
ipconfig | findstr /B /C:"IPv4" /C:"子网掩码" /C:"默认网关"
echo.

:: 检查磁盘空间
echo [4] 磁盘空间:
wmic logicaldisk get caption,size,freespace /format:table
echo.

:: 检查环境变量
echo [5] 重要环境变量:
echo PATH: %PATH:~0,100%...
echo TEMP: %TEMP%
echo USERNAME: %USERNAME%
echo COMPUTERNAME: %COMPUTERNAME%
echo.

echo ========================================
echo         环境检查完成
echo ========================================
pause
```

### 错误处理模板

```bat
@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: 设置错误处理
set "ERROR_LOG=error.log"
set "SCRIPT_NAME=%~n0"

:: 主程序
call :main
if errorlevel 1 (
    echo [错误] 脚本执行失败，请查看 %ERROR_LOG%
    pause
    exit /b 1
)

echo [成功] 脚本执行完成
pause
exit /b 0

:: 主函数
:main
echo [%date% %time%] 脚本开始执行 >> "%ERROR_LOG%"

:: 你的代码在这里
echo 正在执行任务...

:: 模拟错误检查
if not exist "required_file.txt" (
    echo [错误] 找不到必需文件 >> "%ERROR_LOG%"
    echo [错误] 找不到必需文件
    exit /b 1
)

echo [%date% %time%] 脚本执行完成 >> "%ERROR_LOG%"
exit /b 0
```

### 日志记录模板

```bat
@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: 日志配置
set "LOG_DIR=logs"
set "LOG_FILE=%LOG_DIR%\%date:~0,10%.log"
set "LOG_LEVEL=INFO"

:: 创建日志目录
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

:: 日志函数
:log
set "level=%~1"
set "message=%~2"
set "timestamp=%date% %time%"
echo [%timestamp%] [%level%] %message% >> "%LOG_FILE%"
echo [%timestamp%] [%level%] %message%
goto :eof

:: 主程序
call :log "INFO" "脚本开始执行"

:: 你的代码在这里
call :log "INFO" "正在处理数据..."
call :log "WARNING" "这是一个警告信息"
call :log "ERROR" "这是一个错误信息"

call :log "INFO" "脚本执行完成"

:: 显示日志文件位置
echo.
echo 日志文件: %LOG_FILE%
pause
```

## 📖 命令帮助速查

### 获取命令帮助

```cmd
:: 显示所有可用命令
help

:: 显示特定命令的帮助
command /?

:: 示例
dir /?
for /?
if /?
set /?
findstr /?
```

### 常用帮助选项

| 命令 | 帮助选项 | 说明 |
|------|----------|------|
| `dir /?` | `/P`, `/W`, `/S`, `/A` | 目录列表选项 |
| `copy /?` | `/V`, `/Y`, `/-Y` | 复制选项 |
| `for /?` | `/L`, `/R`, `/D`, `/F` | 循环选项 |
| `if /?` | `errorlevel`, `exist`, `==` | 条件选项 |
| `set /?` | `/A`, `/P` | 变量设置选项 |
| `findstr /?` | `/R`, `/I`, `/S`, `/V` | 搜索选项 |
| `reg /?` | `query`, `add`, `delete` | 注册表操作 |

---

!!! note "关于本附录"

    本附录提供了 CMD/BAT 编程中最常用的参考资源。建议你将本页添加到书签，方便随时查阅。
    
    如果你发现任何错误或有改进建议，欢迎提交反馈。
