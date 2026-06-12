// comparison.js — JavaScript for循环对比 CMD for循环
// 本文件展示JavaScript中与CMD for循环等价的实现
// 运行: node comparison.js

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

function basicListLoop() {
    // 基本列表遍历 - 对比 CMD: for %%i in (apple banana cherry) do echo %%i
    console.log("=== 基本列表遍历 ===");
    const fruits = ["apple", "banana", "cherry"];
    for (const fruit of fruits) {
        console.log(`水果: ${fruit}`);
    }
}

function numericLoop() {
    // 数值范围循环 - 对比 CMD: for /L %%i in (1,1,5) do echo %%i
    console.log("\n=== 数值范围循环 ===");
    
    // 基本循环
    for (let i = 1; i <= 5; i++) {
        console.log(`第 ${i} 次循环`);
    }
    
    // 自定义步长
    console.log("\n=== 自定义步长 ===");
    for (let i = 0; i <= 25; i += 5) {
        console.log(i);
    }
    
    // 倒序循环
    console.log("\n=== 倒序循环 ===");
    for (let i = 10; i >= 1; i--) {
        console.log(`倒计时: ${i}`);
    }
}

function stringSplit() {
    // 字符串分割 - 对比 CMD: for /F "tokens=1,2,3" %%a in ("hello world cmd")
    console.log("\n=== 字符串分割 ===");
    
    // 按空格分割
    const text = "hello world cmd";
    const parts = text.split(" ");
    parts.forEach((part, index) => {
        console.log(`第${index + 1}个: ${part}`);
    });
    
    // 按逗号分割
    console.log("\n=== 按逗号分割 ===");
    const csv = "apple,banana,cherry";
    const csvParts = csv.split(",");
    console.log(`水果: ${csvParts.join(", ")}`);
}

function fileIteration() {
    // 文件遍历 - 对比 CMD: for %%f in (*.txt) do echo %%f
    console.log("\n=== 文件遍历 ===");
    
    const files = fs.readdirSync('.');
    const jsFiles = files.filter(f => f.endsWith('.js'));
    jsFiles.forEach(file => {
        console.log(`文件: ${file}`);
    });
}

function directoryIteration() {
    // 目录遍历 - 对比 CMD: for /D %%d in (*) do echo %%d
    console.log("\n=== 目录遍历 ===");
    
    const entries = fs.readdirSync('.', { withFileTypes: true });
    entries
        .filter(entry => entry.isDirectory())
        .forEach(entry => {
            console.log(`目录: ${entry.name}`);
        });
}

function recursiveFileSearch() {
    // 递归文件搜索 - 对比 CMD: for /R %%f in (*.js) do echo %%f
    console.log("\n=== 递归文件搜索 ===");
    
    function walkDir(dir, pattern) {
        const results = [];
        const entries = fs.readdirSync(dir, { withFileTypes: true });
        
        for (const entry of entries) {
            const fullPath = path.join(dir, entry.name);
            if (entry.isDirectory()) {
                results.push(...walkDir(fullPath, pattern));
            } else if (entry.name.endsWith(pattern)) {
                results.push(fullPath);
            }
        }
        return results;
    }
    
    const jsFiles = walkDir('.', '.js');
    jsFiles.forEach(file => {
        console.log(`文件: ${file}`);
    });
}

function fileContentReading() {
    // 文件内容读取 - 对比 CMD: for /F "usebackq" %%a in (file.txt)
    console.log("\n=== 文件内容读取 ===");
    
    // 创建临时文件
    const content = [
        "line1 - 第一行",
        "line2 - 第二行",
        "# 这是注释",
        "line3 - 第三行"
    ].join('\n');
    
    fs.writeFileSync('temp_test.txt', content);
    
    // 读取文件内容
    const lines = fs.readFileSync('temp_test.txt', 'utf-8').split('\n');
    lines.forEach((line, index) => {
        line = line.trim();
        // 跳过注释行（类似 CMD eol=#）
        if (line.startsWith('#') || line === '') return;
        console.log(`第${index + 1}行: ${line}`);
    });
    
    // 清理临时文件
    fs.unlinkSync('temp_test.txt');
}

function commandOutput() {
    // 命令输出 - 对比 CMD: for /F %%a in ('dir /b')
    console.log("\n=== 命令输出 ===");
    
    try {
        const output = execSync('dir /b', { encoding: 'utf-8' });
        output.split('\n')
            .filter(line => line.trim())
            .forEach(line => {
                console.log(`文件: ${line.trim()}`);
            });
    } catch (e) {
        console.log("命令执行失败");
    }
}

function nestedLoop() {
    // 嵌套循环 - 对比 CMD: for /L %%i ... for /L %%j ...
    console.log("\n=== 嵌套循环 ===");
    
    // 九九乘法表片段
    for (let i = 1; i <= 3; i++) {
        for (let j = 1; j <= 3; j++) {
            console.log(`${i} x ${j} = ${i * j}`);
        }
        console.log();
    }
}

// 运行所有示例
basicListLoop();
numericLoop();
stringSplit();
fileIteration();
directoryIteration();
recursiveFileSearch();
fileContentReading();
commandOutput();
nestedLoop();
