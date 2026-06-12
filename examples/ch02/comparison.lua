--[[
Lua (LuaJIT) 文件操作对比示例
功能：演示Lua中与CMD等效的文件系统操作
使用模块：lfs (LuaFileSystem), os
运行：lua comparison.lua
]]

-- 检查lfs模块是否可用
local has_lfs, lfs = pcall(require, "lfs")
if not has_lfs then
    print("警告: lfs模块不可用，某些功能将使用os模块替代")
    lfs = nil
end

-- 辅助函数：创建目录（递归）
local function mkdir_recursive(path)
    if lfs then
        -- 使用lfs模块
        local parts = {}
        for part in path:gmatch("[^/\\]+") do
            table.insert(parts, part)
        end
        
        local current = ""
        for i, part in ipairs(parts) do
            if i == 1 and part:match("^%a:$") then
                current = part
            else
                current = current .. "\\" .. part
            end
            lfs.mkdir(current)
        end
    else
        -- 使用os模块
        os.execute('mkdir "' .. path .. '" 2>nul')
    end
end

-- 辅助函数：删除目录（递归）
local function rmdir_recursive(path)
    if lfs then
        for entry in lfs.dir(path) do
            if entry ~= "." and entry ~= ".." then
                local fullpath = path .. "\\" .. entry
                local attr = lfs.attributes(fullpath)
                if attr and attr.mode == "directory" then
                    rmdir_recursive(fullpath)
                else
                    os.remove(fullpath)
                end
            end
        end
        lfs.rmdir(path)
    else
        os.execute('rmdir /s /q "' .. path .. '"')
    end
end

-- 辅助函数：复制文件
local function copy_file(src, dst)
    local fin = io.open(src, "rb")
    if not fin then
        return false, "无法打开源文件"
    end
    
    local fout = io.open(dst, "wb")
    if not fout then
        fin:close()
        return false, "无法创建目标文件"
    end
    
    local content = fin:read("*a")
    fout:write(content)
    
    fin:close()
    fout:close()
    return true
end

-- 辅助函数：列出目录内容
local function list_dir(path)
    local files = {}
    local dirs = {}
    
    if lfs then
        for entry in lfs.dir(path) do
            if entry ~= "." and entry ~= ".." then
                local fullpath = path .. "\\" .. entry
                local attr = lfs.attributes(fullpath)
                if attr then
                    if attr.mode == "directory" then
                        table.insert(dirs, entry)
                    else
                        table.insert(files, entry)
                    end
                end
            end
        end
    else
        -- 使用dir命令
        local handle = io.popen('dir /b "' .. path .. '"')
        if handle then
            for line in handle:lines() do
                table.insert(files, line)
            end
            handle:close()
        end
    end
    
    return files, dirs
end

-- 主函数
local function main()
    -- 设置基准目录
    local script_dir = arg[0]:match("(.*[/\\])") or "."
    local base_dir = script_dir .. "sandbox"
    
    -- 清理可能存在的旧sandbox
    rmdir_recursive(base_dir)
    
    print("==================================================")
    print("Lua (LuaJIT) 文件操作对比示例")
    print("==================================================")
    print()
    
    -- 创建目录结构
    print("[1] 创建目录结构")
    -- CMD: mkdir dir
    mkdir_recursive(base_dir)
    mkdir_recursive(base_dir .. "\\sub1")
    mkdir_recursive(base_dir .. "\\sub2")
    mkdir_recursive(base_dir .. "\\sub1\\deep")
    print("创建完成")
    print()
    
    -- 创建测试文件
    print("[2] 创建测试文件")
    -- CMD: echo content > file.txt
    local f = io.open(base_dir .. "\\test1.txt", "w")
    if f then
        f:write("这是第一个测试文件\n")
        f:close()
    end
    
    f = io.open(base_dir .. "\\test2.txt", "w")
    if f then
        f:write("这是第二个测试文件\n")
        f:close()
    end
    
    f = io.open(base_dir .. "\\test3.txt", "w")
    if f then
        f:write("Hello World\n")
        f:close()
    end
    print("创建完成")
    print()
    
    -- 复制文件
    print("[3] 复制文件")
    -- CMD: copy src dst
    copy_file(
        base_dir .. "\\test1.txt",
        base_dir .. "\\test1_backup.txt"
    )
    print("复制: test1.txt -> test1_backup.txt")
    
    -- 批量复制
    local backup_dir = base_dir .. "\\backup"
    mkdir_recursive(backup_dir)
    
    local files = list_dir(base_dir)
    for _, file in ipairs(files) do
        if file:match("%.txt$") then
            copy_file(
                base_dir .. "\\" .. file,
                backup_dir .. "\\" .. file
            )
        end
    end
    print("批量复制完成")
    print()
    
    -- 移动文件
    print("[4] 移动文件")
    -- CMD: move src dst
    local src = base_dir .. "\\test2.txt"
    local dst = base_dir .. "\\sub1\\test2.txt"
    if copy_file(src, dst) then
        os.remove(src)
        print("移动: test2.txt -> sub1/test2.txt")
    end
    print()
    
    -- 重命名文件
    print("[5] 重命名文件")
    -- CMD: ren old new
    os.rename(
        base_dir .. "\\test3.txt",
        base_dir .. "\\test3_renamed.txt"
    )
    print("重命名: test3.txt -> test3_renamed.txt")
    print()
    
    -- 读取文件内容
    print("[6] 读取文件内容")
    -- CMD: type file.txt
    f = io.open(base_dir .. "\\test1.txt", "r")
    if f then
        local content = f:read("*a")
        f:close()
        print("test1.txt 内容: " .. content:gsub("\n$", ""))
    end
    print()
    
    -- 文件属性操作
    print("[7] 文件属性操作")
    if lfs then
        local test_file = base_dir .. "\\test1.txt"
        local attr = lfs.attributes(test_file)
        if attr then
            print(string.format("文件大小: %d 字节", attr.size))
            print(string.format("修改时间: %s", os.date("%Y-%m-%d %H:%M:%S", attr.modification)))
        end
        
        -- 设置只读属性
        -- CMD: attrib +R file.txt
        -- 注意：Lua标准库没有直接设置文件属性的函数
        -- 需要使用Windows命令或FFI
        os.execute('attrib +R "' .. test_file .. '"')
        print("设置只读属性完成")
    else
        print("文件属性操作需要lfs模块")
    end
    print()
    
    -- 遍历目录
    print("[8] 遍历目录")
    -- CMD: for /R %dir% %%f in (*.txt) do echo %%f
    if lfs then
        print("所有.txt文件:")
        local function find_files(dir, pattern)
            for entry in lfs.dir(dir) do
                if entry ~= "." and entry ~= ".." then
                    local fullpath = dir .. "\\" .. entry
                    local attr = lfs.attributes(fullpath)
                    if attr then
                        if attr.mode == "directory" then
                            find_files(fullpath, pattern)
                        elseif entry:match(pattern) then
                            print("  " .. fullpath:gsub(base_dir .. "\\", ""))
                        end
                    end
                end
            end
        end
        
        find_files(base_dir, "%.txt$")
    else
        print("目录遍历需要lfs模块")
    end
    print()
    
    -- 显示目录树
    print("[9] 目录树结构")
    if lfs then
        local function print_tree(dir, indent)
            local files, dirs = list_dir(dir)
            local all_entries = {}
            
            for _, d in ipairs(dirs) do
                table.insert(all_entries, {name = d, is_dir = true})
            end
            for _, file in ipairs(files) do
                table.insert(all_entries, {name = file, is_dir = false})
            end
            
            for i, entry in ipairs(all_entries) do
                local is_last = (i == #all_entries)
                local prefix = is_last and "└── " or "├── "
                local child_indent = is_last and "    " or "│   "
                
                print(indent .. prefix .. entry.name)
                
                if entry.is_dir then
                    print_tree(dir .. "\\" .. entry.name, indent .. child_indent)
                end
            end
        end
        
        print_tree(base_dir, "")
    else
        print("目录树显示需要lfs模块")
    end
    print()
    
    -- 删除文件
    print("[10] 删除文件")
    -- CMD: del file.txt
    os.remove(base_dir .. "\\test1_backup.txt")
    print("删除: test1_backup.txt")
    print()
    
    -- 清理sandbox目录
    print("[11] 清理sandbox目录")
    -- CMD: rmdir /s /q sandbox
    rmdir_recursive(base_dir)
    print("清理完成")
    
    print()
    print("演示结束")
end

-- 运行主函数
main()