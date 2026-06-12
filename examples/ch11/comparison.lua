-- comparison.lua
-- Lua 进程管理对比
-- 使用 os.execute 和 io.popen 实现与 CMD 类似的功能
-- 运行: lua comparison.lua

local M = {}

-- 获取操作系统类型
local function get_os()
    if package.config:sub(1,1) == "\\" then
        return "windows"
    else
        return "unix"
    end
end

local current_os = get_os()

-- 辅助函数：执行命令并获取输出
local function execute_command(cmd)
    local handle = io.popen(cmd)
    if handle then
        local result = handle:read("*a")
        handle:close()
        return result
    end
    return nil
end

-- 辅助函数：执行命令（无输出）
local function run_command(cmd)
    return os.execute(cmd)
end

--- 获取系统信息 - 对比 CMD 的 systeminfo
function M.get_system_info()
    print("=" .. string.rep("=", 59))
    print("系统信息 (对比 systeminfo)")
    print("=" .. string.rep("=", 59))
    print()
    
    if current_os == "windows" then
        print("[Windows 系统信息]")
        print()
        
        -- 获取计算机名
        local hostname = execute_command("hostname")
        if hostname then
            print("计算机名: " .. hostname:gsub("%s+", ""))
        end
        
        -- 获取OS版本
        print("\n操作系统信息:")
        local os_info = execute_command('wmic os get caption,version /format:list 2>nul')
        if os_info then
            for line in os_info:gmatch("[^\r\n]+") do
                if line:match("^Caption=") then
                    print("  " .. line)
                elseif line:match("^Version=") then
                    print("  " .. line)
                end
            end
        end
        
        -- 获取CPU信息
        print("\nCPU信息:")
        local cpu_info = execute_command('wmic cpu get name,numberofcores /format:list 2>nul')
        if cpu_info then
            for line in cpu_info:gmatch("[^\r\n]+") do
                if line:match("^Name=") or line:match("^NumberOfCores=") then
                    print("  " .. line)
                end
            end
        end
        
        -- 获取内存信息
        print("\n内存信息:")
        local mem_info = execute_command('wmic memorychip get capacity /format:list 2>nul')
        if mem_info then
            local total = 0
            for capacity in mem_info:gmatch("Capacity=(%d+)") do
                total = total + tonumber(capacity)
            end
            if total > 0 then
                print(string.format("  总内存: %.2f GB", total / 1073741824))
            end
        end
        
    else
        print("[Unix/Linux 系统信息]")
        print()
        
        -- 获取系统信息
        print("系统信息:")
        local uname = execute_command("uname -a")
        if uname then
            print("  " .. uname:gsub("%s+$", ""))
        end
        
        -- 获取CPU信息
        print("\nCPU信息:")
        local cpu_info = execute_command("lscpu 2>/dev/null || sysctl -n machdep.cpu.brand_string 2>/dev/null")
        if cpu_info then
            print("  " .. cpu_info:gsub("%s+$", ""))
        end
        
        -- 获取内存信息
        print("\n内存信息:")
        local mem_info = execute_command("free -h 2>/dev/null || vm_stat 2>/dev/null")
        if mem_info then
            print(mem_info)
        end
    end
end

--- 获取进程列表 - 对比 CMD 的 tasklist
function M.get_process_list()
    print("\n" .. "=" .. string.rep("=", 59))
    print("进程列表 (对比 tasklist)")
    print("=" .. string.rep("=", 59))
    print()
    
    if current_os == "windows" then
        local output = execute_command("tasklist /fo TABLE")
        if output then
            -- 显示前25行
            local count = 0
            for line in output:gmatch("[^\r\n]+") do
                if count < 25 then
                    print(line)
                    count = count + 1
                else
                    break
                end
            end
            print("\n... (显示前25行)")
        end
    else
        local output = execute_command("ps aux")
        if output then
            local count = 0
            for line in output:gmatch("[^\r\n]+") do
                if count < 25 then
                    print(line)
                    count = count + 1
                else
                    break
                end
            end
        end
    end
end

--- 查找特定进程 - 对比 CMD 的 tasklist /fi
function M.find_process(process_name)
    print("\n查找进程: " .. process_name)
    print(string.rep("-", 60))
    
    if current_os == "windows" then
        local cmd = string.format('tasklist /fi "imagename eq %s" /fo TABLE', process_name)
        local output = execute_command(cmd)
        
        if output then
            local found = false
            for line in output:gmatch("[^\r\n]+") do
                if line:find(process_name, 1, true) then
                    print(line)
                    found = true
                end
            end
            if not found then
                print("未找到进程: " .. process_name)
            end
        end
    else
        local cmd = string.format("pgrep -l %s", process_name)
        local output = execute_command(cmd)
        
        if output and output ~= "" then
            print("找到进程:")
            print(output)
        else
            print("未找到进程: " .. process_name)
        end
    end
end

--- 终止进程 - 对比 CMD 的 taskkill
--- 注意: 仅演示安全的终止方法
function M.kill_process(pid, force)
    print("\n终止进程 PID: " .. pid)
    print(string.rep("-", 60))
    
    local cmd
    if current_os == "windows" then
        if force then
            cmd = string.format("taskkill /pid %d /f", pid)
        else
            cmd = string.format("taskkill /pid %d", pid)
        end
    else
        if force then
            cmd = string.format("kill -9 %d", pid)
        else
            cmd = string.format("kill %d", pid)
        end
    end
    
    print("执行命令: " .. cmd)
    print("[模拟] 命令已准备，实际执行需要确认")
    
    -- 安全起见，仅显示命令不执行
    -- 如果需要实际执行，取消下面的注释
    -- run_command(cmd)
end

--- 获取服务列表 - 对比 CMD 的 sc query
function M.get_service_list()
    print("\n" .. "=" .. string.rep("=", 59))
    print("服务列表 (对比 sc query)")
    print("=" .. string.rep("=", 59))
    print()
    
    if current_os == "windows" then
        local output = execute_command("sc query state= all")
        if output then
            local current_service = ""
            local current_state = ""
            
            for line in output:gmatch("[^\r\n]+") do
                local service_name = line:match("SERVICE_NAME:%s*(.+)")
                if service_name then
                    current_service = service_name:match("^%s*(.-)%s*$")
                end
                
                local state = line:match("STATE:%s*(.+)")
                if state and current_service ~= "" then
                    current_state = state:match("^%s*(.-)%s*$")
                    print(string.format("  %-40s %s", current_service, current_state))
                    current_service = ""
                    current_state = ""
                end
            end
        end
    else
        print("执行: systemctl list-units --type=service")
        local output = execute_command("systemctl list-units --type=service 2>/dev/null")
        if output then
            local count = 0
            for line in output:gmatch("[^\r\n]+") do
                if count < 30 then
                    print(line)
                    count = count + 1
                end
            end
        end
    end
end

--- 使用 wmic 获取详细进程信息
function M.get_process_details_wmic()
    print("\n" .. "=" .. string.rep("=", 59))
    print("进程详细信息 (使用 WMIC)")
    print("=" .. string.rep("=", 59))
    print()
    
    if current_os ~= "windows" then
        print("WMIC 仅适用于 Windows 系统")
        return
    end
    
    local output = execute_command('wmic process get name,processid,parentprocessid /format:csv')
    if output then
        print(string.format("%-25s %-15s %s", "名称", "PID", "父PID"))
        print(string.rep("-", 60))
        
        local count = 0
        for line in output:gmatch("[^\r\n]+") do
            -- 跳过标题行
            if not line:match("^Node") and not line:match("^Name") and count < 20 then
                -- 解析 CSV 格式
                local parts = {}
                for part in line:gmatch("([^,]+)") do
                    table.insert(parts, part)
                end
                
                if #parts >= 4 then
                    print(string.format("%-25s %-15s %s", 
                          parts[2] or "N/A", 
                          parts[3] or "N/A", 
                          parts[4] or "N/A"))
                end
                count = count + 1
            end
        end
    end
end

--- 监控进程 - 对比 CMD 的进程监控脚本
function M.monitor_process(process_name, interval, duration)
    interval = interval or 5
    duration = duration or 30
    
    print("\n开始监控进程: " .. process_name)
    print("监控间隔: " .. interval .. " 秒")
    print("监控时长: " .. duration .. " 秒")
    print(string.rep("-", 60))
    
    local start_time = os.time()
    local check_count = 0
    
    while os.time() - start_time < duration do
        check_count = check_count + 1
        
        -- 获取当前时间
        local current_time = os.date("%H:%M:%S")
        
        -- 检查进程是否存在
        local cmd
        if current_os == "windows" then
            cmd = string.format('tasklist /fi "imagename eq %s" | find "%s" >nul 2>&1',
                               process_name, process_name)
        else
            cmd = string.format("pgrep %s > /dev/null 2>&1", process_name)
        end
        
        local result = run_command(cmd)
        
        if result then
            print(string.format("[%s] 运行中 (检查 #%d)", current_time, check_count))
        else
            print(string.format("[%s] 未运行 (检查 #%d)", current_time, check_count))
        end
        
        -- 等待指定间隔
        if current_os == "windows" then
            run_command(string.format("timeout /t %d >nul", interval))
        else
            run_command(string.format("sleep %d", interval))
        end
    end
    
    print(string.format("\n监控结束，共检查 %d 次", check_count))
end

--- 生成进程报告
function M.generate_report()
    print("\n" .. "=" .. string.rep("=", 59))
    print("生成进程报告")
    print("=" .. string.rep("=", 59))
    print()
    
    local report_file = "process_report.txt"
    local report = io.open(report_file, "w")
    
    if not report then
        print("无法创建报告文件: " .. report_file)
        return
    end
    
    -- 写入报告头
    report:write("进程报告\n")
    report:write("生成时间: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n")
    report:write(string.rep("=", 60) .. "\n\n")
    
    -- 写入进程列表
    report:write("进程列表:\n")
    report:write(string.rep("-", 60) .. "\n")
    
    if current_os == "windows" then
        local output = execute_command("tasklist /fo CSV")
        if output then
            report:write(output)
        end
    else
        local output = execute_command("ps aux")
        if output then
            report:write(output)
        end
    end
    
    -- 写入服务列表
    report:write("\n\n服务列表:\n")
    report:write(string.rep("-", 60) .. "\n")
    
    if current_os == "windows" then
        local output = execute_command("sc query state= all")
        if output then
            report:write(output)
        end
    end
    
    report:close()
    print("报告已保存到: " .. report_file)
end

--- 主函数 - 演示各种功能
function main()
    print("Lua 进程管理演示")
    print("对比 CMD 的 tasklist, taskkill, systeminfo 等命令")
    print("操作系统: " .. current_os)
    print()
    
    -- 1. 获取系统信息
    M.get_system_info()
    
    -- 2. 获取进程列表
    M.get_process_list()
    
    -- 3. 查找特定进程
    if current_os == "windows" then
        M.find_process("explorer.exe")
    else
        M.find_process("bash")
    end
    
    -- 4. 获取服务列表
    M.get_service_list()
    
    -- 5. 获取详细进程信息
    M.get_process_details_wmic()
    
    -- 6. 演示进程终止（仅显示命令）
    M.kill_process(1234, false)
    
    -- 7. 生成报告
    M.generate_report()
    
    print("\n" .. "=" .. string.rep("=", 59))
    print("演示完成")
    print("=" .. string.rep("=", 59))
end

-- 运行主函数
main()

-- 返回模块（如果需要作为模块使用）
return M
