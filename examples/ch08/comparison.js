// JavaScript数据结构对比示例
// 展示JavaScript中内置数据结构的使用，与CMD的模拟方式对比

console.log("=== JavaScript数据结构对比示例 ===");
console.log();

// 1. 数组
console.log("=== 1. 数组 ===");
const fruits = ["Apple", "Banana", "Cherry", "Date"];
console.log(`数组: ${fruits}`);
console.log(`长度: ${fruits.length}`);
console.log(`第一个元素: ${fruits[0]}`);
console.log(`最后一个元素: ${fruits[fruits.length - 1]}`);

// 添加元素
fruits.push("Elderberry");
console.log(`添加后: ${fruits}`);

// 修改元素
fruits[1] = "Blueberry";
console.log(`修改后: ${fruits}`);

// 遍历
console.log("遍历数组:");
fruits.forEach((fruit, index) => {
    console.log(`  [${index}] = ${fruit}`);
});

console.log();

// 2. Map（字典）
console.log("=== 2. Map（字典）===");
const person = new Map([
    ["name", "Alice"],
    ["age", 25],
    ["city", "Beijing"],
    ["role", "Developer"]
]);

console.log(`Map: ${JSON.stringify(Object.fromEntries(person))}`);
console.log(`姓名: ${person.get("name")}`);
console.log(`年龄: ${person.get("age")}`);

// 修改Map
person.set("age", 26);
console.log(`修改后年龄: ${person.get("age")}`);

// 遍历Map
console.log("遍历Map:");
person.forEach((value, key) => {
    console.log(`  ${key} = ${value}`);
});

console.log();

// 3. Set（集合）
console.log("=== 3. Set（集合）===");
const fruitsSet = new Set(["Apple", "Banana", "Cherry", "Apple"]); // 重复的Apple会被自动去除
console.log(`Set: ${[...fruitsSet]}`);
console.log(`Set大小: ${fruitsSet.size}`);

// 添加元素
fruitsSet.add("Date");
console.log(`添加后: ${[...fruitsSet]}`);

// Set操作
const set1 = new Set([1, 2, 3, 4, 5]);
const set2 = new Set([4, 5, 6, 7, 8]);
console.log(`Set1: ${[...set1]}`);
console.log(`Set2: ${[...set2]}`);

// 交集
const intersection = new Set([...set1].filter(x => set2.has(x)));
console.log(`交集: ${[...intersection]}`);

// 并集
const union = new Set([...set1, ...set2]);
console.log(`并集: ${[...union]}`);

// 差集
const difference = new Set([...set1].filter(x => !set2.has(x)));
console.log(`差集: ${[...difference]}`);

console.log();

// 4. 栈（使用数组实现）
console.log("=== 4. 栈（后进先出）===");
const stack = [];

// 入栈
stack.push("First");
stack.push("Second");
stack.push("Third");
console.log(`栈: ${stack}`);

// 出栈
let item = stack.pop();
console.log(`弹出: ${item}`);
item = stack.pop();
console.log(`弹出: ${item}`);
console.log(`剩余栈: ${stack}`);

console.log();

// 5. 队列（使用数组实现）
console.log("=== 5. 队列（先进先出）===");
const queue = [];

// 入队
queue.push("Task A");
queue.push("Task B");
queue.push("Task C");
console.log(`队列: ${queue}`);

// 出队
item = queue.shift();
console.log(`出队: ${item}`);
item = queue.shift();
console.log(`出队: ${item}`);
console.log(`剩余队列: ${queue}`);

console.log();

// 6. 多维数组（矩阵）
console.log("=== 6. 多维数组（矩阵）===");
const matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
];

console.log("矩阵:");
matrix.forEach(row => {
    console.log(`  ${row}`);
});

// 访问元素
console.log(`matrix[1][2] = ${matrix[1][2]}`);

// 矩阵转置
const transposed = matrix[0].map((_, colIndex) => matrix.map(row => row[colIndex]));
console.log("转置矩阵:");
transposed.forEach(row => {
    console.log(`  ${row}`);
});

console.log();

// 7. 数据持久化
console.log("=== 7. 数据持久化 ===");
const data = {
    name: "Alice",
    age: 25,
    scores: [95, 87, 92]
};

// JSON序列化
const jsonString = JSON.stringify(data, null, 2);
console.log("JSON字符串:");
console.log(jsonString);

// JSON反序列化
const loadedData = JSON.parse(jsonString);
console.log(`加载的数据: ${JSON.stringify(loadedData)}`);

// localStorage示例（浏览器环境）
// localStorage.setItem('data', JSON.stringify(data));
// const fromStorage = JSON.parse(localStorage.getItem('data'));

console.log();

// 8. 性能对比
console.log("=== 8. 性能对比 ===");

// 数组性能
let start = performance.now();
const bigArray = Array.from({ length: 1000000 }, (_, i) => i);
let arrayCreateTime = performance.now() - start;

start = performance.now();
const _ = bigArray[500000];
let arrayAccessTime = performance.now() - start;

console.log(`创建100万元素数组: ${arrayCreateTime.toFixed(2)}毫秒`);
console.log(`访问数组元素: ${arrayAccessTime.toFixed(4)}毫秒`);

// Map性能
start = performance.now();
const bigMap = new Map();
for (let i = 0; i < 1000000; i++) {
    bigMap.set(i, i * 2);
}
let mapCreateTime = performance.now() - start;

start = performance.now();
const __ = bigMap.get(500000);
let mapAccessTime = performance.now() - start;

console.log(`创建100万元素Map: ${mapCreateTime.toFixed(2)}毫秒`);
console.log(`访问Map元素: ${mapAccessTime.toFixed(4)}毫秒`);

console.log();

// 9. 类型系统对比
console.log("=== 9. 类型系统对比 ===");

// JavaScript的动态类型
let dynamicVar = "Hello";
console.log(`类型: ${typeof dynamicVar}, 值: ${dynamicVar}`);
dynamicVar = 42;
console.log(`类型: ${typeof dynamicVar}, 值: ${dynamicVar}`);
dynamicVar = true;
console.log(`类型: ${typeof dynamicVar}, 值: ${dynamicVar}`);

console.log();

// 10. 错误处理对比
console.log("=== 10. 错误处理对比 ===");

try {
    // 尝试访问不存在的数组元素
    const arr = [1, 2, 3];
    const value = arr[10]; // 返回undefined，不会报错
    console.log(`访问越界: ${value}`);
    
    // 尝试调用不存在的函数
    // arr.nonExistentFunction(); // 会抛出错误
} catch (error) {
    console.log(`捕获错误: ${error.message}`);
}

console.log();

console.log("=== 对比总结 ===");
console.log("JavaScript内置数据结构的优势:");
console.log("1. 丰富的内置数据结构（Array, Map, Set, WeakMap等）");
console.log("2. 高性能的V8引擎优化");
console.log("3. 动态类型，灵活易用");
console.log("4. 异步编程支持");
console.log("5. 浏览器和Node.js通用");
console.log();
console.log("CMD模拟数据结构的限制:");
console.log("1. 需要手动模拟，代码复杂");
console.log("2. 性能较差，特别是大数据量");
console.log("3. 变量数量有限制");
console.log("4. 缺少类型检查和错误处理");
console.log("5. 调试困难，没有开发者工具");