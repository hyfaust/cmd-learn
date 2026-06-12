/*
 * C语言字符串操作对比 - 与CMD字符串处理对比
 * 编译: gcc comparison.c -o comparison.exe
 * 运行: comparison.exe
 */

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

/* 辅助函数：字符串修剪 */
void trim(char* str) {
    char* start = str;
    char* end;
    
    /* 跳过前导空格 */
    while (isspace((unsigned char)*start)) {
        start++;
    }
    
    if (*start == 0) {
        str[0] = 0;
        return;
    }
    
    /* 找到字符串末尾 */
    end = start + strlen(start) - 1;
    
    /* 跳过尾随空格 */
    while (end > start && isspace((unsigned char)*end)) {
        end--;
    }
    
    /* 添加终止符 */
    *(end + 1) = 0;
    
    /* 移动字符串到开头 */
    if (start != str) {
        memmove(str, start, end - start + 2);
    }
}

/* 辅助函数：字符串替换 */
char* replace(const char* str, const char* old, const char* new_str) {
    char* result;
    int i, count = 0;
    int new_len = strlen(new_str);
    int old_len = strlen(old);
    
    /* 计算替换次数 */
    for (i = 0; str[i] != '\0'; i++) {
        if (strstr(&str[i], old) == &str[i]) {
            count++;
            i += old_len - 1;
        }
    }
    
    /* 分配内存 */
    result = (char*)malloc(i + count * (new_len - old_len) + 1);
    if (!result) return NULL;
    
    i = 0;
    while (*str) {
        if (strstr(str, old) == str) {
            strcpy(&result[i], new_str);
            i += new_len;
            str += old_len;
        } else {
            result[i++] = *str++;
        }
    }
    result[i] = '\0';
    
    return result;
}

/* 辅助函数：大小写转换 */
void to_upper(char* str) {
    for (int i = 0; str[i]; i++) {
        str[i] = toupper((unsigned char)str[i]);
    }
}

void to_lower(char* str) {
    for (int i = 0; str[i]; i++) {
        str[i] = tolower((unsigned char)str[i]);
    }
}

int main() {
    printf("=== C语言字符串操作对比 ===\n\n");
    
    /* 原始字符串 */
    char original[] = "Hello, World!";
    printf("原始字符串: %s\n", original);
    printf("\n");
    
    /* 1. 字符串长度 */
    printf("--- 1. 字符串长度 ---\n");
    printf("字符串长度: %lu\n", strlen(original));              // CMD: 需要循环计算
    printf("\n");
    
    /* 2. 子串截取 */
    printf("--- 2. 子串截取 ---\n");
    char substring[50];
    
    /* 前5个字符 */
    strncpy(substring, original, 5);
    substring[5] = '\0';
    printf("前5个字符: %s\n", substring);                       // CMD: %str:~0,5%
    
    /* 从索引7开始 */
    printf("从索引7开始: %s\n", &original[7]);                  // CMD: %str:~7%
    
    /* 使用memcpy */
    memcpy(substring, &original[2], 3);
    substring[3] = '\0';
    printf("从索引2到5: %s\n", substring);                      // CMD: %str:~2,3%
    printf("\n");
    
    /* 3. 字符串查找 */
    printf("--- 3. 字符串查找 ---\n");
    char* found = strstr(original, "World");
    if (found) {
        printf("查找World: 在索引%ld处找到\n", found - original); // CMD: findstr
    } else {
        printf("查找World: 未找到\n");
    }
    
    found = strstr(original, "xyz");
    if (found) {
        printf("查找xyz: 在索引%ld处找到\n", found - original);
    } else {
        printf("查找xyz: 未找到\n");                              // CMD: findstr
    }
    
    /* 检查是否包含 */
    if (strstr(original, "World") != NULL) {
        printf("包含World: 是\n");                               // CMD: findstr + errorlevel
    } else {
        printf("包含World: 否\n");
    }
    printf("\n");
    
    /* 4. 字符串替换 */
    printf("--- 4. 字符串替换 ---\n");
    char str_replace[] = "Hello World Hello CMD";
    printf("原始字符串: %s\n", str_replace);
    
    char* replaced = replace(str_replace, "Hello", "Hi");
    if (replaced) {
        printf("替换Hello为Hi: %s\n", replaced);                // CMD: %str:Hello=Hi%
        free(replaced);
    }
    printf("\n");
    
    /* 5. 大小写转换 */
    printf("--- 5. 大小写转换 ---\n");
    char str_upper[50] = "Hello World";
    printf("原始: %s\n", str_upper);
    
    to_upper(str_upper);
    printf("大写: %s\n", str_upper);                             // CMD: 需要循环替换
    
    char str_lower[50] = "HELLO WORLD";
    to_lower(str_lower);
    printf("小写: %s\n", str_lower);                             // CMD: 需要循环替换
    printf("\n");
    
    /* 6. 字符串修剪 */
    printf("--- 6. 字符串修剪 ---\n");
    char str_trim[50] = "   Hello World   ";
    printf("原始: [%s]\n", str_trim);
    
    trim(str_trim);
    printf("修剪后: [%s]\n", str_trim);                          // CMD: for /F技巧
    printf("\n");
    
    /* 7. 字符串分割 */
    printf("--- 7. 字符串分割 ---\n");
    char csv_data[] = "apple,banana,cherry";
    printf("原始CSV: %s\n", csv_data);
    
    char* token = strtok(csv_data, ",");
    printf("分割结果: ");
    while (token != NULL) {                                      // CMD: for /F "tokens="
        printf("%s ", token);
        token = strtok(NULL, ",");
    }
    printf("\n\n");
    
    /* 8. 字符串连接 */
    printf("--- 8. 字符串连接 ---\n");
    char str1[] = "Hello";
    char str2[] = "World";
    char str3[] = "CMD";
    char result[100];
    
    strcpy(result, str1);
    strcat(result, " ");
    strcat(result, str2);
    strcat(result, " ");
    strcat(result, str3);
    printf("连接结果: %s\n", result);                            // CMD: 直接拼接
    printf("\n");
    
    /* 9. 字符串比较 */
    printf("--- 9. 字符串比较 ---\n");
    char str4[] = "Hello";
    char str5[] = "Hello";
    char str6[] = "World";
    
    printf("比较Hello和Hello: %d\n", strcmp(str4, str5));       // 0表示相等
    printf("比较Hello和World: %d\n", strcmp(str4, str6));       // 非0表示不等
    printf("\n");
    
    /* 10. 格式化字符串 */
    printf("--- 10. 格式化字符串 ---\n");
    char name[] = "张三";
    int age = 25;
    char formatted[100];
    
    sprintf(formatted, "%s今年%d岁", name, age);                 // CMD: %var%拼接
    printf("格式化结果: %s\n", formatted);
    printf("\n");
    
    /* 11. 字符串检查 */
    printf("--- 11. 字符串检查 ---\n");
    char test_str[] = "Hello123";
    printf("测试字符串: %s\n", test_str);
    
    /* 检查是否全字母 */
    int is_alpha = 1;
    for (int i = 0; test_str[i]; i++) {
        if (!isalpha((unsigned char)test_str[i])) {
            is_alpha = 0;
            break;
        }
    }
    printf("是否全字母: %s\n", is_alpha ? "是" : "否");          // CMD: 无直接等价
    
    /* 检查是否全数字 */
    int is_digit = 1;
    for (int i = 0; test_str[i]; i++) {
        if (!isdigit((unsigned char)test_str[i])) {
            is_digit = 0;
            break;
        }
    }
    printf("是否全数字: %s\n", is_digit ? "是" : "否");          // CMD: 无直接等价
    printf("\n");
    
    printf("=== 演示完成 ===\n");
    return 0;
}