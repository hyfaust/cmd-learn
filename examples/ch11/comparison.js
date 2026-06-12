// comparison.js
// Node.js 进程管理对比
// 使用 child_process 和 os 模块实现与 CMD 类似的功能

const { exec, execSync, spawn, execFile } = require('child_process');
const os = require('os');
const path = require('path');

/**
 * 获取系统信息 - 对比 CMD 的 systeminfo
 */
function getSystemInfo() {
    console.log('='.repeat(60));
    console.log('系统信息 (对比 systeminfo)');
    console.log('='.repeat(60));
    
    // CPU信息
    const cpus = os.cpus();
    console.log('\nCPU 信息:');
    console.log(`  型号: ${cpus[0].model}`);
    console.log(`  核心数: ${cpus.length}`);
    console.log(`  速度: ${cpus[0].speed} MHz`);
    
    // 内存信息
    const totalMem = os.totalmem() / 1024 / 1024 / 1024;
    const freeMem = os.freemem() / 1024 / 1024 / 1024;
    console.log('\n内存信息:');
    console.log(`  总内存: ${totalMem.toFixed(2)} GB`);
    console.log(`  可用内存: ${freeMem.toFixed(2)} GB`);
    console.log(`  使用率: ${((1 - freeMem / totalMem) * 100).toFixed(2)}%`);
    
    // 系统信息
    console.log('\n系统信息:');
    console.log(`  平台: ${os.platform()}`);
    console.log(`  架构: ${os.arch()}`);
    console.log(`  主机名: ${os.hostname()}`);
    console.log(`  用户: ${os.userInfo().username}`);
    console.log(`  运行时间: ${(os.uptime() / 3600).toFixed(2)} 小时`);
}

/**
 * 获取进程列表 - 对比 CMD 的 tasklist
 * 使用 WMIC 命令获取详细信息
 */
function getProcessList() {
    return new Promise((resolve, reject) => {
        console.log('\n' + '='.repeat(60));
        console.log('进程列表 (对比 tasklist)');
        console.log('='.repeat(60));
        
        // Windows 使用 tasklist
        if (os.platform() === 'win32') {
            exec('tasklist /fo CSV', (error, stdout, stderr) => {
                if (error) {
                    console.error('执行错误:', error);
                    reject(error);
                    return;
                }
                
                const lines = stdout.split('\n').slice(1); // 跳过标题行
                console.log(`\n共 ${lines.length} 个进程\n`);
                
                // 显示前20个进程
                console.log('PID\t\t名称\t\t\t内存使用');
                console.log('-'.repeat(60));
                
                lines.slice(0, 20).forEach(line => {
                    const parts = line.split(',');
                    if (parts.length >= 5) {
                        const name = parts[0].replace(/"/g, '');
                        const pid = parts[1].replace(/"/g, '');
                        const mem = parts[4].replace(/"/g, '');
                        console.log(`${pid}\t\t${name}\t\t${mem}`);
                    }
                });
                
                resolve();
            });
        } else {
            // Linux/Mac 使用 ps
            exec('ps aux', (error, stdout, stderr) => {
                if (error) {
                    console.error('执行错误:', error);
                    reject(error);
                    return;
                }
                
                const lines = stdout.split('\n');
                console.log(`\n共 ${lines.length - 1} 个进程\n`);
                
                // 显示前20个进程
                lines.slice(0, 21).forEach(line => {
                    console.log(line);
                });
                
                resolve();
            });
        }
    });
}

/**
 * 查找特定进程 - 对比 CMD 的 tasklist /fi
 */
function findProcess(processName) {
    return new Promise((resolve, reject) => {
        console.log(`\n查找进程: ${processName}`);
        console.log('-'.repeat(40));
        
        if (os.platform() === 'win32') {
            exec(`tasklist /fi "imagename eq ${processName}" /fo CSV`, 
                (error, stdout, stderr) => {
                if (error) {
                    console.error('执行错误:', error);
                    reject(error);
                    return;
                }
                
                const lines = stdout.split('\n').slice(1)
                    .filter(line => line.includes(processName));
                
                if (lines.length > 0) {
                    console.log(`找到 ${lines.length} 个匹配进程:`);
                    lines.forEach(line => {
                        const parts = line.split(',');
                        if (parts.length >= 2) {
                            console.log(`  PID: ${parts[1].replace(/"/g, '')}`);
                        }
                    });
                } else {
                    console.log('未找到该进程');
                }
                
                resolve();
            });
        } else {
            exec(`pgrep -l ${processName}`, (error, stdout, stderr) => {
                if (error || !stdout) {
                    console.log('未找到该进程');
                } else {
                    console.log(`找到匹配进程:\n${stdout}`);
                }
                resolve();
            });
        }
    });
}

/**
 * 终止进程 - 对比 CMD 的 taskkill
 * 注意: 仅演示安全的终止方法
 */
function killProcess(pid, force = false) {
    return new Promise((resolve, reject) => {
        console.log(`\n终止进程 PID: ${pid}`);
        console.log('-'.repeat(40));
        
        if (os.platform() === 'win32') {
            const cmd = force 
                ? `taskkill /pid ${pid} /f`
                : `taskkill /pid ${pid}`;
            
            console.log(`执行命令: ${cmd}`);
            
            // 安全起见，仅显示命令不执行
            console.log('[模拟] 命令已准备，实际执行需要确认');
            
            // 如果需要实际执行，取消下面的注释
            // exec(cmd, (error, stdout, stderr) => {
            //     if (error) {
            //         console.error('终止失败:', error);
            //         reject(error);
            //     } else {
            //         console.log(stdout);
            //         resolve();
            //     }
            // });
            
            resolve();
        } else {
            const cmd = force ? `kill -9 ${pid}` : `kill ${pid}`;
            console.log(`执行命令: ${cmd}`);
            console.log('[模拟] 命令已准备，实际执行需要确认');
            resolve();
        }
    });
}

/**
 * 获取服务列表 - 对比 CMD 的 sc query
 */
function getServiceList() {
    return new Promise((resolve, reject) => {
        console.log('\n' + '='.repeat(60));
        console.log('服务列表 (对比 sc query)');
        console.log('='.repeat(60));
        
        if (os.platform() === 'win32') {
            exec('sc query state= all', (error, stdout, stderr) => {
                if (error) {
                    console.error('执行错误:', error);
                    reject(error);
                    return;
                }
                
                // 解析服务信息
                const services = [];
                let currentService = {};
                
                stdout.split('\n').forEach(line => {
                    const trimmed = line.trim();
                    
                    if (trimmed.startsWith('SERVICE_NAME:')) {
                        if (currentService.name) {
                            services.push(currentService);
                        }
                        currentService = { 
                            name: trimmed.split(':')[1].trim() 
                        };
                    } else if (trimmed.startsWith('STATE')) {
                        currentService.state = trimmed.split(':')[1]?.trim();
                    }
                });
                
                if (currentService.name) {
                    services.push(currentService);
                }
                
                // 显示服务
                console.log(`\n共 ${services.length} 个服务\n`);
                console.log('服务名称\t\t\t状态');
                console.log('-'.repeat(60));
                
                services.slice(0, 30).forEach(service => {
                    console.log(`${service.name}\t\t\t${service.state || 'N/A'}`);
                });
                
                resolve();
            });
        } else {
            // Linux 使用 systemctl
            exec('systemctl list-units --type=service', (error, stdout, stderr) => {
                if (error) {
                    console.log('无法获取服务列表');
                } else {
                    console.log(stdout);
                }
                resolve();
            });
        }
    });
}

/**
 * 监控进程 - 对比 CMD 的进程监控脚本
 */
function monitorProcess(processName, interval = 5, duration = 60) {
    console.log(`\n开始监控进程: ${processName}`);
    console.log(`监控间隔: ${interval} 秒`);
    console.log(`监控时长: ${duration} 秒`);
    console.log('-'.repeat(40));
    
    let checkCount = 0;
    const startTime = Date.now();
    
    const check = () => {
        checkCount++;
        const now = new Date().toLocaleTimeString();
        
        if (os.platform() === 'win32') {
            exec(`tasklist /fi "imagename eq ${processName}"`, 
                (error, stdout, stderr) => {
                if (stdout.includes(processName)) {
                    console.log(`[${now}] 运行中 (检查 #${checkCount})`);
                } else {
                    console.log(`[${now}] 未运行 (检查 #${checkCount})`);
                }
            });
        } else {
            exec(`pgrep ${processName}`, (error, stdout) => {
                if (stdout) {
                    console.log(`[${now}] 运行中 (检查 #${checkCount})`);
                } else {
                    console.log(`[${now}] 未运行 (检查 #${checkCount})`);
                }
            });
        }
        
        // 检查是否达到监控时长
        if (Date.now() - startTime < duration * 1000) {
            setTimeout(check, interval * 1000);
        } else {
            console.log(`\n监控结束，共检查 ${checkCount} 次`);
        }
    };
    
    // 开始监控
    check();
}

/**
 * 使用 wmic 获取详细进程信息
 */
function getProcessDetailsWmic() {
    return new Promise((resolve, reject) => {
        console.log('\n' + '='.repeat(60));
        console.log('进程详细信息 (使用 WMIC)');
        console.log('='.repeat(60));
        
        if (os.platform() === 'win32') {
            exec('wmic process get name,processid,parentprocessid,workingsetsize /format:csv', 
                (error, stdout, stderr) => {
                if (error) {
                    console.error('执行错误:', error);
                    reject(error);
                    return;
                }
                
                const lines = stdout.split('\n').slice(2); // 跳过标题
                
                console.log('\n名称\t\tPID\t\t父PID\t\t内存(KB)');
                console.log('-'.repeat(60));
                
                lines.slice(0, 20).forEach(line => {
                    const parts = line.split(',');
                    if (parts.length >= 5) {
                        const name = parts[1];
                        const pid = parts[2];
                        const parentPid = parts[3];
                        const mem = parts[4];
                        console.log(`${name}\t\t${pid}\t\t${parentPid}\t\t${mem}`);
                    }
                });
                
                resolve();
            });
        } else {
            console.log('WMIC 仅适用于 Windows');
            resolve();
        }
    });
}

/**
 * 主函数 - 演示各种功能
 */
async function main() {
    console.log('Node.js 进程管理演示');
    console.log('对比 CMD 的 tasklist, taskkill, systeminfo 等命令');
    console.log();
    
    try {
        // 1. 获取系统信息
        getSystemInfo();
        
        // 2. 获取进程列表
        await getProcessList();
        
        // 3. 查找特定进程
        await findProcess('node.exe');
        
        // 4. 获取服务列表
        await getServiceList();
        
        // 5. 获取详细进程信息 (WMIC)
        await getProcessDetailsWmic();
        
        console.log('\n' + '='.repeat(60));
        console.log('演示完成');
        console.log('='.repeat(60));
        
    } catch (error) {
        console.error('演示过程中发生错误:', error);
    }
}

// 运行主函数
main();
