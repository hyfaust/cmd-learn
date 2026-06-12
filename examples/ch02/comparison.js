/**
 * Node.js 文件操作对比示例
 * 功能：演示Node.js中与CMD等效的文件系统操作
 * 使用模块：fs, path
 */

const fs = require('fs');
const path = require('path');

// 设置基准目录为脚本所在目录下的sandbox
const scriptDir = __dirname;
const baseDir = path.join(scriptDir, 'sandbox');

// 清理可能存在的旧sandbox
if (fs.existsSync(baseDir)) {
    fs.rmSync(baseDir, { recursive: true, force: true });
}

console.log('='.repeat(50));
console.log('Node.js 文件操作对比示例');
console.log('='.repeat(50));
console.log();

// 创建目录结构
console.log('[1] 创建目录结构');
// CMD: mkdir dir
fs.mkdirSync(baseDir, { recursive: true });
fs.mkdirSync(path.join(baseDir, 'sub1'), { recursive: true });
fs.mkdirSync(path.join(baseDir, 'sub2'), { recursive: true });
fs.mkdirSync(path.join(baseDir, 'sub1', 'deep'), { recursive: true });
console.log('创建完成');
console.log();

// 创建测试文件
console.log('[2] 创建测试文件');
// CMD: echo content > file.txt
fs.writeFileSync(path.join(baseDir, 'test1.txt'), '这是第一个测试文件\n', 'utf8');
fs.writeFileSync(path.join(baseDir, 'test2.txt'), '这是第二个测试文件\n', 'utf8');
fs.writeFileSync(path.join(baseDir, 'test3.txt'), 'Hello World\n', 'utf8');
console.log('创建完成');
console.log();

// 复制文件
console.log('[3] 复制文件');
// CMD: copy src dst
fs.copyFileSync(
    path.join(baseDir, 'test1.txt'),
    path.join(baseDir, 'test1_backup.txt')
);
console.log('复制: test1.txt -> test1_backup.txt');

// 批量复制
const backupDir = path.join(baseDir, 'backup');
fs.mkdirSync(backupDir, { recursive: true });
const txtFiles = fs.readdirSync(baseDir).filter(f => f.endsWith('.txt'));
txtFiles.forEach(file => {
    fs.copyFileSync(
        path.join(baseDir, file),
        path.join(backupDir, file)
    );
});
console.log('批量复制完成');
console.log();

// 移动文件
console.log('[4] 移动文件');
// CMD: move src dst
fs.renameSync(
    path.join(baseDir, 'test2.txt'),
    path.join(baseDir, 'sub1', 'test2.txt')
);
console.log('移动: test2.txt -> sub1/test2.txt');
console.log();

// 重命名文件
console.log('[5] 重命名文件');
// CMD: ren old new
fs.renameSync(
    path.join(baseDir, 'test3.txt'),
    path.join(baseDir, 'test3_renamed.txt')
);
console.log('重命名: test3.txt -> test3_renamed.txt');
console.log();

// 读取文件内容
console.log('[6] 读取文件内容');
// CMD: type file.txt
const content = fs.readFileSync(path.join(baseDir, 'test1.txt'), 'utf8');
console.log(`test1.txt 内容: ${content.trim()}`);
console.log();

// 文件属性操作
console.log('[7] 文件属性操作');
const testFile = path.join(baseDir, 'test1.txt');
const stat = fs.statSync(testFile);
console.log(`文件大小: ${stat.size} 字节`);
console.log(`创建时间: ${stat.birthtime}`);
console.log(`修改时间: ${stat.mtime}`);

// 设置只读属性
// CMD: attrib +R file.txt
fs.chmodSync(testFile, 0o444);
console.log('设置只读属性完成');
console.log();

// 遍历目录
console.log('[8] 遍历目录');
// CMD: for /R %dir% %%f in (*.txt) do echo %%f
function findFilesRecursive(dir, pattern) {
    const results = [];
    const items = fs.readdirSync(dir);
    
    items.forEach(item => {
        const fullPath = path.join(dir, item);
        const stat = fs.statSync(fullPath);
        
        if (stat.isDirectory()) {
            results.push(...findFilesRecursive(fullPath, pattern));
        } else if (item.endsWith(pattern)) {
            results.push(fullPath);
        }
    });
    
    return results;
}

console.log('所有.txt文件:');
const txtFilesRecursive = findFilesRecursive(baseDir, '.txt');
txtFilesRecursive.forEach(file => {
    console.log(`  ${path.relative(baseDir, file)}`);
});
console.log();

// 使用递归显示目录树
console.log('[9] 目录树结构');
function printTree(dir, indent = '') {
    const items = fs.readdirSync(dir);
    
    items.forEach((item, index) => {
        const fullPath = path.join(dir, item);
        const stat = fs.statSync(fullPath);
        const isLast = index === items.length - 1;
        const prefix = isLast ? '└── ' : '├── ';
        const childIndent = isLast ? '    ' : '│   ';
        
        console.log(`${indent}${prefix}${item}`);
        
        if (stat.isDirectory()) {
            printTree(fullPath, indent + childIndent);
        }
    });
}

printTree(baseDir);
console.log();

// 删除文件
console.log('[10] 删除文件');
// CMD: del file.txt
fs.unlinkSync(path.join(baseDir, 'test1_backup.txt'));
console.log('删除: test1_backup.txt');
console.log();

// 清理sandbox目录
console.log('[11] 清理sandbox目录');
// CMD: rmdir /s /q sandbox
fs.rmSync(baseDir, { recursive: true, force: true });
console.log('清理完成');

console.log();
console.log('演示结束');