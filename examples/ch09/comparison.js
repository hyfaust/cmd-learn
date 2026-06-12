/**
 * Node.js 环境变量操作对比
 * 文件: comparison.js
 * 作者: 教程工程师
 * 日期: 2026-06-11
 * 说明: 展示Node.js中环境变量操作与CMD的对比
 */

const { execSync, exec } = require('child_process');
const fs = require('fs');
const path = require('path');
const os = require('os');

// 控制台输出颜色
const colors = {
    reset: '\x1b[0m',
    bright: '\x1b[1m',
    red: '\x1b[31m',
    green: '\x1b[32m',
    yellow: '\x1b[33m',
    blue: '\x1b[34m',
    magenta: '\x1b[35m',
    cyan: '\x1b[36m'
};

/**
 * 格式化输出
 */
function printHeader(title) {
    console.log('\n' + '='.repeat(60));
    console.log(`${colors.bright}${colors.cyan}${title}${colors.reset}`);
    console.log('='.repeat(60));
}

function printSubHeader(title) {
    console.log(`\n${colors.yellow}[${title}]${colors.reset}`);
    console.log('-'.repeat(40));
}

function printSuccess(message) {
    console.log(`${colors.green}✓ ${message}${colors.reset}`);
}

function printError(message) {
    console.log(`${colors.red}✗ ${message}${colors.reset}`);
}

function printWarning(message) {
    console.log(`${colors.yellow}⚠ ${message}${colors.reset}`);
}

function printInfo(message) {
    console.log(`${colors.blue}ℹ ${message}${colors.reset}`);
}

/**
 * 环境变量操作对比
 */
function compareEnvironmentVariables() {
    printHeader('环境变量操作对比');

    // 1. 获取环境变量
    printSubHeader('获取环境变量');
    
    // Node.js方式
    const nodePath = process.env.PATH || '默认值';
    const nodeTemp = process.env.TEMP || '默认值';
    const nodeUserProfile = process.env.USERPROFILE || '默认值';
    
    printInfo(`Node.js获取PATH: ${nodePath.substring(0, 100)}...`);
    printInfo(`Node.js获取TEMP: ${nodeTemp}`);
    printInfo(`Node.js获取USERPROFILE: ${nodeUserProfile}`);
    
    // CMD等价命令
    console.log('\nCMD等价命令:');
    console.log('  echo %PATH%');
    console.log('  echo %TEMP%');
    console.log('  echo %USERPROFILE%');

    // 2. 设置环境变量
    printSubHeader('设置环境变量');
    
    // Node.js方式 - 设置临时环境变量
    process.env.NODE_TEST_VAR = 'Node.js Test Value';
    printSuccess(`Node.js设置NODE_TEST_VAR: ${process.env.NODE_TEST_VAR}`);
    
    // CMD等价命令
    console.log('\nCMD等价命令:');
    console.log('  set NODE_TEST_VAR=Node.js Test Value');

    // 3. 删除环境变量
    printSubHeader('删除环境变量');
    
    // Node.js方式
    if (process.env.NODE_TEST_VAR) {
        delete process.env.NODE_TEST_VAR;
        printSuccess('Node.js删除NODE_TEST_VAR: 成功');
    } else {
        printWarning('Node.js删除NODE_TEST_VAR: 变量不存在');
    }
    
    // CMD等价命令
    console.log('\nCMD等价命令:');
    console.log('  set NODE_TEST_VAR=');

    // 4. 遍历环境变量
    printSubHeader('遍历环境变量');
    
    // Node.js方式
    console.log('Node.js遍历环境变量（前10个）:');
    const envKeys = Object.keys(process.env);
    for (let i = 0; i < Math.min(10, envKeys.length); i++) {
        const key = envKeys[i];
        const value = process.env[key];
        console.log(`  ${key}: ${value.substring(0, 50)}...`);
    }
    
    // CMD等价命令
    console.log('\nCMD等价命令:');
    console.log('  set');
}

/**
 * PATH变量操作对比
 */
function comparePathOperations() {
    printHeader('PATH变量操作对比');

    // 1. 获取PATH
    printSubHeader('获取PATH变量');
    
    // Node.js方式
    const nodePath = process.env.PATH || '';
    const pathList = nodePath.split(';');
    
    console.log('Node.js获取PATH（前5个目录）:');
    for (let i = 0; i < Math.min(5, pathList.length); i++) {
        console.log(`  ${i + 1}. ${pathList[i]}`);
    }
    
    // CMD等价命令
    console.log('\nCMD等价命令:');
    console.log('  echo %PATH%');

    // 2. 添加目录到PATH
    printSubHeader('添加目录到PATH');
    
    // Node.js方式
    const newPath = 'C:\\NodeTestDir';
    process.env.PATH = `${process.env.PATH};${newPath}`;
    printSuccess(`Node.js添加目录到PATH: ${newPath}`);
    
    // CMD等价命令
    console.log('\nCMD等价命令:');
    console.log(`  set PATH=%PATH%;${newPath}`);

    // 3. 检查目录是否存在
    printSubHeader('检查PATH目录是否存在');
    
    // Node.js方式
    console.log('Node.js检查PATH目录:');
    const missingDirs = [];
    for (let i = 0; i < Math.min(10, pathList.length); i++) {
        const pathDir = pathList[i];
        if (pathDir && fs.existsSync(pathDir)) {
            printSuccess(`[存在] ${pathDir}`);
        } else if (pathDir) {
            missingDirs.push(pathDir);
            printError(`[缺失] ${pathDir}`);
        }
    }
    
    printInfo(`缺失目录数量: ${missingDirs.length}`);
    
    // CMD等价命令
    console.log('\nCMD等价命令:');
    console.log('  for %%i in ("%PATH:;=" "%") do if not exist "%%~i" echo 缺失: %%~i');
}

/**
 * 注册表操作对比（通过系统命令）
 */
function compareRegistryOperations() {
    printHeader('注册表操作对比（通过系统命令）');

    // 1. 查询注册表
    printSubHeader('查询注册表');
    
    try {
        // Node.js方式 - 通过系统命令
        console.log('Node.js查询用户环境变量:');
        const result = execSync('reg query "HKCU\\Environment"', { encoding: 'utf8' });
        console.log(result);
    } catch (error) {
        printError(`Node.js查询注册表失败: ${error.message}`);
    }
    
    // CMD等价命令
    console.log('\nCMD等价命令:');
    console.log('  reg query "HKCU\\Environment"');

    // 2. 查询特定值
    printSubHeader('查询特定注册表值');
    
    try {
        // Node.js方式
        const result = execSync('reg query "HKCU\\Environment" /v Path', { encoding: 'utf8' });
        console.log(`Node.js查询Path值:\n${result}`);
    } catch (error) {
        printError(`Node.js查询Path值失败: ${error.message}`);
    }
    
    // CMD等价命令
    console.log('\nCMD等价命令:');
    console.log('  reg query "HKCU\\Environment" /v Path');

    // 3. 添加注册表值（仅演示，不实际执行）
    printSubHeader('添加注册表值（演示）');
    
    printWarning('Node.js添加注册表值需要调用系统命令:');
    console.log('  execSync(\'reg add "HKCU\\Environment" /v "NODE_TEST_REG" /t REG_SZ /d "Node.js Registry Value" /f\')');
    
    // CMD等价命令
    console.log('\nCMD等价命令:');
    console.log('  reg add "HKCU\\Environment" /v "NODE_TEST_REG" /t REG_SZ /d "Node.js Registry Value" /f');

    // 4. 删除注册表值（仅演示，不实际执行）
    printSubHeader('删除注册表值（演示）');
    
    printWarning('Node.js删除注册表值需要调用系统命令:');
    console.log('  execSync(\'reg delete "HKCU\\Environment" /v "NODE_TEST_REG" /f\')');
    
    // CMD等价命令
    console.log('\nCMD等价命令:');
    console.log('  reg delete "HKCU\\Environment" /v "NODE_TEST_REG" /f');
}

/**
 * 创建对比报告
 */
function createComparisonReport() {
    printHeader('创建对比报告');

    const report = {
        comparison_date: new Date().toISOString(),
        node_version: process.version,
        operating_system: os.platform(),
        environment_variables: {
            total_count: Object.keys(process.env).length,
            important_vars: {
                PATH: (process.env.PATH || '').substring(0, 100) + '...',
                TEMP: process.env.TEMP || '',
                USERPROFILE: process.env.USERPROFILE || '',
                SystemRoot: process.env.SystemRoot || '',
                ProgramFiles: process.env.ProgramFiles || ''
            }
        },
        system_info: {
            hostname: os.hostname(),
            platform: os.platform(),
            arch: os.arch(),
            release: os.release(),
            total_memory: os.totalmem(),
            free_memory: os.freemem()
        },
        cmd_equivalent_commands: {
            get_env: 'echo %VARIABLE_NAME%',
            set_env: 'set VARIABLE_NAME=value',
            query_reg: 'reg query "HKCU\\Environment"',
            add_reg: 'reg add "HKCU\\Environment" /v Name /t REG_SZ /d Value /f',
            delete_reg: 'reg delete "HKCU\\Environment" /v Name /f'
        }
    };

    // 保存报告
    const reportFile = 'env_registry_comparison_node.json';
    fs.writeFileSync(reportFile, JSON.stringify(report, null, 2));
    
    printSuccess(`对比报告已保存到: ${reportFile}`);
    console.log('报告内容预览:');
    console.log(`  生成时间: ${report.comparison_date}`);
    console.log(`  Node.js版本: ${report.node_version}`);
    console.log(`  环境变量总数: ${report.environment_variables.total_count}`);
    console.log(`  主机名: ${report.system_info.hostname}`);
    console.log(`  操作系统: ${report.system_info.platform} ${report.system_info.release}`);
}

/**
 * 主函数
 */
function main() {
    console.log(`${colors.bright}${colors.magenta}Node.js 环境变量操作对比演示${colors.reset}`);
    console.log('作者: 教程工程师');
    console.log('日期: 2026-06-11');
    console.log();

    try {
        compareEnvironmentVariables();
        comparePathOperations();
        compareRegistryOperations();
        createComparisonReport();

        printHeader('对比演示完成');
        console.log('\n主要区别总结:');
        console.log('1. Node.js使用process.env管理环境变量，CMD使用set命令');
        console.log('2. Node.js需要通过子进程调用reg命令操作注册表');
        console.log('3. Node.js提供异步API，CMD是同步执行');
        console.log('4. Node.js更适合Web应用和跨平台开发');
        console.log('5. CMD更适合Windows系统管理和脚本任务');
        
    } catch (error) {
        printError(`演示过程中发生错误: ${error.message}`);
        console.error(error.stack);
    }
}

// 运行主函数
if (require.main === module) {
    main();
}

module.exports = {
    compareEnvironmentVariables,
    comparePathOperations,
    compareRegistryOperations,
    createComparisonReport
};