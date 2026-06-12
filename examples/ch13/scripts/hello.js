#!/usr/bin/env node
/**
 * hello.js - Node.js 示例脚本
 * 
 * 功能: 接收命令行参数并输出信息
 * 用法: node hello.js [arg1] [arg2] ...
 * 安全提示: 仅在项目目录内操作
 */

// 输出脚本信息
console.log("========================================");
console.log("  Node.js 脚本示例");
console.log("========================================");
console.log();

// 获取 Node.js 版本
console.log(`[Node.js] 版本: ${process.version}`);
console.log(`[Node.js] 平台: ${process.platform}`);
console.log(`[Node.js] 架构: ${process.arch}`);
console.log();

// 处理命令行参数
// process.argv 结构: [node路径, 脚本路径, 用户参数...]
const args = process.argv.slice(2);

console.log(`[Node.js] 参数数量: ${args.length}`);
console.log();

if (args.length > 0) {
    console.log("[Node.js] 命令行参数:");
    args.forEach((arg, index) => {
        console.log(`  argv[${index}] = "${arg}"`);
    });
} else {
    console.log("[Node.js] 没有命令行参数");
}
console.log();

// 字符串操作演示
console.log("[Node.js] 字符串演示:");
const testStr = "Hello, World!";
console.log(`  原始字符串: ${testStr}`);
console.log(`  长度: ${testStr.length}`);
console.log(`  大写: ${testStr.toUpperCase()}`);
console.log(`  小写: ${testStr.toLowerCase()}`);
console.log(`  子串(0,5): ${testStr.substring(0, 5)}`);
console.log(`  包含'World': ${testStr.includes('World')}`);
console.log();

// 数组操作演示
console.log("[Node.js] 数组操作:");
const fruits = ["apple", "banana", "cherry", "date", "elderberry"];
console.log("  水果列表:");
fruits.forEach((fruit, index) => {
    console.log(`    ${index + 1}. ${fruit}`);
});
console.log(`  数量: ${fruits.length}`);
console.log(`  反转: ${[...fruits].reverse().join(', ')}`);
console.log(`  排序: ${[...fruits].sort().join(', ')}`);
console.log();

// 数学计算演示
console.log("[Node.js] 数学计算:");
console.log(`  圆周率: ${Math.PI}`);
console.log(`  2^10 = ${Math.pow(2, 10)}`);
console.log(`  sqrt(144) = ${Math.sqrt(144)}`);
console.log(`  floor(3.7) = ${Math.floor(3.7)}`);
console.log(`  ceil(3.2) = ${Math.ceil(3.2)}`);
console.log();

// 日期时间
const now = new Date();
console.log(`[Node.js] 当前时间: ${now.toISOString()}`);
console.log(`[Node.js] 本地时间: ${now.toLocaleString('zh-CN')}`);
console.log();

console.log("========================================");
console.log("  脚本执行完成");
console.log("========================================");

// 通过 process.exit 设置退出码 (0 = 成功)
process.exit(0);
