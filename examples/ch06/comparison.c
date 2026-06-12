/**
 * comparison.c - C语言文件I/O对比示例
 * 
 * 本文件展示C语言中文件I/O操作，用于与CMD的文件I/O进行对比。
 * C语言提供了低级的文件操作API，需要手动管理资源。
 * 
 * 编译命令: gcc -o comparison.exe comparison.c
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <sys/stat.h>
#include <time.h>

#ifdef _WIN32
#include <direct.h>
#include <io.h>
#define mkdir(path, mode) _mkdir(path)
#define rmdir(path) _rmdir(path)
#else
#include <unistd.h>
#include <sys/types.h>
#endif

/* 测试目录名 */
#define TEST_DIR "test_output"
#define MAX_PATH_LEN 1024
#define MAX_LINE_LEN 1024

/**
 * 确保测试目录存在
 */
int ensure_test_dir() {
    struct stat st = {0};
    
    if (stat(TEST_DIR, &st) == -1) {
        if (mkdir(TEST_DIR, 0700) != 0) {
            perror("创建目录失败");
            return -1;
        }
    }
    return 0;
}

/**
 * 演示基本文件I/O
 */
void demonstrate_basic_io() {
    FILE *file;
    char filepath[MAX_PATH_LEN];
    char buffer[MAX_LINE_LEN];
    
    printf("=== C语言基本文件I/O ===\n\n");
    
    /* 构建文件路径 */
    snprintf(filepath, sizeof(filepath), "%s/output.txt", TEST_DIR);
    
    /* 1. 写入文件（覆盖模式） */
    printf("1. 写入文件（覆盖模式）\n");
    file = fopen(filepath, "w");
    if (file == NULL) {
        perror("打开文件失败");
        return;
    }
    
    fprintf(file, "Hello World\n");
    fprintf(file, "C语言文件写入\n");
    fprintf(file, "第三行内容\n");
    fclose(file);
    
    /* 读取并显示 */
    file = fopen(filepath, "r");
    if (file == NULL) {
        perror("打开文件失败");
        return;
    }
    
    printf("文件内容:\n");
    while (fgets(buffer, sizeof(buffer), file) != NULL) {
        printf("%s", buffer);
    }
    fclose(file);
    
    /* 2. 追加写入 */
    printf("\n2. 追加写入\n");
    file = fopen(filepath, "a");
    if (file == NULL) {
        perror("打开文件失败");
        return;
    }
    
    fprintf(file, "追加的第一行\n");
    fprintf(file, "追加的第二行\n");
    fclose(file);
    
    /* 读取并显示 */
    file = fopen(filepath, "r");
    if (file == NULL) {
        perror("打开文件失败");
        return;
    }
    
    printf("追加后内容:\n");
    while (fgets(buffer, sizeof(buffer), file) != NULL) {
        printf("%s", buffer);
    }
    fclose(file);
}

/**
 * 演示逐行读取
 */
void demonstrate_line_by_line() {
    FILE *file;
    char filepath[MAX_PATH_LEN];
    char line[MAX_LINE_LEN];
    int line_number;
    
    printf("\n=== 逐行读取 ===\n\n");
    
    /* 创建测试文件 */
    snprintf(filepath, sizeof(filepath), "%s/lines.txt", TEST_DIR);
    file = fopen(filepath, "w");
    if (file == NULL) {
        perror("创建文件失败");
        return;
    }
    
    for (int i = 1; i <= 5; i++) {
        fprintf(file, "Line %d: This is line number %d\n", i, i);
    }
    fclose(file);
    
    /* 方法1: 使用fgets逐行读取 */
    printf("方法1: 使用fgets逐行读取\n");
    file = fopen(filepath, "r");
    if (file == NULL) {
        perror("打开文件失败");
        return;
    }
    
    line_number = 0;
    while (fgets(line, sizeof(line), file) != NULL) {
        line_number++;
        /* 移除换行符 */
        line[strcspn(line, "\n")] = '\0';
        printf("  %d: %s\n", line_number, line);
    }
    fclose(file);
    
    /* 方法2: 使用fgetc逐字符读取 */
    printf("\n方法2: 使用fgetc逐字符读取\n");
    file = fopen(filepath, "r");
    if (file == NULL) {
        perror("打开文件失败");
        return;
    }
    
    int ch;
    int char_count = 0;
    printf("  ");
    while ((ch = fgetc(file)) != EOF) {
        putchar(ch);
        char_count++;
    }
    printf("  字符数: %d\n", char_count);
    fclose(file);
}

/**
 * 演示文件操作
 */
void demonstrate_file_operations() {
    char filepath[MAX_PATH_LEN];
    char newpath[MAX_PATH_LEN];
    char copypath[MAX_PATH_LEN];
    struct stat file_stat;
    
    printf("\n=== 文件操作 ===\n\n");
    
    /* 创建测试文件 */
    snprintf(filepath, sizeof(filepath), "%s/operations.txt", TEST_DIR);
    FILE *file = fopen(filepath, "w");
    if (file == NULL) {
        perror("创建文件失败");
        return;
    }
    fprintf(file, "测试文件操作\n");
    fclose(file);
    
    /* 1. 检查文件是否存在 */
    printf("1. 文件存在: %s\n", (access(filepath, F_OK) == 0) ? "是" : "否");
    
    /* 2. 获取文件信息 */
    if (stat(filepath, &file_stat) == 0) {
        printf("2. 文件信息:\n");
        printf("   大小: %ld 字节\n", (long)file_stat.st_size);
        printf("   修改时间: %s", ctime(&file_stat.st_mtime));
    } else {
        perror("获取文件信息失败");
    }
    
    /* 3. 重命名文件 */
    snprintf(newpath, sizeof(newpath), "%s/renamed.txt", TEST_DIR);
    if (rename(filepath, newpath) == 0) {
        printf("3. 重命名: operations.txt -> renamed.txt\n");
    } else {
        perror("重命名失败");
    }
    
    /* 4. 复制文件 */
    snprintf(copypath, sizeof(copypath), "%s/copy.txt", TEST_DIR);
    FILE *src = fopen(newpath, "r");
    FILE *dst = fopen(copypath, "w");
    
    if (src && dst) {
        char buffer[1024];
        size_t bytes;
        while ((bytes = fread(buffer, 1, sizeof(buffer), src)) > 0) {
            fwrite(buffer, 1, bytes, dst);
        }
        printf("4. 复制: renamed.txt -> copy.txt\n");
    }
    
    if (src) fclose(src);
    if (dst) fclose(dst);
    
    /* 5. 删除文件 */
    if (remove(copypath) == 0) {
        printf("5. 删除: copy.txt\n");
        printf("   文件存在: %s\n", (access(copypath, F_OK) == 0) ? "是" : "否");
    } else {
        perror("删除失败");
    }
}

/**
 * 演示二进制文件I/O
 */
void demonstrate_binary_io() {
    char filepath[MAX_PATH_LEN];
    FILE *file;
    
    printf("\n=== 二进制文件I/O ===\n\n");
    
    /* 写入二进制数据 */
    printf("写入二进制数据:\n");
    snprintf(filepath, sizeof(filepath), "%s/binary.bin", TEST_DIR);
    
    file = fopen(filepath, "wb");
    if (file == NULL) {
        perror("创建文件失败");
        return;
    }
    
    /* 写入一些字节 */
    unsigned char data[] = {0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x00, 0x01, 0x02, 0x03};
    fwrite(data, sizeof(unsigned char), sizeof(data), file);
    fclose(file);
    
    /* 读取二进制数据 */
    printf("读取二进制数据:\n");
    file = fopen(filepath, "rb");
    if (file == NULL) {
        perror("打开文件失败");
        return;
    }
    
    unsigned char buffer[100];
    size_t bytes_read = fread(buffer, 1, sizeof(buffer), file);
    fclose(file);
    
    printf("  原始字节: ");
    for (size_t i = 0; i < bytes_read; i++) {
        printf("%02X ", buffer[i]);
    }
    printf("\n");
    
    printf("  解码为字符串: ");
    for (size_t i = 0; i < 5; i++) {
        printf("%c", buffer[i]);
    }
    printf("\n");
}

/**
 * 演示错误处理
 */
void demonstrate_error_handling() {
    FILE *file;
    char filepath[MAX_PATH_LEN];
    
    printf("\n=== 错误处理 ===\n\n");
    
    /* 1. 文件不存在 */
    printf("1. 文件不存在错误:\n");
    file = fopen("nonexistent.txt", "r");
    if (file == NULL) {
        printf("   捕获错误: %s\n", strerror(errno));
        printf("   错误代码: %d\n", errno);
    }
    
    /* 2. 权限错误（模拟） */
    printf("\n2. 尝试打开目录作为文件:\n");
    file = fopen(TEST_DIR, "r");
    if (file == NULL) {
        printf("   捕获错误: %s\n", strerror(errno));
    }
    
    /* 3. 使用perror */
    printf("\n3. 使用perror报告错误:\n");
    snprintf(filepath, sizeof(filepath), "%s/nonexistent.txt", TEST_DIR);
    file = fopen(filepath, "r");
    if (file == NULL) {
        perror("   打开文件失败");
    }
}

/**
 * 演示格式化输出
 */
void demonstrate_formatted_io() {
    char filepath[MAX_PATH_LEN];
    FILE *file;
    
    printf("\n=== 格式化I/O ===\n\n");
    
    /* 写入格式化数据 */
    snprintf(filepath, sizeof(filepath), "%s/formatted.txt", TEST_DIR);
    file = fopen(filepath, "w");
    if (file == NULL) {
        perror("创建文件失败");
        return;
    }
    
    /* 使用fprintf */
    fprintf(file, "整数: %d\n", 42);
    fprintf(file, "浮点数: %.2f\n", 3.14159);
    fprintf(file, "字符串: %s\n", "Hello");
    fprintf(file, "十六进制: %X\n", 255);
    fprintf(file, "八进制: %o\n", 255);
    fclose(file);
    
    /* 读取格式化数据 */
    file = fopen(filepath, "r");
    if (file == NULL) {
        perror("打开文件失败");
        return;
    }
    
    printf("格式化文件内容:\n");
    char line[MAX_LINE_LEN];
    while (fgets(line, sizeof(line), file) != NULL) {
        printf("%s", line);
    }
    fclose(file);
    
    /* 使用fscanf读取 */
    printf("\n使用fscanf读取:\n");
    file = fopen(filepath, "r");
    if (file == NULL) {
        perror("打开文件失败");
        return;
    }
    
    int int_val;
    float float_val;
    char str_val[100];
    
    /* 跳过标签 */
    fscanf(file, "整数: %d\n", &int_val);
    fscanf(file, "浮点数: %f\n", &float_val);
    fscanf(file, "字符串: %s\n", str_val);
    
    printf("  读取的整数: %d\n", int_val);
    printf("  读取的浮点数: %.2f\n", float_val);
    printf("  读取的字符串: %s\n", str_val);
    fclose(file);
}

/**
 * 清理测试目录
 */
void cleanup() {
    char filepath[MAX_PATH_LEN];
    
    printf("\n清理测试目录...\n");
    
    /* 删除所有测试文件 */
    const char *files[] = {
        "output.txt", "lines.txt", "operations.txt", 
        "renamed.txt", "binary.bin", "formatted.txt", NULL
    };
    
    for (int i = 0; files[i] != NULL; i++) {
        snprintf(filepath, sizeof(filepath), "%s/%s", TEST_DIR, files[i]);
        remove(filepath);
    }
    
    /* 删除目录 */
    if (rmdir(TEST_DIR) == 0) {
        printf("清理完成\n");
    } else {
        perror("删除目录失败");
    }
}

/**
 * 主函数
 */
int main() {
    printf("C语言文件I/O对比示例\n");
    printf("==================================================\n");
    
    /* 创建测试目录 */
    if (ensure_test_dir() != 0) {
        return 1;
    }
    
    /* 演示各种文件操作 */
    demonstrate_basic_io();
    demonstrate_line_by_line();
    demonstrate_file_operations();
    demonstrate_binary_io();
    demonstrate_error_handling();
    demonstrate_formatted_io();
    
    /* 清理 */
    cleanup();
    
    printf("\n==================================================\n");
    printf("C语言文件I/O演示完成\n");
    printf("==================================================\n");
    
    return 0;
}