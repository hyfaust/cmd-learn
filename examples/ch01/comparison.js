// comparison.js - JavaScript与CMD对比示例
// 说明：展示JavaScript中与CMD等价的功能实现

console.log("=".repeat(50));
console.log("       JavaScript与CMD对比示例");
console.log("=".repeat(50));
console.log();

// 1. 输出对比
// CMD: echo Hello, World!
// JavaScript: console.log("Hello, World!")
console.log("1. 输出对比:");
console.log("   CMD: echo Hello, World!");
console.log("   JavaScript: console.log('Hello, World!')");
console.log("   结果: Hello, World!");
console.log();

// 2. 变量定义对比
// CMD: set "name=CMD学习者"
// JavaScript: let name = "CMD学习者"
console.log("2. 变量定义对比:");
let name = "JavaScript学习者";
console.log(`   CMD: set "name=CMD学习者"`);
console.log(`   JavaScript: let name = "${name}"`);
console.log(`   结果: ${name}`);
console.log();

// 3. 算术运算对比
// CMD: set /a "result=5+3"
// JavaScript: let result = 5 + 3
console.log("3. 算术运算对比:");
let result = 5 + 3;
console.log(`   CMD: set /a "result=5+3"`);
console.log(`   JavaScript: let result = 5 + 3`);
console.log(`   结果: ${result}`);
console.log();

// 4. 用户输入对比
// CMD: set /p "user_input=请输入: "
// JavaScript: 需要使用readline模块
console.log("4. 用户输入对比:");
console.log("   CMD: set /p \"user_input=请输入: \"");
console.log("   JavaScript: 需要使用readline模块");
console.log("   说明: JavaScript在浏览器中使用prompt()，Node.js中使用readline");
console.log();

// 5. 条件判断对比
// CMD: if "%var%"=="value" (echo 真) else (echo 假)
// JavaScript: if (var === "value") { console.log("真") } else { console.log("假") }
console.log("5. 条件判断对比:");
let choice = "Y";
console.log(`   CMD: if "%choice%"=="Y" (echo 真) else (echo 假)`);
console.log(`   JavaScript: if (choice === "Y") { console.log("真") } else { console.log("假") }`);
if (choice === "Y") {
    console.log("   结果: 真");
} else {
    console.log("   结果: 假");
}
console.log();

// 6. 循环对比
// CMD: for /l %%i in (1,1,5) do echo %%i
// JavaScript: for (let i = 1; i <= 5; i++) { console.log(i); }
console.log("6. 循环对比:");
console.log("   CMD: for /l %%i in (1,1,5) do echo %%i");
console.log("   JavaScript: for (let i = 1; i <= 5; i++) { console.log(i); }");
console.log("   结果:");
for (let i = 1; i <= 5; i++) {
    console.log(`     ${i}`);
}
console.log();

// 7. 字符串处理对比
// CMD: set "str=Hello %name%"
// JavaScript: let str = `Hello ${name}`
console.log("7. 字符串处理对比:");
console.log(`   CMD: set "str=Hello %name%"`);
console.log(`   JavaScript: let str = \`Hello \${name}\``);
let str = `Hello ${name}`;
console.log(`   结果: ${str}`);
console.log();

// 8. 数组/列表对比
// CMD: 无原生数组支持
// JavaScript: let arr = [1, 2, 3, 4, 5]
console.log("8. 数组/列表对比:");
console.log("   CMD: 无原生数组支持，需要特殊处理");
console.log("   JavaScript: let arr = [1, 2, 3, 4, 5]");
let arr = [1, 2, 3, 4, 5];
console.log(`   结果: ${arr}`);
console.log();

// 9. 函数定义对比
// CMD: 无原生函数支持，使用标签和goto
// JavaScript: function myFunc() { ... }
console.log("9. 函数定义对比:");
console.log("   CMD: 使用标签和goto模拟函数");
console.log("   JavaScript: function myFunc() { ... }");
console.log("   说明: JavaScript支持真正的函数和闭包");
console.log();

// 10. 错误处理对比
// CMD: command || echo 错误
// JavaScript: try { ... } catch (e) { ... }
console.log("10. 错误处理对比:");
console.log("    CMD: command || echo 错误");
console.log("    JavaScript: try { ... } catch (e) { ... }");
console.log("    说明: JavaScript的异常处理更精细，支持堆栈跟踪");
console.log();

// 11. 注释对比
// CMD: :: 注释 或 REM 注释
// JavaScript: // 注释 或 /* 多行注释 */
console.log("11. 注释对比:");
console.log("    CMD: :: 注释 或 REM 注释");
console.log("    JavaScript: // 注释 或 /* 多行注释 */");
console.log();

// 12. 模块系统对比
// CMD: call other.bat
// JavaScript: import/export 或 require/module.exports
console.log("12. 模块系统对比:");
console.log("    CMD: call other.bat");
console.log("    JavaScript: import/export 或 require/module.exports");
console.log("    说明: JavaScript有完整的模块系统，CMD通过call调用其他脚本");
console.log();

console.log("=".repeat(50));
console.log("       JavaScript与CMD对比完成");
console.log("=".repeat(50));
console.log();
console.log("主要差异总结:");
console.log("1. JavaScript有完整的类型系统，CMD所有变量都是字符串");
console.log("2. JavaScript支持异步编程，CMD是同步执行");
console.log("3. JavaScript有面向对象支持，CMD是过程式脚本");
console.log("4. JavaScript有标准库和包管理，CMD功能有限");
console.log("5. JavaScript跨平台，CMD仅限Windows");