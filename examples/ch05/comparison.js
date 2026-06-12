/**
 * JavaScript字符串操作对比 - 与CMD字符串处理对比
 */

console.log("=== JavaScript字符串操作对比 ===\n");

// 原始字符串
const original = "Hello, World!";
console.log(`原始字符串: ${original}`);
console.log();

// 1. 子串截取
console.log("--- 1. 子串截取 ---");
console.log(`前5个字符: ${original.substring(0, 5)}`);          // CMD: %str:~0,5%
console.log(`从索引7开始: ${original.substring(7)}`);           // CMD: %str:~7%
console.log(`最后6个字符: ${original.slice(-6)}`);              // CMD: %str:~-6%
console.log(`从索引2到5: ${original.substring(2, 5)}`);        // CMD: %str:~2,3%
console.log(`使用slice: ${original.slice(2, 5)}`);             // 另一种方法
console.log();

// 2. 字符串长度
console.log("--- 2. 字符串长度 ---");
console.log(`字符串长度: ${original.length}`);                  // CMD: 需要循环计算
console.log();

// 3. 字符串替换
console.log("--- 3. 字符串替换 ---");
let strReplace = "Hello World Hello CMD";
console.log(`原始字符串: ${strReplace}`);
console.log(`替换Hello为Hi: ${strReplace.replace('Hello', 'Hi')}`);  // CMD: %str:Hello=Hi%
console.log(`替换所有Hello: ${strReplace.replaceAll('Hello', 'Hi')}`); // CMD: 自动替换所有
console.log(`使用正则替换: ${strReplace.replace(/Hello/g, 'Hi')}`);   // CMD: 无直接等价
console.log();

// 4. 字符串查找
console.log("--- 4. 字符串查找 ---");
console.log(`查找World: ${original.indexOf('World')}`);         // CMD: findstr
console.log(`查找xyz: ${original.indexOf('xyz')}`);             // CMD: findstr
console.log(`包含World: ${original.includes('World')}`);        // CMD: findstr + errorlevel
console.log(`以Hello开头: ${original.startsWith('Hello')}`);   // CMD: findstr /R "^Hello"
console.log(`以World结尾: ${original.endsWith('World')}`);      // CMD: findstr /R "World$"
console.log();

// 5. 大小写转换
console.log("--- 5. 大小写转换 ---");
console.log(`大写: ${original.toUpperCase()}`);                 // CMD: 需要循环替换
console.log(`小写: ${original.toLowerCase()}`);                 // CMD: 需要循环替换
console.log();

// 6. 字符串修剪
console.log("--- 6. 字符串修剪 ---");
const strTrim = "   Hello World   ";
console.log(`原始: [${strTrim}]`);
console.log(`去除首尾空格: [${strTrim.trim()}]`);               // CMD: for /F技巧
console.log(`去除左侧空格: [${strTrim.trimStart()}]`);         // CMD: 循环去除
console.log(`去除右侧空格: [${strTrim.trimEnd()}]`);           // CMD: 循环去除
console.log();

// 7. 字符串分割
console.log("--- 7. 字符串分割 ---");
const csvData = "apple,banana,cherry";
console.log(`原始CSV: ${csvData}`);
console.log(`分割结果: ${csvData.split(',')}`);                 // CMD: for /F "tokens="
console.log(`分割次数: ${csvData.split(',', 1)}`);             // CMD: 无直接等价
console.log();

// 8. 字符串连接
console.log("--- 8. 字符串连接 ---");
const words = ["Hello", "World", "CMD"];
console.log(`单词列表: ${words}`);
console.log(`空格连接: ${words.join(' ')}`);                    // CMD: 直接拼接
console.log(`逗号连接: ${words.join(', ')}`);                   // CMD: 需要循环
console.log(`使用模板: ${words[0]} ${words[1]} ${words[2]}`);   // CMD: %var%拼接
console.log();

// 9. 字符串格式化
console.log("--- 9. 字符串格式化 ---");
const name = "张三";
const age = 25;
console.log(`模板字符串: ${name}今年${age}岁`);                 // CMD: %var%拼接
console.log(`concat方法: ${name.concat('今年', age.toString(), '岁')}`);
console.log();

// 10. 正则表达式
console.log("--- 10. 正则表达式 ---");
const text = "abc123def456";
const numbers = text.match(/\d+/g);
console.log(`原始文本: ${text}`);
console.log(`提取数字: ${numbers}`);                           // CMD: findstr /R 有限支持
console.log(`替换数字: ${text.replace(/\d+/g, '*')}`);         // CMD: 无直接等价
console.log();

// 11. 中文字符处理
console.log("--- 11. 中文字符处理 ---");
const chinese = "你好世界";
console.log(`中文字符串: ${chinese}`);
console.log(`长度: ${chinese.length}`);                        // CMD: 需要特殊处理
console.log(`前2个字符: ${chinese.substring(0, 2)}`);          // CMD: %str:~0,4% (GBK)
console.log(`使用Array.from: ${Array.from(chinese).slice(0, 2).join('')}`);
console.log();

// 12. 字符串检查
console.log("--- 12. 字符串检查 ---");
const testStr = "Hello123";
console.log(`测试字符串: ${testStr}`);
console.log(`是否全字母: ${/^[a-zA-Z]+$/.test(testStr)}`);    // CMD: 无直接等价
console.log(`是否全数字: ${/^\d+$/.test(testStr)}`);           // CMD: 无直接等价
console.log(`是否字母数字: ${/^[a-zA-Z0-9]+$/.test(testStr)}`); // CMD: 无直接等价
console.log();

// 13. 重复字符串
console.log("--- 13. 重复字符串 ---");
console.log(`重复5次: ${'Hello'.repeat(5)}`);                  // CMD: 无直接等价
console.log();

// 14. 填充字符串
console.log("--- 14. 填充字符串 ---");
console.log(`左填充: ${'42'.padStart(5, '0')}`);               // CMD: 无直接等价
console.log(`右填充: ${'42'.padEnd(5, '*')}`);                 // CMD: 无直接等价
console.log();