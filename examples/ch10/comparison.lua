-- comparison.lua - Lua socket库示例
-- 功能：演示使用Lua socket库进行HTTP请求
-- 对比：与CMD curl命令的对比
-- 
-- 依赖：需要安装luasocket: luarocks install luasocket

-- 加载socket库
local http = require("socket.http")
local ltn12 = require("ltn12")
local url = require("socket.url")

-- 辅助函数：打印分隔线
local function print_separator()
    print(string.rep("-", 50))
end

-- 辅助函数：打印标题
local function print_title(title)
    print(string.rep("=", 50))
    print(title)
    print(string.rep("=", 50))
    print()
end

-- 1. GET请求示例
local function demo_get()
    print("[1] GET请求示例")
    print_separator()
    
    -- 基本GET请求
    local response_body = {}
    local res, code, headers, status = http.request{
        url = "http://httpbin.org/get",
        sink = ltn12.sink.table(response_body)
    }
    
    if res then
        print("状态码: " .. code)
        print("状态: " .. (status or "N/A"))
        print("响应长度: " .. #table.concat(response_body) .. " 字节")
        print("响应内容（前200字符）:")
        print(table.concat(response_body):sub(1, 200) .. "...")
    else
        print("请求失败: " .. (code or "未知错误"))
    end
    print()
    
    -- 带参数的GET请求
    print("带参数的GET请求:")
    local params = "name=test&value=123"
    local full_url = "http://httpbin.org/get?" .. params
    
    response_body = {}
    res, code, headers, status = http.request{
        url = full_url,
        sink = ltn12.sink.table(response_body)
    }
    
    if res then
        print("完整URL: " .. full_url)
        print("状态码: " .. code)
    else
        print("请求失败: " .. (code or "未知错误"))
    end
    print()
end

-- 2. POST请求示例
local function demo_post()
    print("[2] POST请求示例")
    print_separator()
    
    -- JSON数据POST
    local json_data = '{"username":"admin","password":"secret123","email":"admin@example.com"}'
    
    local response_body = {}
    local res, code, headers, status = http.request{
        url = "http://httpbin.org/post",
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json",
            ["Content-Length"] = tostring(#json_data)
        },
        source = ltn12.source.string(json_data),
        sink = ltn12.sink.table(response_body)
    }
    
    if res then
        print("JSON POST状态码: " .. code)
        print("提交的数据: " .. json_data)
        print("响应内容（前200字符）:")
        print(table.concat(response_body):sub(1, 200) .. "...")
    else
        print("请求失败: " .. (code or "未知错误"))
    end
    print()
    
    -- 表单数据POST
    local form_data = "username=admin&password=secret123"
    
    response_body = {}
    res, code, headers, status = http.request{
        url = "http://httpbin.org/post",
        method = "POST",
        headers = {
            ["Content-Type"] = "application/x-www-form-urlencoded",
            ["Content-Length"] = tostring(#form_data)
        },
        source = ltn12.source.string(form_data),
        sink = ltn12.sink.table(response_body)
    }
    
    if res then
        print("表单POST状态码: " .. code)
    else
        print("请求失败: " .. (code or "未知错误"))
    end
    print()
end

-- 3. 设置请求头示例
local function demo_headers()
    print("[3] 设置请求头示例")
    print_separator()
    
    local response_body = {}
    local res, code, headers, status = http.request{
        url = "http://httpbin.org/get",
        headers = {
            ["User-Agent"] = "Lua-Tutorial/1.0",
            ["Accept"] = "application/json",
            ["Authorization"] = "Bearer test_token_12345"
        },
        sink = ltn12.sink.table(response_body)
    }
    
    if res then
        print("状态码: " .. code)
        print("请求头已设置: User-Agent, Accept, Authorization")
        print("响应内容（前200字符）:")
        print(table.concat(response_body):sub(1, 200) .. "...")
    else
        print("请求失败: " .. (code or "未知错误"))
    end
    print()
end

-- 4. 文件下载示例
local function demo_download()
    print("[4] 文件下载示例")
    print_separator()
    
    -- 下载到文件
    local filename = "downloaded_file.bin"
    local file = io.open(filename, "wb")
    
    if file then
        local res, code, headers, status = http.request{
            url = "http://httpbin.org/bytes/1024",
            sink = ltn12.sink.file(file)
        }
        
        file:close()
        
        if res then
            print("文件下载成功")
            print("状态码: " .. code)
            print("文件已保存到: " .. filename)
            
            -- 获取文件大小
            local file_info = io.open(filename, "rb")
            if file_info then
                local size = file_info:seek("end")
                file_info:close()
                print("文件大小: " .. size .. " 字节")
            end
        else
            print("下载失败: " .. (code or "未知错误"))
        end
    else
        print("无法创建文件: " .. filename)
    end
    print()
end

-- 5. 错误处理示例
local function demo_error_handling()
    print("[5] 错误处理示例")
    print_separator()
    
    -- 测试不存在的URL
    local response_body = {}
    local res, code, headers, status = http.request{
        url = "http://nonexistent.example.com/",
        sink = ltn12.sink.table(response_body),
        timeout = 5  -- 5秒超时
    }
    
    if not res then
        print("连接错误: 无法连接到服务器")
        print("错误代码: " .. (code or "未知"))
    end
    print()
    
    -- 测试超时
    print("测试超时（5秒）:")
    response_body = {}
    res, code, headers, status = http.request{
        url = "http://httpbin.org/delay/10",
        sink = ltn12.sink.table(response_body),
        timeout = 5
    }
    
    if not res then
        print("请求超时或失败")
        print("错误代码: " .. (code or "未知"))
    end
    print()
end

-- 6. 会话保持示例
local function demo_session()
    print("[6] 会话保持示例")
    print_separator()
    
    -- 注意：Lua的socket.http不支持会话保持
    -- 但我们可以手动管理cookies
    
    print("注意：Lua socket.http不支持自动会话保持")
    print("需要手动管理cookies或使用其他HTTP库")
    print()
    
    -- 示例：手动传递cookies
    local cookies = {}
    
    -- 第一个请求：获取cookies
    local response_body = {}
    local res, code, headers, status = http.request{
        url = "http://httpbin.org/cookies/set/session_id/abc123",
        redirect = false,  -- 不自动重定向
        sink = ltn12.sink.table(response_body)
    }
    
    if headers then
        -- 从响应头中提取cookies
        local set_cookie = headers["set-cookie"]
        if set_cookie then
            print("收到Cookie: " .. set_cookie)
        end
    end
    print()
end

-- 7. 重定向处理
local function demo_redirect()
    print("[7] 重定向处理示例")
    print_separator()
    
    -- 跟随重定向（默认行为）
    local response_body = {}
    local res, code, headers, status = http.request{
        url = "http://httpbin.org/redirect/2",
        sink = ltn12.sink.table(response_body)
    }
    
    if res then
        print("跟随重定向:")
        print("最终状态码: " .. code)
        print("响应长度: " .. #table.concat(response_body) .. " 字节")
    else
        print("请求失败: " .. (code or "未知错误"))
    end
    print()
    
    -- 不跟随重定向
    response_body = {}
    res, code, headers, status = http.request{
        url = "http://httpbin.org/redirect/2",
        redirect = false,
        sink = ltn12.sink.table(response_body)
    }
    
    if res then
        print("不跟随重定向:")
        print("状态码: " .. code)
        if headers and headers.location then
            print("重定向到: " .. headers.location)
        end
    else
        print("请求失败: " .. (code or "未知错误"))
    end
    print()
end

-- 8. 批量请求示例
local function demo_batch_requests()
    print("[8] 批量请求示例")
    print_separator()
    
    local urls = {
        "http://httpbin.org/get",
        "http://httpbin.org/ip",
        "http://httpbin.org/user-agent"
    }
    
    local results = {}
    
    for i, url in ipairs(urls) do
        local response_body = {}
        local res, code, headers, status = http.request{
            url = url,
            sink = ltn12.sink.table(response_body)
        }
        
        results[i] = {
            url = url,
            success = res ~= nil,
            code = code,
            size = #table.concat(response_body)
        }
    end
    
    print("批量请求结果:")
    for i, result in ipairs(results) do
        print(string.format("  %d. %s", i, result.url))
        if result.success then
            print(string.format("     状态: %d, 大小: %d 字节", result.code, result.size))
        else
            print("     失败: " .. (result.code or "未知错误"))
        end
    end
    print()
end

-- 9. 与CMD curl对比
local function compare_with_curl()
    print("[9] 与CMD curl对比")
    print_separator()
    
    print("GET请求:")
    print("  Lua:  http.request{url = \"http://httpbin.org/get\", sink = ...}")
    print("  CMD:  curl https://httpbin.org/get")
    print()
    
    print("POST请求:")
    print("  Lua:  http.request{url = \"...\", method = \"POST\", source = ...}")
    print("  CMD:  curl -X POST url -d \"data\"")
    print()
    
    print("设置头:")
    print("  Lua:  http.request{url = \"...\", headers = {\"User-Agent\" = \"test\"}}")
    print("  CMD:  curl -H \"User-Agent: test\" url")
    print()
    
    print("超时:")
    print("  Lua:  http.request{url = \"...\", timeout = 5}")
    print("  CMD:  curl --connect-timeout 5 url")
    print()
    
    print("文件下载:")
    print("  Lua:  http.request{url = \"...\", sink = ltn12.sink.file(file)}")
    print("  CMD:  curl -o file.txt url")
    print()
    
    print("错误处理:")
    print("  Lua:  检查http.request返回值")
    print("  CMD:  if errorlevel 1 echo 错误")
    print()
end

-- 主函数
local function main()
    print("Lua socket库示例")
    print("对比CMD curl命令")
    print()
    
    print_title("HTTP请求示例")
    
    -- 运行所有示例
    demo_get()
    demo_post()
    demo_headers()
    demo_download()
    demo_error_handling()
    demo_session()
    demo_redirect()
    demo_batch_requests()
    compare_with_curl()
    
    print_title("示例完成")
end

-- 运行主函数
main()