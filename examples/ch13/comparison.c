/**
 * comparison.c - C 语言 system/popen 示例
 * 
 * 功能: 演示 C 语言如何调用外部命令和程序
 * 编译: gcc comparison.c -o comparison.exe
 * 用法: comparison.exe
 * 安全提示: 仅在项目目录内操作
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef _WIN32
#include <windows.h>
#define popen _popen
#define pclose _pclose
#endif

/**
 * 演示 system() 函数
 */
void demo_system(void) {
    int exit_code;
    
    printf("==================================================\n");
    printf("  方式 1: system() - 简单执行\n");
    printf("==================================================\n\n");
    
    /* 简单命令 */
    printf("[C] 执行 'echo' 命令:\n");
    system("echo Hello from system()");
    printf("\n");
    
    /* 获取退出码 */
    printf("[C] 执行 'dir /b' 命令:\n");
    exit_code = system("dir /b *.c");
    printf("[C] 退出码: %d\n\n", exit_code);
    
    /* 失败的命令 */
    printf("[C] 执行不存在的命令:\n");
    exit_code = system("nonexistent_command 2>nul");
    printf("[C] 退出码: %d\n\n", exit_code);
}

/**
 * 演示 popen() 管道读取
 */
void demo_popen_read(void) {
    FILE *pipe;
    char buffer[256];
    
    printf("==================================================\n");
    printf("  方式 2: popen() - 管道读取\n");
    printf("==================================================\n\n");
    
    printf("[C] 通过管道读取 'hostname' 输出:\n");
    pipe = popen("hostname", "r");
    if (pipe) {
        if (fgets(buffer, sizeof(buffer), pipe)) {
            /* 移除末尾换行符 */
            buffer[strcspn(buffer, "\n")] = 0;
            printf("  主机名: %s\n", buffer);
        }
        pclose(pipe);
    }
    printf("\n");
    
    /* 读取多行输出 */
    printf("[C] 通过管道读取 'dir /b' 输出:\n");
    pipe = popen("dir /b *.c", "r");
    if (pipe) {
        int count = 0;
        while (fgets(buffer, sizeof(buffer), pipe)) {
            buffer[strcspn(buffer, "\n")] = 0;
            printf("  文件: %s\n", buffer);
            count++;
        }
        printf("  共 %d 个文件\n", count);
        pclose(pipe);
    }
    printf("\n");
}

/**
 * 演示 popen() 管道写入
 */
void demo_popen_write(void) {
    FILE *pipe;
    char buffer[256];
    
    printf("==================================================\n");
    printf("  方式 3: popen() - 管道写入\n");
    printf("==================================================\n\n");
    
    printf("[C] 通过管道写入数据:\n");
    pipe = popen("findstr /i \"hello\"", "w");
    if (pipe) {
        fprintf(pipe, "Hello World\n");
        fprintf(pipe, "Test Line\n");
        fprintf(pipe, "hello again\n");
        fprintf(pipe, "Another test\n");
        pclose(pipe);
    }
    printf("\n");
}

/**
 * 演示多命令管道
 */
void demo_pipe_chain(void) {
    FILE *pipe;
    char buffer[256];
    
    printf("==================================================\n");
    printf("  方式 4: 管道链\n");
    printf("==================================================\n\n");
    
    printf("[C] 执行管道链命令:\n");
    pipe = popen("echo apple & echo banana & echo cherry | sort", "r");
    if (pipe) {
        printf("  排序结果:\n");
        while (fgets(buffer, sizeof(buffer), pipe)) {
            buffer[strcspn(buffer, "\n")] = 0;
            printf("    %s\n", buffer);
        }
        pclose(pipe);
    }
    printf("\n");
}

/**
 * 演示获取命令输出到字符串
 */
void demo_capture_output(void) {
    FILE *pipe;
    char buffer[1024] = {0};
    char *pos = buffer;
    size_t remaining = sizeof(buffer) - 1;
    
    printf("==================================================\n");
    printf("  方式 5: 捕获完整输出\n");
    printf("==================================================\n\n");
    
    printf("[C] 捕获 'systeminfo' 部分输出:\n");
    pipe = popen("systeminfo | findstr /i \"OS\"", "r");
    if (pipe) {
        while (fgets(pos, remaining, pipe) && remaining > 0) {
            size_t len = strlen(pos);
            pos += len;
            remaining -= len;
        }
        pclose(pipe);
        
        /* 输出捕获的内容 */
        printf("  系统信息:\n");
        char *line = strtok(buffer, "\n");
        while (line) {
            printf("    %s\n", line);
            line = strtok(NULL, "\n");
        }
    }
    printf("\n");
}

/**
 * 主函数
 */
int main(void) {
    printf("\n");
    printf("+================================================+\n");
    printf("|        C 语言 system/popen 示例               |\n");
    printf("+================================================+\n\n");
    
    /* 演示各种调用方式 */
    demo_system();
    demo_popen_read();
    demo_popen_write();
    demo_pipe_chain();
    demo_capture_output();
    
    printf("==================================================\n");
    printf("  演示完成\n");
    printf("==================================================\n");
    
    return 0;
}
