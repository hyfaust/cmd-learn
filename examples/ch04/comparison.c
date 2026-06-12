/**
 * comparison.c — C语言 for/while循环对比 CMD for循环
 * 本文件展示C语言中与CMD for循环等价的实现
 * 编译: gcc comparison.c -o comparison.exe
 * 运行: comparison.exe
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>

/* 基本列表遍历 - 对比 CMD: for %%i in (apple banana cherry) */
void basic_list_loop() {
    printf("=== 基本列表遍历 ===\n");
    const char *fruits[] = {"apple", "banana", "cherry"};
    int count = sizeof(fruits) / sizeof(fruits[0]);
    
    for (int i = 0; i < count; i++) {
        printf("水果: %s\n", fruits[i]);
    }
}

/* 数值范围循环 - 对比 CMD: for /L %%i in (1,1,5) */
void numeric_loop() {
    printf("\n=== 数值范围循环 ===\n");
    
    /* 基本循环 */
    for (int i = 1; i <= 5; i++) {
        printf("第 %d 次循环\n", i);
    }
    
    /* 自定义步长 */
    printf("\n=== 自定义步长 ===\n");
    for (int i = 0; i <= 25; i += 5) {
        printf("%d\n", i);
    }
    
    /* 倒序循环 */
    printf("\n=== 倒序循环 ===\n");
    for (int i = 10; i >= 1; i--) {
        printf("倒计时: %d\n", i);
    }
}

/* 字符串分割 - 对比 CMD: for /F "tokens=1,2,3" */
void string_split() {
    printf("\n=== 字符串分割 ===\n");
    
    /* 按空格分割 */
    char text[] = "hello world cmd";
    char *token = strtok(text, " ");
    int index = 1;
    
    while (token != NULL) {
        printf("第%d个: %s\n", index, token);
        token = strtok(NULL, " ");
        index++;
    }
    
    /* 按逗号分割 */
    printf("\n=== 按逗号分割 ===\n");
    char csv[] = "apple,banana,cherry";
    token = strtok(csv, ",");
    
    printf("水果: ");
    while (token != NULL) {
        printf("%s", token);
        token = strtok(NULL, ",");
        if (token != NULL) printf(", ");
    }
    printf("\n");
}

/* 文件遍历 - 对比 CMD: for %%f in (*.txt) */
void file_iteration() {
    printf("\n=== 文件遍历 ===\n");
    
    DIR *dir = opendir(".");
    if (dir == NULL) {
        printf("无法打开目录\n");
        return;
    }
    
    struct dirent *entry;
    while ((entry = readdir(dir)) != NULL) {
        /* 简单的 .c 文件过滤 */
        char *ext = strrchr(entry->d_name, '.');
        if (ext && strcmp(ext, ".c") == 0) {
            printf("文件: %s\n", entry->d_name);
        }
    }
    
    closedir(dir);
}

/* 目录遍历 - 对比 CMD: for /D %%d in (*) */
void directory_iteration() {
    printf("\n=== 目录遍历 ===\n");
    
    DIR *dir = opendir(".");
    if (dir == NULL) {
        printf("无法打开目录\n");
        return;
    }
    
    struct dirent *entry;
    while ((entry = readdir(dir)) != NULL) {
        /* 跳过 . 和 .. */
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
            continue;
        }
        
        /* 检查是否为目录 */
        struct stat st;
        if (stat(entry->d_name, &st) == 0 && S_ISDIR(st.st_mode)) {
            printf("目录: %s\n", entry->d_name);
        }
    }
    
    closedir(dir);
}

/* 递归文件搜索 - 对比 CMD: for /R %%f in (*.c) */
void walk_directory(const char *base_path, const char *extension) {
    DIR *dir = opendir(base_path);
    if (dir == NULL) return;
    
    struct dirent *entry;
    char path[1024];
    
    while ((entry = readdir(dir)) != NULL) {
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
            continue;
        }
        
        snprintf(path, sizeof(path), "%s/%s", base_path, entry->d_name);
        
        struct stat st;
        if (stat(path, &st) == 0) {
            if (S_ISDIR(st.st_mode)) {
                /* 递归遍历子目录 */
                walk_directory(path, extension);
            } else {
                /* 检查文件扩展名 */
                char *ext = strrchr(entry->d_name, '.');
                if (ext && strcmp(ext, extension) == 0) {
                    printf("文件: %s\n", path);
                }
            }
        }
    }
    
    closedir(dir);
}

void recursive_file_search() {
    printf("\n=== 递归文件搜索 ===\n");
    walk_directory(".", ".c");
}

/* 文件内容读取 - 对比 CMD: for /F "usebackq" */
void file_content_reading() {
    printf("\n=== 文件内容读取 ===\n");
    
    /* 创建临时文件 */
    FILE *fp = fopen("temp_test.txt", "w");
    if (fp == NULL) {
        printf("无法创建临时文件\n");
        return;
    }
    
    fprintf(fp, "line1 - 第一行\n");
    fprintf(fp, "line2 - 第二行\n");
    fprintf(fp, "# 这是注释\n");
    fprintf(fp, "line3 - 第三行\n");
    fclose(fp);
    
    /* 读取文件内容 */
    fp = fopen("temp_test.txt", "r");
    if (fp == NULL) {
        printf("无法打开临时文件\n");
        return;
    }
    
    char line[256];
    int line_num = 1;
    
    while (fgets(line, sizeof(line), fp)) {
        /* 移除换行符 */
        line[strcspn(line, "\n")] = 0;
        
        /* 跳过注释行（类似 CMD eol=#） */
        if (line[0] == '#') {
            line_num++;
            continue;
        }
        
        printf("第%d行: %s\n", line_num, line);
        line_num++;
    }
    
    fclose(fp);
    
    /* 清理临时文件 */
    remove("temp_test.txt");
}

/* 命令输出 - 对比 CMD: for /F %%a in ('dir /b') */
void command_output() {
    printf("\n=== 命令输出 ===\n");
    
    /* 使用 popen 执行命令 */
    FILE *fp = popen("dir /b", "r");
    if (fp == NULL) {
        printf("命令执行失败\n");
        return;
    }
    
    char line[256];
    while (fgets(line, sizeof(line), fp)) {
        line[strcspn(line, "\n")] = 0;
        if (strlen(line) > 0) {
            printf("文件: %s\n", line);
        }
    }
    
    pclose(fp);
}

/* 嵌套循环 - 对比 CMD: for /L %%i ... for /L %%j ... */
void nested_loop() {
    printf("\n=== 嵌套循环 ===\n");
    
    /* 九九乘法表片段 */
    for (int i = 1; i <= 3; i++) {
        for (int j = 1; j <= 3; j++) {
            printf("%d x %d = %d\n", i, j, i * j);
        }
        printf("\n");
    }
}

/* while循环示例 - 对比 CMD: goto实现的循环 */
void while_loop_example() {
    printf("\n=== while循环（对比CMD goto循环）===\n");
    
    int count = 0;
    while (count < 5) {
        count++;
        printf("循环次数: %d\n", count);
    }
}

int main() {
    basic_list_loop();
    numeric_loop();
    string_split();
    file_iteration();
    directory_iteration();
    recursive_file_search();
    file_content_reading();
    command_output();
    nested_loop();
    while_loop_example();
    
    return 0;
}
