#!/usr/bin/env node
/**
 * comparison.js - Node.js 子进程示例
 * 
 * 功能: 演示 Node.js 如何调用外部命令和程序
 * 用法: node comparison.js
 * 安全提示: 仅在项目目录内操作
 */

const { execSync, exec, spawn, execFile } = require('child_process');


/**
 * 演示 execSync - 同步执行
 */
function demoExecSync() {
    console.log("=".repeat(50));
    console.log("  方式 1: execSync() - 同步执行");
    console.log("=".repeat(50));
    console.log();
    
    // 简单命令
    console.log("[Node.js] 执行 'hostname' 命令:");
    try {
        const hostname = execSync('hostname', { encoding: 'utf8', shell: 'cmd.exe' });
        console.log(`  主机名: ${hostname.trim()}`);
    } catch (e) {
        console.log(`  错误: ${e.message}`);
    }
    console.log();
    
    // 带输出的命令
    console.log("[Node.js] 执行 'dir /b' 命令:");
    try {
        const output = execSync('dir /b *.js', { encoding: 'utf8', shell: 'cmd.exe' });
        console.log("  JS 文件:");
        output.trim().split('\n').slice(0, 5).forEach(line => {
            console.log(`    ${line.trim()}`);
        });
    } catch (e) {
        console.log(`  错误: ${e.message}`);
    }
    console.log();
}


/**
 * 演示 exec - 异步执行
 */
function demoExec() {
    console.log("=".repeat(50));
    console.log("  方式 2: exec() - 异步执行");
    console.log("=".repeat(50));
    console.log();
    
    return new Promise((resolve) => {
        console.log("[Node.js] 异步执行 'echo' 命令:");
        exec('echo Hello from exec', { shell: 'cmd.exe' }, (error, stdout, stderr) => {
            if (error) {
                console.log(`  错误: ${error.message}`);
            } else {
                console.log(`  输出: ${stdout.trim()}`);
            }
            console.log();
            resolve();
        });
    });
}


/**
 * 演示 spawn - 流式执行
 */
function demoSpawn() {
    console.log("=".repeat(50));
    console.log("  方式 3: spawn() - 流式执行");
    console.log("=".repeat(50));
    console.log();
    
    return new Promise((resolve) => {
        console.log("[Node.js] 使用 spawn 执行 'ping' 命令:");
        const child = spawn('ping', ['-n', '2', '127.0.0.1'], { shell: 'cmd.exe' });
        
        let output = '';
        child.stdout.on('data', (data) => {
            output += data.toString();
        });
        
        child.stderr.on('data', (data) => {
            console.error(`  错误: ${data}`);
        });
        
        child.on('close', (code) => {
            console.log(`  退出码: ${code}`);
            const lines = output.trim().split('\n');
            lines.slice(-3).forEach(line => {
                console.log(`  ${line.trim()}`);
            });
            console.log();
            resolve();
        });
    });
}


/**
 * 演示 execFile - 直接执行文件
 */
function demoExecFile() {
    console.log("=".repeat(50));
    console.log("  方式 4: execFile() - 直接执行文件");
    console.log("=".repeat(50));
    console.log();
    
    return new Promise((resolve) => {
        console.log("[Node.js] 使用 execFile 执行 'where' 命令:");
        execFile('where', ['node'], (error, stdout, stderr) => {
            if (error) {
                console.log(`  错误: ${error.message}`);
            } else {
                console.log(`  node 路径: ${stdout.trim().split('\n')[0]}`);
            }
            console.log();
            resolve();
        });
    });
}


/**
 * 演示管道通信
 */
function demoPipe() {
    console.log("=".repeat(50));
    console.log("  方式 5: 管道通信");
    console.log("=".repeat(50));
    console.log();
    
    return new Promise((resolve) => {
        console.log("[Node.js] 管道执行命令:");
        
        // 使用 shell 管道
        exec('echo apple & echo banana & echo cherry | sort', 
             { shell: 'cmd.exe' }, 
             (error, stdout) => {
            if (error) {
                console.log(`  错误: ${error.message}`);
            } else {
                console.log("  排序结果:");
                stdout.trim().split('\n').forEach(line => {
                    console.log(`    ${line.trim()}`);
                });
            }
            console.log();
            resolve();
        });
    });
}


/**
 * 主函数
 */
async function main() {
    console.log();
    console.log("╔" + "═".repeat(48) + "╗");
    console.log("║" + "  Node.js 子进程示例  ".padStart(30).padEnd(48) + "║");
    console.log("╚" + "═".repeat(48) + "╝");
    console.log();
    
    // 演示各种调用方式
    demoExecSync();
    await demoExec();
    await demoSpawn();
    await demoExecFile();
    await demoPipe();
    
    console.log("=".repeat(50));
    console.log("  演示完成");
    console.log("=".repeat(50));
}


// 执行主函数
main().catch(console.error);
