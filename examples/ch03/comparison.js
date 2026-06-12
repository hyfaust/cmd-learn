// JavaScript 条件语句对比示例
// 用于与CMD的if语句进行对比

console.log("JavaScript 条件语句示例");
console.log("=".repeat(50));

// 1. 基本if/else if/else
console.log("\n1. 基本if/else if/else:");
let score = 85;

if (score >= 90) {
    console.log("   成绩优秀");
} else if (score >= 80) {
    console.log("   成绩良好");
} else if (score >= 60) {
    console.log("   成绩及格");
} else {
    console.log("   成绩不及格");
}

// 2. 字符串比较
console.log("\n2. 字符串比较:");
let name = "test";

if (name === "test") {
    console.log("   字符串相等 (===)");
} else {
    console.log("   字符串不相等 (===)");
}

// 3. 数值比较运算符
console.log("\n3. 数值比较运算符:");
let a = 10;
let b = 20;

console.log(`   比较 ${a} 和 ${b}:`);
console.log(`   ${a} == ${b}: ${a == b}`);
console.log(`   ${a} === ${b}: ${a === b}`);
console.log(`   ${a} != ${b}: ${a != b}`);
console.log(`   ${a} !== ${b}: ${a !== b}`);
console.log(`   ${a} < ${b}: ${a < b}`);
console.log(`   ${a} <= ${b}: ${a <= b}`);
console.log(`   ${a} > ${b}: ${a > b}`);
console.log(`   ${a} >= ${b}: ${a >= b}`);

// 4. 字符串比较与数值比较的区别
console.log("\n4. 字符串比较与数值比较的区别:");
let str1 = "10";
let str2 = "010";

// 字符串比较
if (str1 === str2) {
    console.log(`   字符串比较: "${str1}" === "${str2}" = 相等`);
} else {
    console.log(`   字符串比较: "${str1}" === "${str2}" = 不相等`);
}

// 数值比较
if (parseInt(str1) === parseInt(str2)) {
    console.log(`   数值比较: ${parseInt(str1)} === ${parseInt(str2)} = 相等`);
} else {
    console.log(`   数值比较: ${parseInt(str1)} === ${parseInt(str2)} = 不相等`);
}

// 5. 文件存在性检查 (Node.js)
console.log("\n5. 文件存在性检查 (Node.js):");
const fs = require('fs');
const path = require('path');

const currentDir = __dirname;

// 检查文件
if (fs.existsSync(path.join(currentDir, 'if_basics.bat'))) {
    console.log("   if_basics.bat 存在");
} else {
    console.log("   if_basics.bat 不存在");
}

// 检查目录
if (fs.existsSync(path.join(currentDir, '..', 'ch02'))) {
    console.log("   ch02目录存在");
} else {
    console.log("   ch02目录不存在");
}

// 6. 逻辑运算符
console.log("\n6. 逻辑运算符:");
let x = 15;

// && (逻辑与)
if (x > 10 && x < 20) {
    console.log(`   ${x} 在10到20之间 (&&)`);
}

// || (逻辑或)
if (x < 10 || x > 20) {
    console.log(`   ${x} 小于10或大于20 (||)`);
} else {
    console.log(`   ${x} 不在范围外 (||)`);
}

// ! (逻辑非)
if (!(x > 100)) {
    console.log(`   ${x} 不大于100 (!)`);
}

// 7. 条件表达式（三元运算符）
console.log("\n7. 条件表达式（三元运算符）:");
let age = 20;
let status = age >= 18 ? "成年" : "未成年";
console.log(`   年龄: ${age}, 状态: ${status}`);

// 8. 多条件检查
console.log("\n8. 多条件检查:");
let username = "admin";
let password = "123456";

if (username === "admin" && password === "123456") {
    console.log("   登录成功");
} else {
    console.log("   登录失败");
}

// 9. 类型检查
console.log("\n9. 类型检查:");
let value = "123";

if (typeof value === "string") {
    console.log(`   '${value}' 是字符串`);
} else if (typeof value === "number") {
    console.log(`   ${value} 是数字`);
}

// 10. 空值检查
console.log("\n10. 空值检查:");
let emptyArray = [];
let nullValue = null;
let undefinedValue = undefined;

if (emptyArray.length === 0) {
    console.log("   空数组长度为0");
}

if (nullValue === null) {
    console.log("   null值检查");
}

if (undefinedValue === undefined) {
    console.log("   undefined值检查");
}

// 11. switch语句
console.log("\n11. switch语句:");
let day = "Monday";

switch (day) {
    case "Monday":
    case "Tuesday":
    case "Wednesday":
    case "Thursday":
    case "Friday":
        console.log(`   ${day} 是工作日`);
        break;
    case "Saturday":
    case "Sunday":
        console.log(`   ${day} 是周末`);
        break;
    default:
        console.log(`   ${day} 无效`);
}

// 12. 可选链操作符 (ES2020)
console.log("\n12. 可选链操作符 (ES2020):");
let user = {
    profile: {
        name: "John"
    }
};

// 传统写法
if (user && user.profile && user.profile.name) {
    console.log(`   传统写法: ${user.profile.name}`);
}

// 可选链写法
if (user?.profile?.name) {
    console.log(`   可选链写法: ${user.profile.name}`);
}

console.log("\nJavaScript条件语句示例完成");