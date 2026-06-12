/**
 * comparison.c - C语言与CMD对比示例
 * 说明：展示C语言中与CMD等价的功能实现
 * 编译：gcc comparison.c -o comparison.exe
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

// 函数声明
void print_comparison(const char* cmd_example, const char* c_example, const char* result);

int main() {
    printf("==================================================\n");
    printf("       C语言与CMD对比示例\n");
    printf("==================================================\n\n");
    
    // 1. 输出对比
    // CMD: echo Hello, World!
    // C: printf("Hello, World!\n");
    print_comparison(
        "echo Hello, World!",
        "printf(\"Hello, World!\\n\");",
        "Hello, World!"
    );
    
    // 2. 变量定义对比
    // CMD: set "name=CMD学习者"
    // C: char name[] = "C学习者";
    print_comparison(
        "set \"name=CMD学习者\"",
        "char name[] = \"C学习者\";",
        "C学习者"
    );
    
    // 3. 算术运算对比
    // CMD: set /a "result=5+3"
    // C: int result = 5 + 3;
    print_comparison(
        "set /a \"result=5+3\"",
        "int result = 5 + 3;",
        "8"
    );
    
    // 4. 用户输入对比
    // CMD: set /p "user_input=请输入: "
    // C: scanf("%s", user_input);
    print_comparison(
        "set /p \"user_input=请输入: \"",
        "scanf(\"%s\", user_input);",
        "需要手动处理输入"
    );
    
    // 5. 条件判断对比
    // CMD: if "%var%"=="value" (echo 真) else (echo 假)
    // C: if (strcmp(var, "value") == 0) { printf("真"); } else { printf("假"); }
    print_comparison(
        "if \"%var%\"==\"value\" (echo 真) else (echo 假)",
        "if (strcmp(var, \"value\") == 0) { printf(\"真\"); } else { printf(\"假\"); }",
        "真"
    );
    
    // 6. 循环对比
    // CMD: for /l %%i in (1,1,5) do echo %%i
    // C: for (int i = 1; i <= 5; i++) { printf("%d\n", i); }
    printf("6. 循环对比:\n");
    printf("   CMD: for /l %%%%i in (1,1,5) do echo %%%%i\n");
    printf("   C: for (int i = 1; i <= 5; i++) { printf(\"%%d\\n\", i); }\n");
    printf("   结果:\n");
    for (int i = 1; i <= 5; i++) {
        printf("     %d\n", i);
    }
    printf("\n");
    
    // 7. 字符串处理对比
    // CMD: set "str=Hello %name%"
    // C: sprintf(str, "Hello %s", name);
    print_comparison(
        "set \"str=Hello %name%\"",
        "sprintf(str, \"Hello %%s\", name);",
        "Hello C学习者"
    );
    
    // 8. 文件操作对比
    // CMD: type file.txt
    // C: fopen/fgets/fclose
    print_comparison(
        "type file.txt",
        "fopen/fgets/fclose",
        "需要手动处理文件"
    );
    
    // 9. 环境变量对比
    // CMD: %PATH%
    // C: getenv("PATH")
    print_comparison(
        "%PATH%",
        "getenv(\"PATH\")",
        "需要检查NULL"
    );
    
    // 10. 错误处理对比
    // CMD: command || echo 错误
    // C: if (system("command") != 0) { printf("错误"); }
    print_comparison(
        "command || echo 错误",
        "if (system(\"command\") != 0) { printf(\"错误\"); }",
        "使用返回值检查"
    );
    
    // 11. 注释对比
    // CMD: :: 注释 或 REM 注释
    // C: // 注释 或 /* 多行注释 */
    print_comparison(
        ":: 注释 或 REM 注释",
        "// 注释 或 /* 多行注释 */",
        "无"
    );
    
    // 12. 内存管理对比
    // CMD: 无内存管理
    // C: malloc/free
    printf("12. 内存管理对比:\n");
    printf("    CMD: 无内存管理，变量自动管理\n");
    printf("    C: malloc/free 手动管理内存\n");
    printf("    说明: C语言需要手动管理内存，容易出现内存泄漏\n");
    printf("\n");
    
    printf("==================================================\n");
    printf("       C语言与CMD对比完成\n");
    printf("==================================================\n\n");
    
    printf("主要差异总结:\n");
    printf("1. C语言是编译型语言，CMD是解释型脚本\n");
    printf("2. C语言有严格的类型系统，CMD所有变量都是字符串\n");
    printf("3. C语言需要手动管理内存，CMD自动管理\n");
    printf("4. C语言性能更高，CMD更易于编写\n");
    printf("5. C语言跨平台，CMD仅限Windows\n");
    printf("6. C语言有标准库，CMD功能有限\n");
    
    return 0;
}

/**
 * 打印对比信息
 */
void print_comparison(const char* cmd_example, const char* c_example, const char* result) {
    static int count = 1;
    
    printf("%d. 输出对比:\n", count);
    printf("   CMD: %s\n", cmd_example);
    printf("   C: %s\n", c_example);
    printf("   结果: %s\n\n", result);
    
    count++;
}