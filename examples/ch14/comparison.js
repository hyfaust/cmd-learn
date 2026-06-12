#!/usr/bin/env node
/**
 * Node.js对比实现 - 与CMD/BAT脚本功能对比
 * 演示Node.js如何实现与CMD脚本相同的功能
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');
const os = require('os');

// 配置日志
const LOG_FILE = 'nodejs_comparison.log';

function log(level, message) {
    const timestamp = new Date().toISOString();
    const logEntry = `[${timestamp}] [${level}] ${message}\n`;
    
    // 输出到控制台
    console.log(`[${level}] ${message}`);
    
    // 写入日志文件
    fs.appendFileSync(LOG_FILE, logEntry, 'utf8');
}

class SystemInfoCollector {
    /**
     * 系统信息收集器 - 对应 sysinfo_collector.bat
     * Node.js实现使用os模块和child_process
     */
    
    constructor(outputDir = 'output') {
        this.outputDir = outputDir;
        this.reportFile = path.join(outputDir, 'sysinfo_report.html');
        
        // 确保输出目录存在
        if (!fs.existsSync(outputDir)) {
            fs.mkdirSync(outputDir, { recursive: true });
        }
    }
    
    collectSystemInfo() {
        log('INFO', '开始收集系统信息...');
        
        const info = {
            os: this.getOsInfo(),
            cpu: this.getCpuInfo(),
            memory: this.getMemoryInfo(),
            disk: this.getDiskInfo(),
            network: this.getNetworkInfo(),
            timestamp: new Date().toISOString()
        };
        
        log('INFO', '系统信息收集完成');
        return info;
    }
    
    getOsInfo() {
        return {
            platform: os.platform(),
            type: os.type(),
            release: os.release(),
            version: os.version(),
            arch: os.arch(),
            hostname: os.hostname()
        };
    }
    
    getCpuInfo() {
        const cpus = os.cpus();
        return {
            model: cpus[0]?.model || 'Unknown',
            cores: cpus.length,
            speed: cpus[0]?.speed || 0,
            threads: cpus.length // Node.js不直接提供线程数
        };
    }
    
    getMemoryInfo() {
        const totalMem = os.totalmem();
        const freeMem = os.freemem();
        return {
            total_mb: Math.round(totalMem / (1024 * 1024)),
            free_mb: Math.round(freeMem / (1024 * 1024)),
            used_mb: Math.round((totalMem - freeMem) / (1024 * 1024))
        };
    }
    
    getDiskInfo() {
        // Node.js没有内置的磁盘信息API，需要调用系统命令
        try {
            if (process.platform === 'win32') {
                const output = execSync('wmic diskdrive get Model,Size,MediaType', { encoding: 'utf8' });
                const lines = output.trim().split('\n').slice(1);
                return lines.filter(line => line.trim()).map(line => {
                    const parts = line.trim().split(/\s+/);
                    return {
                        model: parts.slice(0, -2).join(' '),
                        size_gb: parseInt(parts[parts.length - 1]) / (1024 * 1024 * 1024) || 0,
                        type: parts[parts.length - 2]
                    };
                });
            } else {
                const output = execSync('df -h', { encoding: 'utf8' });
                const lines = output.trim().split('\n').slice(1);
                return lines.map(line => {
                    const parts = line.split(/\s+/);
                    return {
                        filesystem: parts[0],
                        size: parts[1],
                        used: parts[2],
                        available: parts[3],
                        mountpoint: parts[5]
                    };
                });
            }
        } catch (error) {
            log('ERROR', `获取磁盘信息失败: ${error.message}`);
            return [];
        }
    }
    
    getNetworkInfo() {
        const interfaces = os.networkInterfaces();
        const result = {};
        
        for (const [name, addresses] of Object.entries(interfaces)) {
            result[name] = addresses.map(addr => ({
                address: addr.address,
                family: addr.family,
                internal: addr.internal
            }));
        }
        
        return result;
    }
    
    generateHtmlReport(info) {
        log('INFO', `生成HTML报告到: ${this.reportFile}`);
        
        const htmlContent = `<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>系统信息报告</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; }
        h2 { color: #34495e; margin-top: 30px; }
        table { width: 100%; border-collapse: collapse; margin: 10px 0; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #3498db; color: white; }
        tr:hover { background-color: #f5f5f5; }
        .timestamp { color: #666; font-size: 0.9em; text-align: right; }
    </style>
</head>
<body>
    <div class="container">
        <h1>系统信息报告 (Node.js生成)</h1>
        <p class="timestamp">生成时间: ${info.timestamp}</p>
        
        <h2>操作系统信息</h2>
        <table>
            <tr><th>项目</th><th>值</th></tr>
            <tr><td>平台</td><td>${info.os.platform}</td></tr>
            <tr><td>类型</td><td>${info.os.type}</td></tr>
            <tr><td>版本</td><td>${info.os.release}</td></tr>
            <tr><td>架构</td><td>${info.os.arch}</td></tr>
            <tr><td>主机名</td><td>${info.os.hostname}</td></tr>
        </table>
        
        <h2>CPU信息</h2>
        <table>
            <tr><th>项目</th><th>值</th></tr>
            <tr><td>处理器</td><td>${info.cpu.model}</td></tr>
            <tr><td>核心数</td><td>${info.cpu.cores}</td></tr>
            <tr><td>速度</td><td>${info.cpu.speed} MHz</td></tr>
        </table>
        
        <h2>内存信息</h2>
        <table>
            <tr><th>项目</th><th>值</th></tr>
            <tr><td>总内存</td><td>${info.memory.total_mb} MB</td></tr>
            <tr><td>已用内存</td><td>${info.memory.used_mb} MB</td></tr>
            <tr><td>可用内存</td><td>${info.memory.free_mb} MB</td></tr>
        </table>
    </div>
</body>
</html>`;
        
        fs.writeFileSync(this.reportFile, htmlContent, 'utf8');
        log('INFO', `HTML报告生成完成: ${this.reportFile}`);
    }
}

class LogAnalyzer {
    /**
     * 日志分析工具 - 对应 log_analyzer.bat
     * Node.js实现使用fs模块读取文件
     */
    
    constructor(logFile) {
        this.logFile = logFile;
        this.stats = {
            total_lines: 0,
            error_count: 0,
            warning_count: 0,
            info_count: 0,
            debug_count: 0,
            fatal_count: 0
        };
        this.errorMessages = [];
        this.fatalMessages = [];
    }
    
    analyze() {
        log('INFO', `开始分析日志文件: ${this.logFile}`);
        
        if (!fs.existsSync(this.logFile)) {
            log('ERROR', `日志文件不存在: ${this.logFile}`);
            return this.stats;
        }
        
        const content = fs.readFileSync(this.logFile, 'utf8');
        const lines = content.split('\n');
        
        for (const line of lines) {
            this.stats.total_lines++;
            this.analyzeLine(line.trim());
        }
        
        log('INFO', `日志分析完成，共 ${this.stats.total_lines} 行`);
        return this.stats;
    }
    
    analyzeLine(line) {
        const lineUpper = line.toUpperCase();
        
        if (lineUpper.includes('[ERROR]')) {
            this.stats.error_count++;
            this.errorMessages.push(line);
        } else if (lineUpper.includes('[WARNING]')) {
            this.stats.warning_count++;
        } else if (lineUpper.includes('[INFO]')) {
            this.stats.info_count++;
        } else if (lineUpper.includes('[DEBUG]')) {
            this.stats.debug_count++;
        } else if (lineUpper.includes('[FATAL]')) {
            this.stats.fatal_count++;
            this.fatalMessages.push(line);
        }
    }
    
    generateReport(outputFile = 'nodejs_analysis_report.txt') {
        log('INFO', `生成分析报告到: ${outputFile}`);
        
        const errorRate = this.stats.total_lines > 0 
            ? ((this.stats.error_count + this.stats.fatal_count) * 100 / this.stats.total_lines).toFixed(1)
            : 0;
        
        let reportContent = `
============================================================
                    日志分析报告 (Node.js生成)
============================================================
生成时间: ${new Date().toISOString()}
日志文件: ${this.logFile}
============================================================

【基本信息】
总行数: ${this.stats.total_lines}

【日志级别统计】
┌─────────────┬──────────┐
│ 日志级别    │ 数量     │
├─────────────┼──────────┤
│ FATAL       │ ${this.stats.fatal_count.toString().padEnd(8)} │
│ ERROR       │ ${this.stats.error_count.toString().padEnd(8)} │
│ WARNING     │ ${this.stats.warning_count.toString().padEnd(8)} │
│ INFO        │ ${this.stats.info_count.toString().padEnd(8)} │
│ DEBUG       │ ${this.stats.debug_count.toString().padEnd(8)} │
└─────────────┴──────────┘

【错误率分析】
错误率: ${errorRate}%
`;
        
        if (errorRate > 10) {
            reportContent += "[警告] 错误率较高，建议检查系统状态！\n";
        } else if (errorRate > 5) {
            reportContent += "[注意] 错误率中等，建议关注。\n";
        } else {
            reportContent += "[正常] 错误率在正常范围内。\n";
        }
        
        if (this.errorMessages.length > 0) {
            reportContent += "\n【错误详情】\n";
            reportContent += "-".repeat(60) + "\n";
            this.errorMessages.slice(0, 10).forEach(msg => {
                reportContent += `${msg}\n`;
            });
            reportContent += "-".repeat(60) + "\n";
        }
        
        if (this.fatalMessages.length > 0) {
            reportContent += "\n【严重错误详情】\n";
            reportContent += "-".repeat(60) + "\n";
            this.fatalMessages.forEach(msg => {
                reportContent += `${msg}\n`;
            });
            reportContent += "-".repeat(60) + "\n";
        }
        
        fs.writeFileSync(outputFile, reportContent, 'utf8');
        log('INFO', `分析报告生成完成: ${outputFile}`);
    }
}

class FileBatchProcessor {
    /**
     * 文件批量处理工具 - 对应 file_batch.bat
     * Node.js实现使用fs模块操作文件
     */
    
    constructor(targetDir) {
        this.targetDir = targetDir;
        
        if (!fs.existsSync(targetDir)) {
            fs.mkdirSync(targetDir, { recursive: true });
            log('INFO', `创建目标目录: ${targetDir}`);
        }
    }
    
    listFiles(pattern = '*') {
        const files = fs.readdirSync(this.targetDir);
        let filteredFiles = files;
        
        if (pattern !== '*') {
            const regex = new RegExp(pattern.replace(/\*/g, '.*'));
            filteredFiles = files.filter(file => regex.test(file));
        }
        
        log('INFO', `找到 ${filteredFiles.length} 个文件匹配模式: ${pattern}`);
        return filteredFiles.map(file => path.join(this.targetDir, file));
    }
    
    addPrefix(prefix, pattern = '*.*') {
        const changes = [];
        const files = this.listFiles(pattern);
        
        for (const filePath of files) {
            const fileName = path.basename(filePath);
            const newName = `${prefix}${fileName}`;
            const newPath = path.join(this.targetDir, newName);
            changes.push({ oldPath: filePath, newPath });
            log('DEBUG', `计划重命名: ${fileName} -> ${newName}`);
        }
        
        return changes;
    }
    
    addSuffix(suffix, pattern = '*.*') {
        const changes = [];
        const files = this.listFiles(pattern);
        
        for (const filePath of files) {
            const fileName = path.basename(filePath);
            const ext = path.extname(fileName);
            const stem = path.basename(fileName, ext);
            const newName = `${stem}${suffix}${ext}`;
            const newPath = path.join(this.targetDir, newName);
            changes.push({ oldPath: filePath, newPath });
            log('DEBUG', `计划重命名: ${fileName} -> ${newName}`);
        }
        
        return changes;
    }
    
    addSequence(prefix = '', start = 1, digits = 3, pattern = '*.*') {
        const changes = [];
        const files = this.listFiles(pattern);
        
        for (let i = 0; i < files.length; i++) {
            const filePath = files[i];
            const fileName = path.basename(filePath);
            const seqNum = (start + i).toString().padStart(digits, '0');
            const newName = `${prefix}${seqNum}_${fileName}`;
            const newPath = path.join(this.targetDir, newName);
            changes.push({ oldPath: filePath, newPath });
            log('DEBUG', `计划重命名: ${fileName} -> ${newName}`);
        }
        
        return changes;
    }
    
    executeChanges(changes, dryRun = true) {
        if (dryRun) {
            log('INFO', '预览模式 - 不会实际修改文件');
            for (const change of changes) {
                console.log(`${path.basename(change.oldPath)} -> ${path.basename(change.newPath)}`);
            }
        } else {
            log('INFO', '执行模式 - 开始修改文件');
            for (const change of changes) {
                try {
                    fs.renameSync(change.oldPath, change.newPath);
                    log('INFO', `重命名成功: ${path.basename(change.oldPath)} -> ${path.basename(change.newPath)}`);
                } catch (error) {
                    log('ERROR', `重命名失败: ${path.basename(change.oldPath)} -> ${path.basename(change.newPath)}: ${error.message}`);
                }
            }
        }
    }
}

class BackupSystem {
    /**
     * 简易备份系统 - 对应 backup_system.bat
     * Node.js实现支持文件复制和目录操作
     */
    
    constructor(sourceDir, backupDir = 'backup') {
        this.sourceDir = sourceDir;
        this.backupDir = backupDir;
        this.backupLog = path.join(backupDir, 'backup.log');
        
        if (!fs.existsSync(backupDir)) {
            fs.mkdirSync(backupDir, { recursive: true });
        }
    }
    
    incrementalBackup(timestamp = null) {
        if (!timestamp) {
            timestamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19);
        }
        
        const backupPath = path.join(this.backupDir, `backup_${timestamp}`);
        fs.mkdirSync(backupPath, { recursive: true });
        
        log('INFO', `开始增量备份到: ${backupPath}`);
        
        let backedUp = 0;
        const files = fs.readdirSync(this.sourceDir);
        
        for (const file of files) {
            const sourcePath = path.join(this.sourceDir, file);
            const destPath = path.join(backupPath, file);
            
            if (fs.statSync(sourcePath).isFile()) {
                fs.copyFileSync(sourcePath, destPath);
                backedUp++;
                log('DEBUG', `备份文件: ${file}`);
            }
        }
        
        log('INFO', `增量备份完成，备份了 ${backedUp} 个文件`);
        return backupPath;
    }
    
    fullBackup(timestamp = null) {
        if (!timestamp) {
            timestamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19);
        }
        
        const backupPath = path.join(this.backupDir, `full_backup_${timestamp}`);
        
        log('INFO', `开始全量备份到: ${backupPath}`);
        
        // 使用递归复制目录
        this.copyDirectoryRecursive(this.sourceDir, backupPath);
        
        log('INFO', '全量备份完成');
        return backupPath;
    }
    
    copyDirectoryRecursive(source, destination) {
        fs.mkdirSync(destination, { recursive: true });
        
        const items = fs.readdirSync(source);
        for (const item of items) {
            const sourcePath = path.join(source, item);
            const destPath = path.join(destination, item);
            
            if (fs.statSync(sourcePath).isDirectory()) {
                this.copyDirectoryRecursive(sourcePath, destPath);
            } else {
                fs.copyFileSync(sourcePath, destPath);
            }
        }
    }
    
    listBackups() {
        const backups = [];
        
        if (fs.existsSync(this.backupDir)) {
            const items = fs.readdirSync(this.backupDir);
            for (const item of items) {
                const itemPath = path.join(this.backupDir, item);
                if (fs.statSync(itemPath).isDirectory() && 
                    (item.includes('backup_') || item.includes('full_backup_'))) {
                    backups.push({
                        name: item,
                        path: itemPath,
                        created: fs.statSync(itemPath).birthtime
                    });
                }
            }
        }
        
        backups.sort((a, b) => a.name.localeCompare(b.name));
        log('INFO', `找到 ${backups.length} 个备份`);
        return backups;
    }
    
    restoreBackup(backupPath, targetDir = null) {
        if (!targetDir) {
            targetDir = this.sourceDir;
        }
        
        log('INFO', `开始恢复备份: ${backupPath} 到 ${targetDir}`);
        
        this.copyDirectoryRecursive(backupPath, targetDir);
        
        log('INFO', '备份恢复完成');
    }
}

class DeployScript {
    /**
     * 自动化部署脚本 - 对应 deploy.bat
     * Node.js实现支持配置文件和错误处理
     */
    
    constructor(configFile = 'config/deploy_config.ini') {
        this.configFile = configFile;
        this.config = this.loadConfig();
        this.deployLog = 'output/deploy.log';
        
        const outputDir = path.dirname(this.deployLog);
        if (!fs.existsSync(outputDir)) {
            fs.mkdirSync(outputDir, { recursive: true });
        }
    }
    
    loadConfig() {
        const config = {};
        
        if (fs.existsSync(this.configFile)) {
            const content = fs.readFileSync(this.configFile, 'utf8');
            const lines = content.split('\n');
            
            for (const line of lines) {
                const trimmedLine = line.trim();
                if (trimmedLine && !trimmedLine.startsWith('#') && !trimmedLine.startsWith('[')) {
                    const equalIndex = trimmedLine.indexOf('=');
                    if (equalIndex !== -1) {
                        const key = trimmedLine.slice(0, equalIndex).trim();
                        const value = trimmedLine.slice(equalIndex + 1).trim();
                        config[key] = value;
                    }
                }
            }
        } else {
            // 默认配置
            config.app_name = 'MyApplication';
            config.app_version = '1.0.0';
            config.deploy_steps = 'backup,stop,deploy,start,verify';
            config.health_check_url = 'http://localhost:8080/health';
            config.rollback_enabled = 'true';
        }
        
        return config;
    }
    
    executeStep(step) {
        log('INFO', `执行步骤: ${step}`);
        
        try {
            switch (step) {
                case 'backup':
                    return this.stepBackup();
                case 'stop':
                    return this.stepStop();
                case 'deploy':
                    return this.stepDeploy();
                case 'start':
                    return this.stepStart();
                case 'verify':
                    return this.stepVerify();
                default:
                    log('ERROR', `未知步骤: ${step}`);
                    return false;
            }
        } catch (error) {
            log('ERROR', `步骤 ${step} 执行失败: ${error.message}`);
            return false;
        }
    }
    
    stepBackup() {
        log('INFO', '创建备份...');
        // 模拟备份操作
        return true;
    }
    
    stepStop() {
        log('INFO', '停止应用...');
        // 模拟停止操作
        return true;
    }
    
    stepDeploy() {
        log('INFO', '部署新版本...');
        // 模拟部署操作
        return true;
    }
    
    stepStart() {
        log('INFO', '启动应用...');
        // 模拟启动操作
        return true;
    }
    
    stepVerify() {
        log('INFO', '验证部署...');
        // 模拟验证操作
        return true;
    }
    
    fullDeploy() {
        log('INFO', '开始完整部署');
        
        const steps = (this.config.deploy_steps || '').split(',');
        for (const step of steps) {
            const trimmedStep = step.trim();
            if (!trimmedStep) continue;
            
            if (!this.executeStep(trimmedStep)) {
                log('ERROR', `部署失败于步骤: ${trimmedStep}`);
                if (this.config.rollback_enabled === 'true') {
                    log('INFO', '自动回滚已启用，开始回滚...');
                    this.rollback();
                }
                return false;
            }
        }
        
        log('INFO', '部署完成');
        return true;
    }
    
    rollback() {
        log('INFO', '执行回滚...');
        // 模拟回滚操作
        log('INFO', '回滚完成');
    }
}

// 主函数 - 演示各个功能
function main() {
    console.log("=".repeat(60));
    console.log("                    Node.js对比实现演示");
    console.log("=".repeat(60));
    
    // 1. 系统信息收集器
    console.log("\n1. 系统信息收集器");
    const collector = new SystemInfoCollector();
    const info = collector.collectSystemInfo();
    collector.generateHtmlReport(info);
    console.log(`   系统信息报告已生成: ${collector.reportFile}`);
    
    // 2. 日志分析工具
    console.log("\n2. 日志分析工具");
    const logFile = 'logs/sample.log';
    if (fs.existsSync(logFile)) {
        const analyzer = new LogAnalyzer(logFile);
        const stats = analyzer.analyze();
        analyzer.generateReport('output/nodejs_analysis_report.txt');
        console.log(`   日志分析完成，错误数: ${stats.error_count}`);
    } else {
        console.log(`   日志文件不存在: ${logFile}`);
    }
    
    // 3. 文件批量处理
    console.log("\n3. 文件批量处理");
    const processor = new FileBatchProcessor('test_files');
    const changes = processor.addPrefix('backup_');
    processor.executeChanges(changes, true);
    
    // 4. 备份系统
    console.log("\n4. 备份系统");
    const backupSystem = new BackupSystem('test_files');
    const backups = backupSystem.listBackups();
    console.log(`   现有备份数: ${backups.length}`);
    
    // 5. 部署脚本
    console.log("\n5. 部署脚本");
    const deploy = new DeployScript();
    console.log(`   应用名称: ${deploy.config.app_name || 'Unknown'}`);
    console.log(`   部署步骤: ${deploy.config.deploy_steps || 'None'}`);
    
    console.log("\n" + "=".repeat(60));
    console.log("                    演示完成");
    console.log("=".repeat(60));
}

// 如果直接运行此文件，则执行main函数
if (require.main === module) {
    main();
}

module.exports = {
    SystemInfoCollector,
    LogAnalyzer,
    FileBatchProcessor,
    BackupSystem,
    DeployScript
};