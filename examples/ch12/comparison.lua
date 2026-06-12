-- comparison.lua - Lua定时器模拟实现对比
-- 本脚本展示Lua中任务调度的多种实现方式
-- 包括LuaSocket、系统调用和纯Lua实现

-- ============================================================
-- 方法1: 使用LuaSocket的sleep功能
-- ============================================================

function socket_timer_demo()
    print("\n=== LuaSocket定时器演示 ===")
    
    -- 尝试加载LuaSocket
    local ok, socket = pcall(require, "socket")
    if not ok then
        print("LuaSocket未安装，使用模拟实现")
        -- 模拟socket.sleep
        socket = {
            sleep = function(seconds)
                -- 在真实环境中，这里会暂停执行
                print(string.format("模拟等待 %.1f 秒...", seconds))
            end,
            gettime = function()
                return os.clock()
            end
        }
    end
    
    -- 基本延时函数
    local function delay(seconds)
        socket.sleep(seconds)
    end
    
    -- 定时任务执行
    local function run_with_delay(func, delay_seconds, count)
        print(string.format("执行任务，间隔 %.1f 秒，共 %d 次", delay_seconds, count))
        
        for i = 1, count do
            local start_time = socket.gettime()
            func(i)
            local elapsed = socket.gettime() - start_time
            print(string.format("  任务执行耗时: %.3f 秒", elapsed))
            
            if i < count then
                delay(delay_seconds)
            end
        end
    end
    
    -- 示例任务
    local function sample_task(iteration)
        print(string.format("  [任务执行] 第 %d 次迭代", iteration))
    end
    
    -- 运行演示
    run_with_delay(sample_task, 0.5, 3)
    
    print("LuaSocket定时器演示完成")
end

-- ============================================================
-- 方法2: 使用os.clock实现高精度计时
-- ============================================================

function os_clock_demo()
    print("\n=== os.clock高精度计时演示 ===")
    
    -- 高精度延时函数（忙等待）
    local function busy_wait(seconds)
        local start = os.clock()
        while os.clock() - start < seconds do
            -- 忙等待
        end
    end
    
    -- 定时任务执行（高精度）
    local function run_precise(func, interval, duration)
        print(string.format("精确计时任务，间隔 %.3f 秒，持续 %.1f 秒", interval, duration))
        
        local start_time = os.clock()
        local next_run = start_time + interval
        local run_count = 0
        
        while os.clock() - start_time < duration do
            if os.clock() >= next_run then
                run_count = run_count + 1
                func(run_count)
                next_run = next_run + interval
            end
            -- 短暂休息以减少CPU使用
            busy_wait(0.001)
        end
        
        print(string.format("  总执行次数: %d", run_count))
    end
    
    -- 示例任务
    local function precise_task(iteration)
        print(string.format("  [精确任务] 第 %d 次执行 (时间: %.3f)", iteration, os.clock()))
    end
    
    -- 运行演示（2秒内每0.3秒执行一次）
    run_precise(precise_task, 0.3, 2.0)
    
    print("高精度计时演示完成")
end

-- ============================================================
-- 方法3: 使用协程实现协作式调度
-- ============================================================

function coroutine_demo()
    print("\n=== 协程调度演示 ===")
    
    -- 协程调度器
    local scheduler = {
        tasks = {},
        current_time = 0,
        running = false
    }
    
    -- 添加任务
    function scheduler:add_task(name, func, interval)
        table.insert(self.tasks, {
            name = name,
            func = func,
            interval = interval,
            last_run = 0,
            coroutine = nil,
            finished = false
        })
        print(string.format("已添加任务: %s (间隔: %.1f秒)", name, interval))
    end
    
    -- 运行调度器
    function scheduler:run(duration)
        self.running = true
        local start_time = os.clock()
        
        print("协程调度器开始运行...")
        
        while self.running do
            self.current_time = os.clock() - start_time
            
            -- 检查是否超过运行时间
            if duration and self.current_time >= duration then
                self.running = false
                break
            end
            
            -- 处理任务
            for _, task in ipairs(self.tasks) do
                if not task.finished then
                    if self.current_time - task.last_run >= task.interval then
                        -- 创建或恢复协程
                        if not task.coroutine then
                            task.coroutine = coroutine.create(task.func)
                        end
                        
                        local status, result = coroutine.resume(task.coroutine, self.current_time)
                        
                        if status then
                            task.last_run = self.current_time
                            
                            -- 检查协程是否结束
                            if coroutine.status(task.coroutine) == "dead" then
                                task.finished = true
                            end
                        else
                            print(string.format("任务 %s 执行错误: %s", task.name, result))
                            task.finished = true
                        end
                    end
                end
            end
            
            -- 检查是否所有任务都完成
            local all_finished = true
            for _, task in ipairs(self.tasks) do
                if not task.finished then
                    all_finished = false
                    break
                end
            end
            
            if all_finished then
                self.running = false
            end
        end
        
        print("协程调度器已停止")
    end
    
    -- 示例任务（协程）
    local function coroutine_task_1(time)
        for i = 1, 3 do
            print(string.format("  [协程任务1] 第 %d 次执行 (时间: %.2f)", i, time))
            coroutine.yield()
        end
    end
    
    local function coroutine_task_2(time)
        for i = 1, 2 do
            print(string.format("  [协程任务2] 第 %d 次执行 (时间: %.2f)", i, time))
            coroutine.yield()
        end
    end
    
    -- 添加任务
    scheduler:add_task("任务A", coroutine_task_1, 0.5)
    scheduler:add_task("任务B", coroutine_task_2, 0.8)
    
    -- 运行调度器（3秒）
    scheduler:run(3.0)
    
    print("协程调度演示完成")
end

-- ============================================================
-- 方法4: 使用回调函数实现简单调度
-- ============================================================

function callback_demo()
    print("\n=== 回调函数调度演示 ===")
    
    -- 简单调度器
    local function simple_scheduler(tasks, duration)
        local start_time = os.clock()
        local current_time = 0
        
        print("简单调度器开始运行...")
        
        while current_time < duration do
            current_time = os.clock() - start_time
            
            for _, task in ipairs(tasks) do
                local time_since_last = current_time - (task.last_run or 0)
                
                if time_since_last >= task.interval then
                    task.callback(current_time, task.name)
                    task.last_run = current_time
                end
            end
        end
        
        print("简单调度器已停止")
    end
    
    -- 定义任务
    local tasks = {
        {
            name = "任务X",
            interval = 0.5,
            callback = function(time, name)
                print(string.format("  [%s] 执行 (时间: %.2f)", name, time))
            end
        },
        {
            name = "任务Y",
            interval = 0.8,
            callback = function(time, name)
                print(string.format("  [%s] 执行 (时间: %.2f)", name, time))
            end
        },
        {
            name = "任务Z",
            interval = 1.2,
            callback = function(time, name)
                print(string.format("  [%s] 执行 (时间: %.2f)", name, time))
            end
        }
    }
    
    -- 运行调度器（2秒）
    simple_scheduler(tasks, 2.0)
    
    print("回调函数调度演示完成")
end

-- ============================================================
-- 实用工具模块
-- ============================================================

-- 任务调度器类
local TaskScheduler = {}
TaskScheduler.__index = TaskScheduler

function TaskScheduler.new()
    local self = setmetatable({}, TaskScheduler)
    self.tasks = {}
    self.running = false
    self.task_stats = {}
    return self
end

function TaskScheduler:add_task(name, func, interval, max_runs)
    if self.tasks[name] then
        error(string.format("任务 '%s' 已存在", name))
    end
    
    self.tasks[name] = {
        func = func,
        interval = interval,
        max_runs = max_runs or math.huge,
        current_runs = 0,
        last_run = 0,
        errors = {}
    }
    
    self.task_stats[name] = {
        total_runs = 0,
        total_errors = 0,
        start_time = 0
    }
    
    print(string.format("已添加任务: %s (间隔: %.1f秒, 最大执行次数: %s)", 
        name, interval, max_runs == math.huge and "无限制" or tostring(max_runs)))
    return self
end

function TaskScheduler:run(duration)
    self.running = true
    local start_time = os.clock()
    
    print("任务调度器开始运行...")
    
    -- 初始化统计信息
    for name, stats in pairs(self.task_stats) do
        stats.start_time = start_time
    end
    
    while self.running do
        local current_time = os.clock() - start_time
        
        -- 检查是否超过运行时间
        if duration and current_time >= duration then
            self.running = false
            break
        end
        
        -- 处理任务
        for name, task in pairs(self.tasks) do
            if task.current_runs < task.max_runs then
                local time_since_last = current_time - task.last_run
                
                if time_since_last >= task.interval then
                    local success, err = pcall(task.func, current_time, name)
                    
                    if success then
                        task.current_runs = task.current_runs + 1
                        self.task_stats[name].total_runs = self.task_stats[name].total_runs + 1
                    else
                        table.insert(task.errors, {
                            time = current_time,
                            error = err
                        })
                        self.task_stats[name].total_errors = self.task_stats[name].total_errors + 1
                        print(string.format("任务 '%s' 执行错误: %s", name, err))
                    end
                    
                    task.last_run = current_time
                end
            end
        end
        
        -- 检查是否所有任务都完成
        local all_finished = true
        for name, task in pairs(self.tasks) do
            if task.current_runs < task.max_runs then
                all_finished = false
                break
            end
        end
        
        if all_finished then
            self.running = false
        end
    end
    
    print("任务调度器已停止")
end

function TaskScheduler:stop()
    self.running = false
end

function TaskScheduler:get_stats()
    print("\n任务统计:")
    for name, stats in pairs(self.task_stats) do
        print(string.format("  - %s: 执行次数 %d, 错误次数 %d", 
            name, stats.total_runs, stats.total_errors))
    end
end

-- ============================================================
-- 与CMD对比分析
-- ============================================================

function comparison_analysis()
    print("\n=== Lua vs CMD 任务调度对比 ===")
    
    local comparison = {
        {
            feature = "持久化",
            cmd = "系统级持久化（任务计划程序）",
            lua = "内存级（需额外存储）"
        },
        {
            feature = "精确度",
            cmd = "分钟级",
            lua = "毫秒级"
        },
        {
            feature = "复杂调度",
            cmd = "基本（每日、每周等）",
            lua = "强大（自定义逻辑、协程）"
        },
        {
            feature = "错误处理",
            cmd = "有限",
            lua = "完整（pcall/xpcall）"
        },
        {
            feature = "性能",
            cmd = "一般",
            lua = "轻量级（解释执行）"
        },
        {
            feature = "跨平台",
            cmd = "仅Windows",
            lua = "跨平台"
        },
        {
            feature = "学习曲线",
            cmd = "简单",
            lua = "中等"
        }
    }
    
    for _, item in ipairs(comparison) do
        print(string.format("\n%s:", item.feature))
        print(string.format("  CMD: %s", item.cmd))
        print(string.format("  Lua: %s", item.lua))
    end
end

-- ============================================================
-- 主程序
-- ============================================================

function main()
    print("Lua定时器模拟实现对比")
    print(string.rep("=", 50))
    
    -- 显示对比分析
    comparison_analysis()
    
    print("\n" .. string.rep("=", 50))
    print("开始运行演示")
    print(string.rep("=", 50))
    
    -- 方法1: LuaSocket定时器
    socket_timer_demo()
    
    -- 方法2: 高精度计时
    os_clock_demo()
    
    -- 方法3: 协程调度
    coroutine_demo()
    
    -- 方法4: 回调函数调度
    callback_demo()
    
    -- 自定义调度器演示
    print("\n=== 自定义调度器演示 ===")
    
    local scheduler = TaskScheduler.new()
    
    -- 添加任务
    scheduler:add_task("任务1", function(time, name)
        print(string.format("  [%s] 执行 (时间: %.2f)", name, time))
    end, 0.5, 3)
    
    scheduler:add_task("任务2", function(time, name)
        print(string.format("  [%s] 执行 (时间: %.2f)", name, time))
    end, 0.8, 2)
    
    scheduler:add_task("任务3", function(time, name)
        print(string.format("  [%s] 执行 (时间: %.2f)", name, time))
    end, 1.0, 2)
    
    -- 运行调度器（3秒）
    scheduler:run(3.0)
    
    -- 显示统计信息
    scheduler:get_stats()
    
    print("\n" .. string.rep("=", 50))
    print("演示完成！")
    print(string.rep("=", 50))
end

-- 运行主程序
main()