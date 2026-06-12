#!/usr/bin/env luajit
--[[
ffi_demo.lua - LuaJIT FFI 演示

功能: 演示 LuaJIT FFI 调用 Windows API
用法: luajit ffi_demo.lua
安全提示: 仅用于学习 FFI 机制，不执行危险操作
--]]

-- 检查是否支持 FFI
local ok, ffi = pcall(require, "ffi")
if not ok then
    print("[错误] 当前 Lua 版本不支持 FFI")
    print("[提示] 请使用 LuaJIT 而不是标准 Lua")
    os.exit(1)
end

print("========================================")
print("  LuaJIT FFI 演示")
print("========================================")
print()

-- 定义 Windows API 函数
ffi.cdef[[
    // 类型定义
    typedef void* HANDLE;
    typedef unsigned long DWORD;
    typedef int BOOL;
    typedef char* LPSTR;
    typedef const char* LPCSTR;
    
    // kernel32.dll 函数
    DWORD GetTickCount(void);
    DWORD GetCurrentProcessId(void);
    DWORD GetCurrentThreadId(void);
    int GetSystemDirectoryA(char* buffer, int size);
    int GetWindowsDirectoryA(char* buffer, int size);
    int GetComputerNameA(char* buffer, DWORD* size);
    DWORD GetVersion(void);
    
    // user32.dll 函数（注释掉弹窗函数，避免意外弹窗）
    // int MessageBoxA(void* hwnd, const char* text, const char* caption, unsigned int type);
]]

-- 演示 1: 获取系统运行时间
print("[演示 1] 系统运行时间")
print("-" * 40)
local tick = ffi.C.GetTickCount()
local seconds = tick / 1000
local minutes = seconds / 60
local hours = minutes / 60

print(string.format("  原始值: %d 毫秒", tick))
print(string.format("  秒数: %.1f 秒", seconds))
print(string.format("  分钟: %.1f 分钟", minutes))
print(string.format("  小时: %.1f 小时", hours))
print()

-- 演示 2: 获取进程信息
print("[演示 2] 进程信息")
print("-" * 40)
local pid = ffi.C.GetCurrentProcessId()
local tid = ffi.C.GetCurrentThreadId()
print(string.format("  进程 ID: %d", pid))
print(string.format("  线程 ID: %d", tid))
print()

-- 演示 3: 获取系统目录
print("[演示 3] 系统目录")
print("-" * 40)

-- 获取 System 目录
local sys_buffer = ffi.new("char[260]")
local sys_len = ffi.C.GetSystemDirectoryA(sys_buffer, 260)
if sys_len > 0 then
    print("  System 目录: " .. ffi.string(sys_buffer, sys_len))
end

-- 获取 Windows 目录
local win_buffer = ffi.new("char[260]")
local win_len = ffi.C.GetWindowsDirectoryA(win_buffer, 260)
if win_len > 0 then
    print("  Windows 目录: " .. ffi.string(win_buffer, win_len))
end
print()

-- 演示 4: 获取计算机名
print("[演示 4] 计算机名")
print("-" * 40)
local comp_buffer = ffi.new("char[256]")
local comp_size = ffi.new("DWORD[1]", 256)
local result = ffi.C.GetComputerNameA(comp_buffer, comp_size)
if result ~= 0 then
    print("  计算机名: " .. ffi.string(comp_buffer))
end
print()

-- 演示 5: 使用 metatype 封装 C 结构体
print("[演示 5] C 结构体封装")
print("-" * 40)

ffi.cdef[[
    typedef struct {
        double x;
        double y;
    } Point;
]]

-- 定义 Point 的元类型
local Point = ffi.metatype("Point", {
    __tostring = function(self)
        return string.format("(%.2f, %.2f)", self.x, self.y)
    end,
    
    __add = function(a, b)
        return ffi.new("Point", a.x + b.x, a.y + b.y)
    end,
    
    __sub = function(a, b)
        return ffi.new("Point", a.x - b.x, a.y - b.y)
    end,
    
    __len = function(self)
        return math.sqrt(self.x * self.x + self.y * self.y)
    end
})

local p1 = ffi.new("Point", 3.0, 4.0)
local p2 = ffi.new("Point", 1.0, 2.0)
local p3 = p1 + p2

print("  p1 = " .. tostring(p1))
print("  p2 = " .. tostring(p2))
print("  p1 + p2 = " .. tostring(p3))
print("  |p1| = " .. string.format("%.2f", math.sqrt(p1.x * p1.x + p1.y * p1.y)))
print()

-- 演示 6: C 数组操作
print("[演示 6] C 数组操作")
print("-" * 40)

-- 创建 C 数组
local arr = ffi.new("int[10]")
for i = 0, 9 do
    arr[i] = (i + 1) * (i + 1)  -- 平方数
end

-- 输出数组
io.write("  数组内容: ")
for i = 0, 9 do
    io.write(tostring(arr[i]))
    if i < 9 then io.write(", ") end
end
print()
print()

-- 演示 7: 回调函数（FFI 回调）
print("[演示 7] FFI 回调函数")
print("-" * 40)

local callback_count = 0
local cb = ffi.cast("int (*)(int)", function(n)
    callback_count = callback_count + 1
    return n * n
end)

print("  调用回调函数计算平方:")
for i = 1, 5 do
    local result = cb(i)
    print(string.format("    %d^2 = %d", i, result))
end
print(string.format("  回调函数被调用 %d 次", callback_count))

-- 释放回调
cb:free()
print()

print("========================================")
print("  FFI 演示完成")
print("========================================")

os.exit(0)
