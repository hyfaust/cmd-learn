/**
 * comparison.js - JavaScript fetch/axios示例
 * 功能：演示使用JavaScript fetch和axios进行HTTP请求
 * 对比：与CMD curl命令的对比
 * 
 * 注意：需要Node.js环境，axios需要安装: npm install axios
 */

// 使用fetch API（现代浏览器和Node.js 18+内置）
async function fetchExample() {
    console.log("=" .repeat(50));
    console.log("JavaScript fetch API示例");
    console.log("=" .repeat(50));
    console.log();
    
    // 1. GET请求
    console.log("[1] GET请求示例");
    console.log("-".repeat(30));
    
    try {
        // 基本GET请求
        const response = await fetch('https://httpbin.org/get');
        const data = await response.json();
        
        console.log(`状态码: ${response.status}`);
        console.log(`响应头: ${response.headers.get('Content-Type')}`);
        console.log(`响应数据: ${JSON.stringify(data).substring(0, 200)}...`);
    } catch (error) {
        console.error(`请求错误: ${error.message}`);
    }
    console.log();
    
    // 2. 带参数的GET请求
    console.log("[2] 带参数的GET请求");
    console.log("-".repeat(30));
    
    const params = new URLSearchParams({
        name: 'test',
        value: '123'
    });
    
    try {
        const response = await fetch(`https://httpbin.org/get?${params}`);
        const data = await response.json();
        
        console.log(`完整URL: ${data.url}`);
        console.log(`状态码: ${response.status}`);
    } catch (error) {
        console.error(`请求错误: ${error.message}`);
    }
    console.log();
    
    // 3. POST请求（JSON数据）
    console.log("[3] POST请求示例");
    console.log("-".repeat(30));
    
    const postData = {
        username: 'admin',
        password: 'secret123',
        email: 'admin@example.com'
    };
    
    try {
        const response = await fetch('https://httpbin.org/post', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(postData)
        });
        
        const data = await response.json();
        console.log(`状态码: ${response.status}`);
        console.log(`提交的数据: ${JSON.stringify(data.json)}`);
    } catch (error) {
        console.error(`请求错误: ${error.message}`);
    }
    console.log();
    
    // 4. 设置请求头
    console.log("[4] 设置请求头示例");
    console.log("-".repeat(30));
    
    try {
        const response = await fetch('https://httpbin.org/get', {
            headers: {
                'User-Agent': 'JavaScript-Tutorial/1.0',
                'Accept': 'application/json',
                'Authorization': 'Bearer test_token_12345'
            }
        });
        
        const data = await response.json();
        console.log(`状态码: ${response.status}`);
        console.log(`请求头已设置: User-Agent, Accept, Authorization`);
    } catch (error) {
        console.error(`请求错误: ${error.message}`);
    }
    console.log();
    
    // 5. 文件下载
    console.log("[5] 文件下载示例");
    console.log("-".repeat(30));
    
    try {
        const response = await fetch('https://httpbin.org/bytes/1024');
        const buffer = await response.arrayBuffer();
        
        console.log(`文件大小: ${buffer.byteLength} 字节`);
        console.log(`状态码: ${response.status}`);
        
        // 注意：在Node.js中可以使用fs模块保存文件
        // 在浏览器中可以使用Blob和URL.createObjectURL
    } catch (error) {
        console.error(`下载错误: ${error.message}`);
    }
    console.log();
    
    // 6. 错误处理
    console.log("[6] 错误处理示例");
    console.log("-".repeat(30));
    
    try {
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), 3000); // 3秒超时
        
        const response = await fetch('https://nonexistent.example.com', {
            signal: controller.signal
        });
        
        clearTimeout(timeoutId);
    } catch (error) {
        if (error.name === 'AbortError') {
            console.log("请求超时");
        } else if (error.message.includes('Failed to fetch')) {
            console.log("连接错误: 无法连接到服务器");
        } else {
            console.log(`请求错误: ${error.message}`);
        }
    }
    console.log();
    
    // 7. 响应处理
    console.log("[7] 响应处理示例");
    console.log("-".repeat(30));
    
    try {
        const response = await fetch('https://httpbin.org/get');
        
        console.log(`状态码: ${response.status}`);
        console.log(`是否成功: ${response.ok}`);
        console.log(`内容类型: ${response.headers.get('Content-Type')}`);
        
        // 检查响应类型
        const contentType = response.headers.get('Content-Type');
        if (contentType && contentType.includes('application/json')) {
            const data = await response.json();
            console.log(`JSON数据: ${JSON.stringify(data)}`);
        }
    } catch (error) {
        console.error(`响应处理错误: ${error.message}`);
    }
    console.log();
    
    // 8. 批量请求
    console.log("[8] 批量请求示例");
    console.log("-".repeat(30));
    
    const urls = [
        'https://httpbin.org/get',
        'https://httpbin.org/ip',
        'https://httpbin.org/user-agent'
    ];
    
    try {
        const results = await Promise.all(
            urls.map(async url => {
                const response = await fetch(url);
                const data = await response.json();
                return {
                    url: url,
                    status: response.status,
                    data: data
                };
            })
        );
        
        results.forEach(result => {
            console.log(`URL: ${result.url}`);
            console.log(`  状态: ${result.status}`);
        });
    } catch (error) {
        console.error(`批量请求错误: ${error.message}`);
    }
    console.log();
}

// 使用axios库（需要安装：npm install axios）
async function axiosExample() {
    console.log("=" .repeat(50));
    console.log("JavaScript axios库示例");
    console.log("=" .repeat(50));
    console.log();
    
    // 动态导入axios（如果可用）
    let axios;
    try {
        axios = require('axios');
    } catch (error) {
        console.log("axios未安装，跳过axios示例");
        console.log("安装命令: npm install axios");
        console.log();
        return;
    }
    
    // 1. GET请求
    console.log("[1] axios GET请求");
    console.log("-".repeat(30));
    
    try {
        const response = await axios.get('https://httpbin.org/get');
        console.log(`状态码: ${response.status}`);
        console.log(`响应数据: ${JSON.stringify(response.data).substring(0, 200)}...`);
    } catch (error) {
        console.error(`请求错误: ${error.message}`);
    }
    console.log();
    
    // 2. POST请求
    console.log("[2] axios POST请求");
    console.log("-".repeat(30));
    
    try {
        const response = await axios.post('https://httpbin.org/post', {
            username: 'admin',
            password: 'secret123'
        });
        
        console.log(`状态码: ${response.status}`);
        console.log(`提交的数据: ${JSON.stringify(response.data.json)}`);
    } catch (error) {
        console.error(`请求错误: ${error.message}`);
    }
    console.log();
    
    // 3. 设置默认配置
    console.log("[3] axios默认配置");
    console.log("-".repeat(30));
    
    const api = axios.create({
        baseURL: 'https://httpbin.org',
        timeout: 5000,
        headers: {
            'User-Agent': 'JavaScript-Axios/1.0',
            'Accept': 'application/json'
        }
    });
    
    try {
        const response = await api.get('/get');
        console.log(`状态码: ${response.status}`);
        console.log(`请求头已设置: User-Agent, Accept`);
    } catch (error) {
        console.error(`请求错误: ${error.message}`);
    }
    console.log();
    
    // 4. 拦截器
    console.log("[4] axios拦截器");
    console.log("-".repeat(30));
    
    // 请求拦截器
    api.interceptors.request.use(config => {
        console.log(`发送请求: ${config.method.toUpperCase()} ${config.url}`);
        return config;
    });
    
    // 响应拦截器
    api.interceptors.response.use(response => {
        console.log(`收到响应: ${response.status} ${response.config.url}`);
        return response;
    });
    
    try {
        await api.get('/get');
    } catch (error) {
        console.error(`请求错误: ${error.message}`);
    }
    console.log();
}

// 与CMD curl对比
function compareWithCurl() {
    console.log("=" .repeat(50));
    console.log("与CMD curl对比");
    console.log("=" .repeat(50));
    console.log();
    
    console.log("GET请求:");
    console.log("  JavaScript: fetch('https://httpbin.org/get')");
    console.log("  CMD:        curl https://httpbin.org/get");
    console.log();
    
    console.log("POST请求:");
    console.log("  JavaScript: fetch(url, { method: 'POST', body: JSON.stringify(data) })");
    console.log("  CMD:        curl -X POST url -H \"Content-Type: application/json\" -d \"{}\"");
    console.log();
    
    console.log("设置头:");
    console.log("  JavaScript: fetch(url, { headers: { 'User-Agent': 'test' } })");
    console.log("  CMD:        curl -H \"User-Agent: test\" url");
    console.log();
    
    console.log("超时:");
    console.log("  JavaScript: fetch(url, { signal: AbortSignal.timeout(5000) })");
    console.log("  CMD:        curl --connect-timeout 5 url");
    console.log();
    
    console.log("错误处理:");
    console.log("  JavaScript: try { ... } catch (error) { ... }");
    console.log("  CMD:        if errorlevel 1 echo 错误");
    console.log();
}

// 主函数
async function main() {
    console.log("JavaScript HTTP请求示例");
    console.log("对比CMD curl命令");
    console.log();
    
    // 运行fetch示例
    await fetchExample();
    
    // 运行axios示例
    await axiosExample();
    
    // 显示对比
    compareWithCurl();
    
    console.log("=" .repeat(50));
    console.log("示例完成");
    console.log("=" .repeat(50));
}

// 运行主函数
main().catch(console.error);