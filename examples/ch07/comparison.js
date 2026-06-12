// ============================================================
// comparison.js - JavaScript函数对比
// 第07章 函数与模块化示例
//
// 安全提示：本脚本仅进行变量操作和控制流演示
// ============================================================

// JavaScript中的函数定义和调用示例

// 1. 函数声明
function greet(name) {
    // 对应CMD的:greet
    console.log(`你好, ${name}! 欢迎学习批处理编程。`);
}

// 2. 函数表达式
const add = function(a, b) {
    // 对应CMD的:add
    return a + b;
};

// 3. 箭头函数（ES6+）
const multiply = (a, b) => a * b;

// 4. 默认参数
function greetWithDefault(name, greeting = "Hello") {
    return `${greeting}, ${name}!`;
}

// 5. 剩余参数
function sumAll(...args) {
    // 对应CMD的sum_array
    return args.reduce((sum, num) => sum + num, 0);
}

// 6. 解构参数
function showPerson({ name, age, city }) {
    console.log(`姓名: ${name}, 年龄: ${age}, 城市: ${city}`);
}

// 7. 闭包
function makeCounter() {
    // 对应CMD没有的概念
    let count = 0;
    return function() {
        count++;
        return count;
    };
}

// 8. 高阶函数
function withLogging(fn) {
    return function(...args) {
        console.log(`调用函数，参数: ${args}`);
        const result = fn(...args);
        console.log(`返回结果: ${result}`);
        return result;
    };
}

// 9. 立即执行函数（IIFE）
const result = (function() {
    // 对应CMD的setlocal/endlocal作用域
    const localVar = "I am local";
    return localVar;
})();

// 10. Generator函数（ES6+）
function* numberGenerator(start, end) {
    for (let i = start; i <= end; i++) {
        yield i;
    }
}

// ============================================================
// 主程序
// ============================================================
console.log("=".repeat(50));
console.log("JavaScript函数对比演示");
console.log("=".repeat(50));
console.log();

// 调用基本函数
console.log("=== 基本函数调用 ===");
greet("Alice");
greet("Bob");
console.log();

// 函数表达式
console.log("=== 函数表达式 ===");
console.log(`add(3, 5) = ${add(3, 5)}`);
console.log(`multiply(4, 6) = ${multiply(4, 6)}`);
console.log();

// 默认参数
console.log("=== 默认参数 ===");
console.log(greetWithDefault("Alice"));
console.log(greetWithDefault("Bob", "Hi"));
console.log();

// 剩余参数
console.log("=== 剩余参数 ===");
console.log(`sumAll(1, 2, 3, 4, 5) = ${sumAll(1, 2, 3, 4, 5)}`);
console.log();

// 解构参数
console.log("=== 解构参数 ===");
showPerson({ name: "Alice", age: 25, city: "New York" });
console.log();

// 闭包
console.log("=== 闭包演示 ===");
const counter = makeCounter();
console.log(`计数: ${counter()}`);
console.log(`计数: ${counter()}`);
console.log(`计数: ${counter()}`);
console.log();

// 高阶函数
console.log("=== 高阶函数 ===");
const loggedAdd = withLogging(add);
loggedAdd(10, 20);
console.log();

// IIFE
console.log("=== 立即执行函数(IIFE) ===");
console.log(`result: ${result}`);
console.log();

// Generator
console.log("=== Generator函数 ===");
for (const num of numberGenerator(1, 5)) {
    console.log(num);
}
console.log();

// 数组方法（函数式编程）
console.log("=== 数组方法（函数式编程）===");
const numbers = [1, 2, 3, 4, 5];
const squares = numbers.map(x => x ** 2);
console.log(`1-5的平方: ${squares}`);

const evens = numbers.filter(x => x % 2 === 0);
console.log(`偶数: ${evens}`);

const sum = numbers.reduce((acc, val) => acc + val, 0);
console.log(`总和: ${sum}`);
