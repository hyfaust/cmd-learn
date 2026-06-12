/**
 * comparison.js - Node.js文件I/O对比示例
 * 
 * 本文件展示Node.js中文件I/O操作，用于与CMD的文件I/O进行对比。
 * Node.js提供了同步和异步两种文件操作方式。
 */

const fs = require('fs');
const path = require('path');
const os = require('os');

// 创建测试目录
const testDir = path.join(__dirname, 'test_output');

/**
 * 确保测试目录存在
 */
function ensureTestDir() {
    if (!fs.existsSync(testDir)) {
        fs.mkdirSync(testDir, { recursive: true });
    }
}

/**
 * 演示同步文件I/O
 */
function demonstrateSyncIO() {
    console.log('=== Node.js同步文件I/O ===\n');
    
    // 1. 同步写入文件
    console.log('1. 同步写入文件');
    const filePath = path.join(testDir, 'sync_output.txt');
    fs.writeFileSync(filePath, 'Hello World\nNode.js同步写入\n第三行内容\n', 'utf8');
    
    // 同步读取文件
    const content = fs.readFileSync(filePath, 'utf8');
    console.log(`文件内容:\n${content}`);
    
    // 2. 同步追加写入
    console.log('2. 同步追加写入');
    fs.appendFileSync(filePath, '追加的第一行\n追加的第二行\n', 'utf8');
    
    const appendedContent = fs.readFileSync(filePath, 'utf8');
    console.log(`追加后内容:\n${appendedContent}`);
}

/**
 * 演示异步文件I/O（使用Promise）
 */
async function demonstrateAsyncIO() {
    console.log('\n=== Node.js异步文件I/O ===\n');
    
    const filePath = path.join(testDir, 'async_output.txt');
    
    // 1. 异步写入文件
    console.log('1. 异步写入文件');
    await fs.promises.writeFile(filePath, 'Hello World\nNode.js异步写入\n', 'utf8');
    
    // 异步读取文件
    const content = await fs.promises.readFile(filePath, 'utf8');
    console.log(`文件内容:\n${content}`);
    
    // 2. 异步追加写入
    console.log('2. 异步追加写入');
    await fs.promises.appendFile(filePath, '追加的内容\n', 'utf8');
    
    const appendedContent = await fs.promises.readFile(filePath, 'utf8');
    console.log(`追加后内容:\n${appendedContent}`);
}

/**
 * 演示逐行读取
 */
function demonstrateLineByLine() {
    console.log('\n=== 逐行读取 ===\n');
    
    // 创建测试文件
    const filePath = path.join(testDir, 'lines.txt');
    let content = '';
    for (let i = 1; i <= 5; i++) {
        content += `Line ${i}: This is line number ${i}\n`;
    }
    fs.writeFileSync(filePath, content, 'utf8');
    
    // 方法1: 使用split分割
    console.log('方法1: 使用split分割');
    const data = fs.readFileSync(filePath, 'utf8');
    const lines = data.split('\n').filter(line => line.trim() !== '');
    lines.forEach((line, index) => {
        console.log(`  ${index + 1}: ${line}`);
    });
    
    // 方法2: 使用readline接口
    console.log('\n方法2: 使用readline接口（流式读取）');
    const readline = require('readline');
    const fileStream = fs.createReadStream(filePath, 'utf8');
    const rl = readline.createInterface({
        input: fileStream,
        crlfDelay: Infinity
    });
    
    let lineNumber = 0;
    rl.on('line', (line) => {
        lineNumber++;
        console.log(`  ${lineNumber}: ${line}`);
    });
    
    // 方法3: 使用流式读取
    console.log('\n方法3: 使用流式读取');
    const stream = fs.createReadStream(filePath, { encoding: 'utf8' });
    let buffer = '';
    
    stream.on('data', (chunk) => {
        buffer += chunk;
    });
    
    stream.on('end', () => {
        const streamLines = buffer.split('\n').filter(line => line.trim() !== '');
        streamLines.forEach((line, index) => {
            console.log(`  ${index + 1}: ${line}`);
        });
    });
}

/**
 * 演示文件操作
 */
function demonstrateFileOperations() {
    console.log('\n=== 文件操作 ===\n');
    
    const testFile = path.join(testDir, 'operations.txt');
    
    // 创建测试文件
    fs.writeFileSync(testFile, '测试文件操作\n', 'utf8');
    
    // 1. 检查文件是否存在
    console.log(`1. 文件存在: ${fs.existsSync(testFile)}`);
    
    // 2. 获取文件信息
    const stats = fs.statSync(testFile);
    console.log(`2. 文件信息:`);
    console.log(`   大小: ${stats.size} 字节`);
    console.log(`   修改时间: ${stats.mtime}`);
    console.log(`   创建时间: ${stats.birthtime}`);
    
    // 3. 重命名文件
    const newPath = path.join(testDir, 'renamed.txt');
    fs.renameSync(testFile, newPath);
    console.log(`3. 重命名: ${path.basename(testFile)} -> ${path.basename(newPath)}`);
    
    // 4. 复制文件
    const copyPath = path.join(testDir, 'copy.txt');
    fs.copyFileSync(newPath, copyPath);
    console.log(`4. 复制: ${path.basename(newPath)} -> ${path.basename(copyPath)}`);
    
    // 5. 删除文件
    fs.unlinkSync(copyPath);
    console.log(`5. 删除: ${path.basename(copyPath)}`);
    console.log(`   文件存在: ${fs.existsSync(copyPath)}`);
}

/**
 * 演示临时文件操作
 */
function demonstrateTempFiles() {
    console.log('\n=== 临时文件操作 ===\n');
    
    // 方法1: 使用os.tmpdir()
    console.log('方法1: 使用os.tmpdir()');
    const tempDir = os.tmpdir();
    const tempFile = path.join(tempDir, `node_temp_${Date.now()}.txt`);
    
    fs.writeFileSync(tempFile, '临时文件内容\n', 'utf8');
    console.log(`  临时文件: ${tempFile}`);
    
    const content = fs.readFileSync(tempFile, 'utf8');
    console.log(`  内容: ${content.trim()}`);
    
    // 删除临时文件
    fs.unlinkSync(tempFile);
    console.log('  临时文件已删除');
    
    // 方法2: 使用临时目录
    console.log('\n方法2: 使用临时目录');
    const tempDirPath = fs.mkdtempSync(path.join(os.tmpdir(), 'node_'));
    console.log(`  临时目录: ${tempDirPath}`);
    
    const tempFilePath = path.join(tempDirPath, 'test.txt');
    fs.writeFileSync(tempFilePath, '在临时目录中的文件\n', 'utf8');
    
    const tempContent = fs.readFileSync(tempFilePath, 'utf8');
    console.log(`  内容: ${tempContent.trim()}`);
    
    // 清理临时目录
    fs.rmSync(tempDirPath, { recursive: true, force: true });
    console.log('  临时目录已清理');
}

/**
 * 演示JSON文件操作
 */
function demonstrateJsonOperations() {
    console.log('\n=== JSON文件操作 ===\n');
    
    // 创建数据
    const data = {
        name: 'CMD Tutorial',
        version: '1.0.0',
        chapters: [
            { id: 1, title: 'Hello CMD' },
            { id: 2, title: 'File Management' },
            { id: 6, title: 'File I/O' }
        ],
        metadata: {
            author: 'Tutorial Engineer',
            created: '2026-06-11'
        }
    };
    
    // 写入JSON
    const jsonFile = path.join(testDir, 'data.json');
    fs.writeFileSync(jsonFile, JSON.stringify(data, null, 2), 'utf8');
    
    console.log('JSON文件内容:');
    const loaded = JSON.parse(fs.readFileSync(jsonFile, 'utf8'));
    console.log(JSON.stringify(loaded, null, 2));
}

/**
 * 演示流式处理
 */
function demonstrateStreams() {
    console.log('\n=== 流式处理 ===\n');
    
    // 创建大文件用于测试
    const largeFile = path.join(testDir, 'large.txt');
    let content = '';
    for (let i = 0; i < 1000; i++) {
        content += `Line ${i + 1}: This is a test line with some content\n`;
    }
    fs.writeFileSync(largeFile, content, 'utf8');
    
    console.log('使用流式处理大文件:');
    
    // 使用可读流
    const readStream = fs.createReadStream(largeFile, { encoding: 'utf8' });
    let lineCount = 0;
    
    readStream.on('data', (chunk) => {
        const lines = chunk.split('\n');
        lineCount += lines.length - 1;
    });
    
    readStream.on('end', () => {
        console.log(`  总行数: ${lineCount}`);
    });
    
    // 使用管道
    console.log('\n使用管道处理:');
    const transformStream = require('stream').Transform;
    
    class LineCounter extends transformStream {
        constructor() {
            super({ objectMode: true });
            this.count = 0;
        }
        
        _transform(chunk, encoding, callback) {
            const lines = chunk.toString().split('\n');
            this.count += lines.length - 1;
            callback();
        }
        
        _flush(callback) {
            this.push(`Total lines: ${this.count}\n`);
            callback();
        }
    }
    
    const lineCounter = new LineCounter();
    const writeStream = fs.createWriteStream(path.join(testDir, 'count.txt'));
    
    fs.createReadStream(largeFile)
        .pipe(lineCounter)
        .pipe(writeStream);
    
    writeStream.on('finish', () => {
        const result = fs.readFileSync(path.join(testDir, 'count.txt'), 'utf8');
        console.log(`  管道处理结果: ${result.trim()}`);
    });
}

/**
 * 演示错误处理
 */
function demonstrateErrorHandling() {
    console.log('\n=== 错误处理 ===\n');
    
    // 1. 文件不存在
    console.log('1. 文件不存在错误:');
    try {
        fs.readFileSync('nonexistent.txt', 'utf8');
    } catch (error) {
        console.log(`   捕获错误: ${error.message}`);
        console.log(`   错误代码: ${error.code}`);
    }
    
    // 2. 同步错误处理
    console.log('\n2. 同步错误处理:');
    try {
        const stats = fs.statSync('nonexistent.txt');
    } catch (error) {
        console.log(`   捕获错误: ${error.message}`);
    }
    
    // 3. 异步错误处理
    console.log('\n3. 异步错误处理:');
    fs.promises.readFile('nonexistent.txt', 'utf8')
        .catch(error => {
            console.log(`   捕获错误: ${error.message}`);
        });
    
    // 4. 使用回调的错误处理
    console.log('\n4. 回调错误处理:');
    fs.readFile('nonexistent.txt', 'utf8', (error, data) => {
        if (error) {
            console.log(`   捕获错误: ${error.message}`);
        }
    });
}

/**
 * 清理测试目录
 */
function cleanup() {
    console.log(`\n清理测试目录: ${testDir}`);
    if (fs.existsSync(testDir)) {
        fs.rmSync(testDir, { recursive: true, force: true });
        console.log('清理完成');
    }
}

/**
 * 主函数
 */
async function main() {
    console.log('Node.js文件I/O对比示例');
    console.log('='.repeat(50));
    
    try {
        ensureTestDir();
        
        // 演示各种文件操作
        demonstrateSyncIO();
        await demonstrateAsyncIO();
        demonstrateLineByLine();
        demonstrateFileOperations();
        demonstrateTempFiles();
        demonstrateJsonOperations();
        demonstrateStreams();
        demonstrateErrorHandling();
        
    } finally {
        // 清理
        cleanup();
    }
    
    console.log('\n' + '='.repeat(50));
    console.log('Node.js文件I/O演示完成');
    console.log('='.repeat(50));
}

// 运行主函数
main().catch(console.error);