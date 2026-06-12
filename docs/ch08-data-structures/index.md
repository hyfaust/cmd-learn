# 第08章 数据结构模拟 — 在限制中创造

## 学习目标

通过本章学习，你将能够：

1. 理解CMD中数据结构模拟的基本原理
2. 掌握使用变量模拟数组、字典、栈、队列等数据结构的方法
3. 学会实现多维数组和矩阵操作
4. 理解数据持久化与恢复技术
5. 了解CMD数据结构的性能特点和限制
6. 对比其他编程语言中的内置数据结构

## 前置知识

- 变量和延迟扩展（第01章）
- 循环结构（第04章）
- 文件I/O操作（第06章）
- 函数定义（第07章）

## 章节概述

CMD批处理脚本没有像Python、JavaScript那样的内置数据结构，如列表、字典、集合等。但这并不意味着我们无法处理复杂数据。通过巧妙地使用环境变量和字符串操作，我们可以模拟出各种常用数据结构。

本章将深入探讨如何在CMD的限制下，创造实用的数据结构解决方案。我们将从最简单的数组开始，逐步构建更复杂的结构，最终实现数据的持久化存储。

!!! note "CMD的限制与创造力"
    CMD的限制恰恰激发了我们的创造力。通过理解变量、延迟扩展和字符串处理，我们可以在看似简单的系统中构建出功能强大的数据处理能力。

## 核心概念详解

### 1. 数组模拟

#### 1.1 基本数组实现

CMD中模拟数组的最常用方法是使用编号变量。例如，我们可以使用 `var_0`, `var_1`, `var_2` 等变量来存储数组元素。

```bat
@echo off
setlocal EnableDelayedExpansion

:: 创建数组
set "arr[0]=Apple"
set "arr[1]=Banana"
set "arr[2]=Cherry"
set "arr[3]=Date"
set "arr_len=4"

:: 遍历数组
for /L %%i in (0,1,3) do (
    echo arr[%%i]=!arr[%%i]!
)

endlocal
```

#### 1.2 动态数组操作

要实现动态数组，我们需要维护数组长度，并能够添加、删除和修改元素。

```bat
@echo off
setlocal EnableDelayedExpansion

:: 初始化数组
set "arr_len=0"

:: 添加元素
call :add_element "Apple"
call :add_element "Banana"
call :add_element "Cherry"

echo 数组内容:
for /L %%i in (0,1,!arr_len!-1) do (
    echo arr[%%i]=!arr[%%i]!
)

:: 修改元素
set "arr[1]=Blueberry"
echo.
echo 修改后:
for /L %%i in (0,1,!arr_len!-1) do (
    echo arr[%%i]=!arr[%%i]!
)

endlocal
goto :eof

:add_element
set "arr[!arr_len!]=%~1"
set /a "arr_len+=1"
goto :eof
```

!!! warning "数组边界检查"
    在访问数组元素时，务必进行边界检查。如果访问超出数组长度的索引，CMD不会报错，但会返回空值。

#### 1.3 数组长度的维护

数组长度需要手动维护。有两种常见方法：

1. **显式长度变量**：使用 `arr_len` 变量记录长度
2. **动态计算**：通过遍历计算数组元素数量

```bat
:: 方法1：显式长度
set "arr_len=5"

:: 方法2：动态计算
set "count=0"
for /L %%i in (0,1,100) do (
    if defined arr[%%i] (
        set /a "count+=1"
    )
)
```

### 2. 关联数组（字典）模拟

#### 2.1 基本字典实现

关联数组（字典）使用键值对存储数据。在CMD中，我们可以使用 `key=value` 格式的变量名来实现。

```bat
@echo off
setlocal EnableDelayedExpansion

:: 创建字典
set "dict[name]=Alice"
set "dict[age]=25"
set "dict[city]=Beijing"
set "dict[role]=Developer"

:: 访问字典
echo 姓名: !dict[name]!
echo 年龄: !dict[age]!
echo 城市: !dict[city]!

endlocal
```

#### 2.2 字典的遍历

使用 `for /F` 命令和 `set` 命令可以遍历字典中的所有键值对。

```bat
@echo off
setlocal EnableDelayedExpansion

:: 创建字典
set "dict[name]=Alice"
set "dict[age]=25"
set "dict[city]=Beijing"

:: 遍历字典
echo 字典内容:
for /F "tokens=1,2 delims==" %%a in ('set dict[ 2^>nul') do (
    echo %%a = %%b
)

endlocal
```

#### 2.3 字典操作函数

我们可以创建通用的字典操作函数：

```bat
@echo off
setlocal EnableDelayedExpansion

:: 初始化字典
set "mydict_prefix=mydict"

:: 设置键值对
call :dict_set "name" "Alice"
call :dict_set "age" "25"
call :dict_set "city" "Beijing"

:: 获取值
call :dict_get "name"
echo 姓名: !dict_value!

:: 删除键值对
call :dict_delete "age"

:: 遍历字典
call :dict_iterate

endlocal
goto :eof

:dict_set
set "%mydict_prefix%[%~1]=%~2"
goto :eof

:dict_get
set "dict_value=!%mydict_prefix%[%~1]!"
goto :eof

:dict_delete
set "%mydict_prefix%[%~1]="
goto :eof

:dict_iterate
for /F "tokens=1,2 delims==" %%a in ('set %mydict_prefix%[ 2^>nul') do (
    echo %%a = %%b
)
goto :eof
```

!!! tip "字典键名命名规范"
    字典键名应避免使用特殊字符，如 `=`, `&`, `|`, `<`, `>` 等，这些字符可能导致解析错误。

### 3. 栈模拟

#### 3.1 栈的基本概念

栈是一种后进先出（LIFO）的数据结构。在CMD中，我们可以使用变量列表和栈顶指针来模拟栈。

```mermaid
graph LR
    A[栈底] --> B[元素1] --> C[元素2] --> D[元素3] --> E[栈顶]
```

#### 3.2 栈的实现

```bat
@echo off
setlocal EnableDelayedExpansion

:: 初始化栈
set "stack_size=0"

:: 入栈操作
call :stack_push "First"
call :stack_push "Second"
call :stack_push "Third"

echo 栈大小: !stack_size!

:: 出栈操作
call :stack_pop
echo 弹出: !stack_top!
call :stack_pop
echo 弹出: !stack_top!

echo 栈大小: !stack_size!

endlocal
goto :eof

:stack_push
set /a "stack_size+=1"
set "stack[%stack_size%]=%~1"
goto :eof

:stack_pop
if !stack_size! LEQ 0 (
    echo 栈为空！
    set "stack_top="
    goto :eof
)
set "stack_top=!stack[%stack_size%]!"
set "stack[%stack_size%]="
set /a "stack_size-=1"
goto :eof
```

#### 3.3 栈的应用场景

1. **表达式求值**：计算后缀表达式
2. **括号匹配**：检查括号是否匹配
3. **函数调用**：模拟函数调用栈
4. **撤销操作**：实现撤销功能

```bat
:: 括号匹配检查示例
call :stack_init
set "expression=(a+b)*(c-d)"

for /L %%i in (0,1,100) do (
    set "char=!expression:~%%i,1!"
    if "!char!"=="" goto :check_done
    if "!char!"=="(" call :stack_push "("
    if "!char!")==" call :stack_pop
)

:check_done
if !stack_size! EQU 0 (
    echo 括号匹配！
) else (
    echo 括号不匹配！
)
```

### 4. 队列模拟

#### 4.1 队列的基本概念

队列是一种先进先出（FIFO）的数据结构。在CMD中，我们可以使用变量列表和头尾指针来模拟队列。

```mermaid
graph LR
    A[队首] --> B[元素1] --> C[元素2] --> D[元素3] --> E[队尾]
```

#### 4.2 队列的实现

```bat
@echo off
setlocal EnableDelayedExpansion

:: 初始化队列
set "queue_head=0"
set "queue_tail=0"
set "queue_size=0"

:: 入队操作
call :enqueue "Task A"
call :enqueue "Task B"
call :enqueue "Task C"

echo 队列大小: !queue_size!

:: 出队操作
call :dequeue
echo 出队: !queue_front!
call :dequeue
echo 出队: !queue_front!

echo 队列大小: !queue_size!

endlocal
goto :eof

:enqueue
set /a "queue_tail+=1"
set /a "queue_size+=1"
set "queue[%queue_tail%]=%~1"
goto :eof

:dequeue
if !queue_size! LEQ 0 (
    echo 队列为空！
    set "queue_front="
    goto :eof
)
set /a "queue_head+=1"
set "queue_front=!queue[%queue_head%]!"
set "queue[%queue_head%]="
set /a "queue_size-=1"
goto :eof
```

#### 4.3 循环队列

为了避免队列空间浪费，我们可以实现循环队列：

```bat
@echo off
setlocal EnableDelayedExpansion

:: 循环队列参数
set "queue_capacity=5"
set "queue_head=0"
set "queue_tail=0"
set "queue_size=0"

:: 入队操作
call :circular_enqueue "A"
call :circular_enqueue "B"
call :circular_enqueue "C"

:: 出队操作
call :circular_dequeue
echo 出队: !queue_front!

:: 继续入队
call :circular_enqueue "D"

endlocal
goto :eof

:circular_enqueue
if !queue_size! GEQ !queue_capacity! (
    echo 队列已满！
    goto :eof
)
set "queue[!queue_tail!]=%~1"
set /a "queue_tail=(queue_tail + 1) %% queue_capacity"
set /a "queue_size+=1"
goto :eof

:circular_dequeue
if !queue_size! LEQ 0 (
    echo 队列为空！
    set "queue_front="
    goto :eof
)
set "queue_front=!queue[%queue_head%]!"
set "queue[%queue_head%]="
set /a "queue_head=(queue_head + 1) %% queue_capacity"
set /a "queue_size-=1"
goto :eof
```

### 5. 链表模拟

#### 5.1 链表的基本概念

链表是一种动态数据结构，每个节点包含数据和指向下一个节点的指针。在CMD中，我们可以使用编号变量来模拟链表节点。

```mermaid
graph LR
    A[节点1: 数据|next] --> B[节点2: 数据|next] --> C[节点3: 数据|next] --> D[NULL]
```

#### 5.2 链表的实现

```bat
@echo off
setlocal EnableDelayedExpansion

:: 初始化链表
set "list_head=0"
set "list_size=0"
set "free_nodes="

:: 添加节点
call :list_append "Apple"
call :list_append "Banana"
call :list_append "Cherry"

echo 链表内容:
call :list_traverse

:: 在指定位置插入节点
call :list_insert 1 "Blueberry"
echo.
echo 插入后:
call :list_traverse

endlocal
goto :eof

:list_append
set /a "list_size+=1"
set "node_data[!list_size!]=%~1"
set "node_next[!list_size!]=0"

if !list_head! EQU 0 (
    set "list_head=!list_size!"
) else (
    set "current=!list_head!"
    :find_tail
    if !node_next[%current%]! NEQ 0 (
        set "current=!node_next[%current%]!"
        goto :find_tail
    )
    set "node_next[%current%]=!list_size!"
)
goto :eof

:list_traverse
set "current=!list_head!"
:traverse_loop
if !current! EQU 0 goto :eof
echo 节点!current!: !node_data[%current%]!
set "current=!node_next[%current%]!"
goto :traverse_loop

:list_insert
:: 在位置%1插入数据%2
set "position=%~1"
set "data=%~2"
set /a "list_size+=1"
set "new_node=!list_size!"
set "node_data[!new_node!]=!data!"

set "current=!list_head!"
set "prev=0"
set "count=0"

:find_position
if !count! GEQ !position! goto :insert_here
set "prev=!current!"
set "current=!node_next[%current%]!"
set /a "count+=1"
if !current! NEQ 0 goto :find_position

:insert_here
if !prev! EQU 0 (
    set "node_next[!new_node!]=!list_head!"
    set "list_head=!new_node!"
) else (
    set "node_next[!new_node!]=!node_next[%prev%]!"
    set "node_next[%prev%]=!new_node!"
)
goto :eof
```

!!! warning "链表性能考虑"
    在CMD中模拟链表会占用大量变量，且遍历操作需要逐个节点访问，性能较差。对于小规模数据，使用数组更高效。

### 6. 多维数组

#### 6.1 二维数组实现

CMD中可以使用 `var_row_col` 格式的变量名来模拟二维数组。

```bat
@echo off
setlocal EnableDelayedExpansion

:: 创建3x3矩阵
for /L %%i in (1,1,3) do (
    for /L %%j in (1,1,3) do (
        set /a "mat[%%i][%%j]=%%i * 10 + %%j"
    )
)

:: 打印矩阵
for /L %%i in (1,1,3) do (
    set "line="
    for /L %%j in (1,1,3) do (
        set "line=!line! !mat[%%i][%%j]!"
    )
    echo !line!
)

endlocal
```

#### 6.2 矩阵操作

```bat
@echo off
setlocal EnableDelayedExpansion

:: 创建矩阵
set "mat[1][1]=1" & set "mat[1][2]=2" & set "mat[1][3]=3"
set "mat[2][1]=4" & set "mat[2][2]=5" & set "mat[2][3]=6"
set "mat[3][1]=7" & set "mat[3][2]=8" & set "mat[3][3]=9"

:: 矩阵转置
for /L %%i in (1,1,3) do (
    for /L %%j in (1,1,3) do (
        set "trans[%%j][%%i]=!mat[%%i][%%j]!"
    )
)

:: 打印转置矩阵
echo 转置矩阵:
for /L %%i in (1,1,3) do (
    set "line="
    for /L %%j in (1,1,3) do (
        set "line=!line! !trans[%%i][%%j]!"
    )
    echo !line!
)

endlocal
```

#### 6.3 高维数组

对于更高维度的数组，可以使用多级索引：

```bat
@echo off
setlocal EnableDelayedExpansion

:: 三维数组：var_depth_row_col
set "vol[1][1][1]=100"
set "vol[1][1][2]=101"
set "vol[1][2][1]=110"
set "vol[1][2][2]=111"

:: 访问三维数组
echo vol[1][1][1]=!vol[1][1][1]!
echo vol[1][2][2]=!vol[1][2][2]!

endlocal
```

### 7. 数据持久化

#### 7.1 保存数据结构到文件

将内存中的数据结构保存到文件，以便后续恢复使用。

```bat
@echo off
setlocal EnableDelayedExpansion

:: 创建数据
set "data[name]=Alice"
set "data[score]=95"
set "data[level]=Advanced"

:: 保存到文件
set "DATAFILE=%~dp0data_store.txt"

(
for /F "tokens=1,2 delims==" %%a in ('set data[ 2^>nul') do (
    echo %%a=%%b
)
) > "%DATAFILE%"

echo 数据已保存到: %DATAFILE%
type "%DATAFILE%"

endlocal
```

#### 7.2 从文件恢复数据结构

```bat
@echo off
setlocal EnableDelayedExpansion

:: 从文件恢复数据
set "DATAFILE=%~dp0data_store.txt"

if not exist "%DATAFILE%" (
    echo 数据文件不存在！
    exit /b 1
)

for /F "tokens=1,2 delims==" %%a in (%DATAFILE%) do (
    set "%%a=%%b"
)

:: 验证恢复的数据
echo 恢复的数据:
echo 姓名: !data[name]!
echo 分数: !data[score]!
echo 等级: !data[level]!

endlocal
```

#### 7.3 复杂数据结构的持久化

对于更复杂的数据结构，可以使用自定义格式：

```bat
@echo off
setlocal EnableDelayedExpansion

:: 保存数组
set "arr[0]=Apple"
set "arr[1]=Banana"
set "arr[2]=Cherry"
set "arr_len=3"

:: 保存到文件
(
echo [ARRAY]
echo length=!arr_len!
for /L %%i in (0,1,!arr_len!-1) do (
    echo item_%%i=!arr[%%i]!
)
echo [DICTIONARY]
echo name=Alice
echo age=25
) > "complex_data.txt"

:: 从文件恢复
for /F "tokens=1,2 delims==" %%a in ('findstr /v "^\[" "complex_data.txt"') do (
    set "%%a=%%b"
)

:: 验证
echo 恢复的数组长度: !arr_len!
for /L %%i in (0,1,!arr_len!-1) do (
    echo arr[%%i]=!arr[%%i]!
)

:: 清理
del "complex_data.txt" 2>nul
endlocal
```

## 数据结构概念

### 1. 数组的内存布局

在CMD中，数组实际上是分散存储的环境变量。每个数组元素都是一个独立的环境变量，存储在进程的环境块中。

```mermaid
graph TB
    subgraph "CMD数组内存布局"
        A[环境变量表]
        B[arr[0]=Apple]
        C[arr[1]=Banana]
        D[arr[2]=Cherry]
        E[arr_len=3]
    end
    
    A --> B
    A --> C
    A --> D
    A --> E
```

**连续 vs 分散存储**：

| 存储方式 | 优点 | 缺点 |
|---------|------|------|
| 连续存储（传统数组） | 访问速度快，内存局部性好 | 大小固定，插入删除困难 |
| 分散存储（CMD数组） | 动态大小，易于扩展 | 访问速度慢，内存碎片 |

### 2. 时间复杂度分析

在CMD中，数据结构操作的时间复杂度与传统编程语言有所不同：

| 操作 | 传统数组 | CMD数组 | 说明 |
|------|----------|---------|------|
| 访问元素 | O(1) | O(1) | 直接通过变量名访问 |
| 遍历数组 | O(n) | O(n) | 需要循环遍历 |
| 添加元素 | O(1) | O(1) | 设置新变量 |
| 删除元素 | O(n) | O(n) | 需要重新索引 |
| 查找元素 | O(n) | O(n) | 需要遍历比较 |

**特殊考虑**：

1. **变量数量限制**：CMD环境变量数量有限（通常数千个）
2. **字符串操作开销**：CMD的字符串操作比直接内存访问慢得多
3. **循环开销**：CMD的循环比编译语言慢得多

### 3. 空间换时间策略

在CMD中，空间换时间策略尤为重要：

```bat
:: 示例：使用空间换时间优化查找
:: 方法1：直接遍历查找（慢）
for /L %%i in (0,1,1000) do (
    if "!arr[%%i]!"=="target" (
        echo 找到目标
        goto :found
    )
)

:: 方法2：建立索引（快）
:: 创建索引变量
set "index[target]=500"
:: 直接访问
echo 目标位置: !index[target]!
```

**策略建议**：

1. **预计算**：提前计算并存储常用值
2. **缓存**：缓存重复计算的结果
3. **索引**：为频繁查找的字段建立索引
4. **批量处理**：减少循环次数

## 与其他编程语言的对比

### 内置数据结构对比

| 特性 | CMD | Python | JavaScript | C | Lua |
|------|-----|--------|------------|---|-----|
| 数组/列表 | 需要模拟 | `list` | `Array` | 原生数组 | `table` |
| 字典/映射 | 需要模拟 | `dict` | `Map`, `Object` | 哈希表实现 | `table` |
| 集合 | 需要模拟 | `set` | `Set` | 位图/哈希 | `table` |
| 栈/队列 | 需要模拟 | `collections.deque` | `Array` | 结构体+链表 | `table` |
| 链表 | 需要模拟 | 需要自定义 | 需要自定义 | 原生支持 | 需要自定义 |
| 多维数组 | 需要模拟 | `numpy.ndarray` | 需要嵌套 | 原生支持 | 嵌套table |

### 性能对比

| 操作 | CMD | Python | JavaScript | C | Lua |
|------|-----|--------|------------|---|-----|
| 创建数组 | 慢 | 快 | 快 | 极快 | 快 |
| 遍历数组 | 很慢 | 快 | 快 | 极快 | 快 |
| 字典查找 | 慢 | O(1) | O(1) | O(1) | O(1) |
| 内存使用 | 高 | 中等 | 中等 | 低 | 中等 |

### 代码示例对比

**Python版本**：
```python
# Python数组和字典
arr = ["Apple", "Banana", "Cherry"]
person = {"name": "Alice", "age": 25}

# 遍历
for item in arr:
    print(item)

for key, value in person.items():
    print(f"{key}: {value}")
```

**JavaScript版本**：
```javascript
// JavaScript数组和Map
const arr = ["Apple", "Banana", "Cherry"];
const person = new Map([["name", "Alice"], ["age", 25]]);

// 遍历
arr.forEach(item => console.log(item));

person.forEach((value, key) => {
    console.log(`${key}: ${value}`);
});
```

**CMD版本**：
```bat
@echo off
setlocal EnableDelayedExpansion

:: CMD模拟数组和字典
set "arr[0]=Apple"
set "arr[1]=Banana"
set "arr[2]=Cherry"

set "person[name]=Alice"
set "person[age]=25"

:: 遍历
for /L %%i in (0,1,2) do (
    echo !arr[%%i]!
)

for /F "tokens=1,2 delims==" %%a in ('set person[ 2^>nul') do (
    echo %%a = %%b
)

endlocal
```

**C语言版本**：
```c
#include <stdio.h>
#include <stdlib.h>

// 数组
int arr[3] = {1, 2, 3};

// 结构体（字典模拟）
struct Person {
    char name[50];
    int age;
};

// 链表节点
struct Node {
    int data;
    struct Node* next;
};

// 哈希表实现
typedef struct {
    char key[50];
    int value;
} HashEntry;
```

**Lua版本**：
```lua
-- 数组（使用table）
local fruits = {"Apple", "Banana", "Cherry"}

-- 字典（使用table）
local person = {
    name = "Alice",
    age = 25
}

-- 遍历数组
for i, fruit in ipairs(fruits) do
    print(fruit)
end

-- 遍历字典
for key, value in pairs(person) do
    print(key .. ": " .. value)
end
```

**完整的对比代码示例**：请参见 `examples/ch08/` 目录下的 `comparison.py`、`comparison.js`、`comparison.c`、`comparison.lua` 文件。

## 最佳实践和常见陷阱

### 1. 变量数量的系统限制

CMD环境变量有数量限制，通常为数千个。超过限制会导致系统不稳定。

**最佳实践**：

```bat
:: 检查变量数量
set "count=0"
for /F %%a in ('set') do (
    set /a "count+=1"
)
echo 当前变量数量: !count!

:: 清理不需要的变量
for /L %%i in (0,1,1000) do (
    set "temp[%%i]="
)
```

### 2. 大量变量的性能问题

当变量数量过多时，CMD性能会显著下降。

**优化策略**：

1. **使用局部变量**：在 `setlocal` 和 `endlocal` 之间使用变量
2. **及时清理**：不再使用的变量及时删除
3. **批量处理**：减少变量访问次数
4. **避免深层嵌套**：减少循环嵌套层数

```bat
@echo off
setlocal EnableDelayedExpansion

:: 使用局部变量
for /L %%i in (0,1,1000) do (
    set "temp[%%i]=value"
)

:: 结束时自动清理
endlocal
```

### 3. 命名冲突的避免

CMD变量名不区分大小写，且容易发生冲突。

**命名规范**：

```bat
:: 避免使用系统变量名
:: 错误示例
set "path=新路径"  :: 冲突！PATH是系统变量

:: 正确示例
set "my_path=新路径"

:: 使用前缀避免冲突
set "app_data[name]=Alice"
set "app_data[age]=25"

:: 使用模块化命名
set "user[name]=Alice"
set "config[debug]=true"
set "cache[timeout]=300"
```

### 4. 特殊字符处理

某些特殊字符在变量名或值中可能导致问题。

**需要避免的字符**：
- `=`：用于键值对分隔
- `&`：命令连接符
- `|`：管道符
- `<`, `>`：重定向符
- `^`：转义字符
- `%`：变量引用

```bat
:: 错误示例
set "data[key&name]=value"  :: 错误！&是命令连接符

:: 正确示例
set "data[key_name]=value"

:: 安全地存储包含特殊字符的值
set "data[special]=This ^& is ^| safe"
```

### 5. 调试数据结构问题

CMD调试数据结构比较困难，但有一些技巧：

```bat
@echo off
setlocal EnableDelayedExpansion

:: 调试函数
:debug_dump
echo === 调试信息 ===
echo 变量列表:
set arr[ 2>nul
echo.
echo 数组长度: !arr_len!
echo === 调试结束 ===
goto :eof

:: 使用调试函数
set "arr[0]=Apple"
set "arr[1]=Banana"
set "arr_len=2"
call :debug_dump

endlocal
```

## 练习题

### 练习1：实现一个简单的栈计算器

创建一个脚本，使用栈来计算后缀表达式（逆波兰表示法）。

**要求**：
1. 实现栈的基本操作（push, pop）
2. 支持基本运算符：`+`, `-`, `*`, `/`
3. 处理多位数字
4. 显示计算过程

**输入示例**：`3 4 + 2 *` 等价于 `(3 + 4) * 2 = 14`

### 练习2：实现一个简单的数据库

创建一个脚本，模拟简单的键值数据库。

**要求**：
1. 支持 `SET key value` 命令
2. 支持 `GET key` 命令
3. 支持 `DELETE key` 命令
4. 支持 `LIST` 命令显示所有键值对
5. 支持将数据保存到文件和从文件恢复

### 练习3：实现一个简单的任务队列

创建一个脚本，实现任务队列系统。

**要求**：
1. 支持添加任务（入队）
2. 支持处理任务（出队）
3. 支持查看队列状态
4. 实现简单的任务优先级
5. 记录任务处理日志

### 练习4：实现一个简单的矩阵运算库

创建一个脚本，实现基本的矩阵运算。

**要求**：
1. 创建矩阵
2. 矩阵加法
3. 矩阵乘法
4. 矩阵转置
5. 计算矩阵行列式（2x2或3x3）

### 练习5：实现一个简单的链表排序

创建一个脚本，使用链表存储数据并实现排序。

**要求**：
1. 实现单链表
2. 实现插入排序算法
3. 支持从文件读取数据
4. 显示排序前后的链表内容
5. 比较不同排序算法的性能

## 总结

本章我们学习了如何在CMD的限制下模拟各种常用数据结构。虽然CMD没有内置的数据结构，但通过巧妙地使用环境变量和字符串操作，我们可以实现功能强大的数据处理能力。

**关键要点**：

1. **数组模拟**：使用编号变量和循环遍历
2. **字典模拟**：使用 `key=value` 格式和 `for /F` 解析
3. **栈和队列**：使用变量列表和指针维护
4. **多维数组**：使用多级索引如 `var_row_col`
5. **数据持久化**：将数据保存到文件并恢复

**性能考虑**：

- CMD数据结构操作比传统编程语言慢得多
- 大量变量会影响系统性能
- 合理使用空间换时间策略

**最佳实践**：

- 使用有意义的变量名和前缀
- 及时清理不需要的变量
- 进行边界检查和错误处理
- 考虑数据持久化需求

## 下一步学习

在下一章中，我们将学习：

1. 环境变量管理
2. 注册表操作
3. 系统信息获取
4. 配置文件处理

这些知识将帮助你更好地管理CMD环境和系统配置。

## 附加资源

### 推荐阅读

1. [CMD命令行参考](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cmd)
2. [环境变量管理](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/set_1)
3. [批处理脚本编程](https://docs.microsoft.com/en-us/troubleshoot/windows-client/shell-experience/command-line-syntax-updates)

### 在线工具

1. [在线CMD测试环境](https://www.tutorialspoint.com/execute_bat_online.php)
2. [批处理脚本调试器](https://github.com/npocmaka/batch.scripts)

### 社区资源

1. [Stack Overflow CMD标签](https://stackoverflow.com/questions/tagged/cmd)
2. [Reddit r/Batch](https://www.reddit.com/r/Batch/)
3. [CMD开发者论坛](https://www.dostips.com/)

---

**恭喜你完成了第08章的学习！** 你现在已经掌握了在CMD中模拟数据结构的基本技能。虽然CMD有其限制，但这些知识将帮助你编写更复杂、更强大的批处理脚本。继续练习，不断探索，你将发现CMD的更多可能性！