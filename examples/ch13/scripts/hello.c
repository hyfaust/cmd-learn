/**
 * hello.c - C 示例程序
 * 
 * 功能: 接收命令行参数并输出信息
 * 编译: gcc hello.c -o hello.exe
 * 用法: hello.exe [arg1] [arg2] ...
 * 安全提示: 仅在项目目录内操作
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef _WIN32
#include <windows.h>
#endif

/**
 * 获取系统信息（Windows 特有）
 */
void print_system_info(void) {
#ifdef _WIN32
    char computer_name[256];
    DWORD size = sizeof(computer_name);
    
    if (GetComputerNameA(computer_name, &size)) {
        printf("[C] 计算机名: %s\n", computer_name);
    }
    
    printf("[C] 操作系统: Windows\n");
#else
    printf("[C] 操作系统: 非 Windows\n");
#endif
}

/**
 * 主函数
 */
int main(int argc, char *argv[]) {
    int i;
    
    printf("========================================\n");
    printf("  C 程序示例\n");
    printf("========================================\n\n");
    
    /* 输出程序名称 */
    printf("[C] 程序: %s\n", argv[0]);
    printf("[C] 参数数量: %d\n\n", argc);
    
    /* 输出所有参数 */
    printf("[C] 命令行参数:\n");
    for (i = 0; i < argc; i++) {
        printf("  argv[%d] = \"%s\"\n", i, argv[i]);
    }
    printf("\n");
    
    /* 输出系统信息 */
    printf("[C] 系统信息:\n");
    print_system_info();
    printf("\n");
    
    /* 简单计算演示 */
    printf("[C] 计算演示:\n");
    printf("  1 + 1 = %d\n", 1 + 1);
    printf("  2 * 3 = %d\n", 2 * 3);
    printf("  10 / 3 = %d (整数除法)\n", 10 / 3);
    printf("  10 %% 3 = %d (取余)\n", 10 % 3);
    printf("\n");
    
    printf("========================================\n");
    printf("  程序执行完成\n");
    printf("========================================\n");
    
    /* 返回退出码 (0 = 成功) */
    return 0;
}
