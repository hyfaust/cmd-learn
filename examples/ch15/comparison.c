/**
 * C语言安全编程对比示例
 * 
 * 本文件展示C语言中的安全编程实践，包括：
 * 1. 输入验证和消毒
 * 2. 缓冲区溢出防护
 * 3. 安全字符串处理
 * 4. 内存安全
 * 5. 文件操作安全
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdbool.h>
#include <time.h>

/* 最大缓冲区大小 */
#define MAX_BUFFER_SIZE 1024
#define MAX_PATH_LENGTH 260
#define MAX_FILENAME_LENGTH 255

/* 危险字符列表 */
#define DANGEROUS_CHARS "\\:*?\"<>|&;`$"

/**
 * 验证用户输入是否安全
 * @param input 用户输入
 * @param max_length 最大长度
 * @return 是否安全
 */
bool validate_input(const char *input, size_t max_length) {
    /* 检查空指针 */
    if (input == NULL) {
        return false;
    }
    
    /* 检查长度 */
    if (strlen(input) > max_length) {
        return false;
    }
    
    /* 检查空字符串 */
    if (strlen(input) == 0) {
        return false;
    }
    
    /* 检查危险字符 */
    for (size_t i = 0; i < strlen(input); i++) {
        if (strchr(DANGEROUS_CHARS, input[i]) != NULL) {
            return false;
        }
    }
    
    /* 检查路径遍历 */
    if (strstr(input, "..") != NULL) {
        return false;
    }
    
    return true;
}

/**
 * 验证文件名是否安全
 * @param filename 文件名
 * @return 是否安全
 */
bool validate_filename(const char *filename) {
    /* 检查空指针 */
    if (filename == NULL) {
        return false;
    }
    
    /* 检查空字符串 */
    if (strlen(filename) == 0) {
        return false;
    }
    
    /* 检查长度 */
    if (strlen(filename) > MAX_FILENAME_LENGTH) {
        return false;
    }
    
    /* 检查非法字符 */
    const char *illegal_chars = "\\:*?\"<>|";
    for (size_t i = 0; i < strlen(filename); i++) {
        if (strchr(illegal_chars, filename[i]) != NULL) {
            return false;
        }
    }
    
    return true;
}

/**
 * 验证路径是否安全
 * @param path_input 路径
 * @return 是否安全
 */
bool validate_path(const char *path_input) {
    /* 检查空指针 */
    if (path_input == NULL) {
        return false;
    }
    
    /* 检查空字符串 */
    if (strlen(path_input) == 0) {
        return false;
    }
    
    /* 检查路径遍历 */
    if (strstr(path_input, "..") != NULL) {
        return false;
    }
    
    /* 检查危险字符 */
    const char *dangerous_chars = "&|<>^";
    for (size_t i = 0; i < strlen(path_input); i++) {
        if (strchr(dangerous_chars, path_input[i]) != NULL) {
            return false;
        }
    }
    
    return true;
}

/**
 * 安全字符串复制
 * @param dest 目标缓冲区
 * @param src 源字符串
 * @param dest_size 目标缓冲区大小
 * @return 是否成功
 */
bool safe_strcpy(char *dest, const char *src, size_t dest_size) {
    /* 检查空指针 */
    if (dest == NULL || src == NULL || dest_size == 0) {
        return false;
    }
    
    size_t src_len = strlen(src);
    
    /* 检查是否需要截断 */
    if (src_len >= dest_size) {
        /* 截断字符串 */
        strncpy(dest, src, dest_size - 1);
        dest[dest_size - 1] = '\0';
        return false;
    }
    
    /* 安全复制 */
    strcpy(dest, src);
    return true;
}

/**
 * 安全字符串连接
 * @param dest 目标缓冲区
 * @param src 源字符串
 * @param dest_size 目标缓冲区大小
 * @return 是否成功
 */
bool safe_strcat(char *dest, const char *src, size_t dest_size) {
    /* 检查空指针 */
    if (dest == NULL || src == NULL || dest_size == 0) {
        return false;
    }
    
    size_t dest_len = strlen(dest);
    size_t src_len = strlen(src);
    
    /* 检查是否有足够空间 */
    if (dest_len + src_len >= dest_size) {
        /* 截断连接 */
        size_t available = dest_size - dest_len - 1;
        strncat(dest, src, available);
        return false;
    }
    
    /* 安全连接 */
    strcat(dest, src);
    return true;
}

/**
 * 安全格式化字符串
 * @param buffer 输出缓冲区
 * @param size 缓冲区大小
 * @param format 格式化字符串
 * @param ... 可变参数
 * @return 写入的字符数，失败返回-1
 */
int safe_snprintf(char *buffer, size_t size, const char *format, ...) {
    /* 检查参数 */
    if (buffer == NULL || size == 0 || format == NULL) {
        return -1;
    }
    
    va_list args;
    va_start(args, format);
    
    int result = vsnprintf(buffer, size, format, args);
    
    va_end(args);
    
    /* 检查是否截断 */
    if (result >= (int)size) {
        buffer[size - 1] = '\0';
        return -1;
    }
    
    return result;
}

/**
 * 消毒用户输入
 * @param input 原始输入
 * @param output 输出缓冲区
 * @param output_size 输出缓冲区大小
 * @return 是否成功
 */
bool sanitize_input(const char *input, char *output, size_t output_size) {
    /* 检查参数 */
    if (input == NULL || output == NULL || output_size == 0) {
        return false;
    }
    
    size_t j = 0;
    size_t input_len = strlen(input);
    
    /* 遍历输入字符串 */
    for (size_t i = 0; i < input_len && j < output_size - 1; i++) {
        char c = input[i];
        
        /* 跳过危险字符 */
        if (strchr(DANGEROUS_CHARS, c) != NULL) {
            continue;
        }
        
        /* 跳过路径遍历 */
        if (c == '.' && i + 1 < input_len && input[i + 1] == '.') {
            i++; /* 跳过第二个点 */
            continue;
        }
        
        /* 添加安全字符 */
        output[j++] = c;
    }
    
    /* 添加字符串结束符 */
    output[j] = '\0';
    
    return true;
}

/**
 * 消毒文件名
 * @param filename 原始文件名
 * @param output 输出缓冲区
 * @param output_size 输出缓冲区大小
 * @return 是否成功
 */
bool sanitize_filename(const char *filename, char *output, size_t output_size) {
    /* 检查参数 */
    if (filename == NULL || output == NULL || output_size == 0) {
        return false;
    }
    
    size_t j = 0;
    size_t filename_len = strlen(filename);
    const char *illegal_chars = "\\:*?\"<>|";
    
    /* 遍历文件名 */
    for (size_t i = 0; i < filename_len && j < output_size - 1; i++) {
        char c = filename[i];
        
        /* 跳过非法字符 */
        if (strchr(illegal_chars, c) != NULL) {
            continue;
        }
        
        /* 添加安全字符 */
        output[j++] = c;
    }
    
    /* 添加字符串结束符 */
    output[j] = '\0';
    
    return true;
}

/**
 * 安全路径连接
 * @param base_path 基础路径
 * @param user_path 用户路径
 * @param output 输出缓冲区
 * @param output_size 输出缓冲区大小
 * @return 是否安全
 */
bool safe_path_join(const char *base_path, const char *user_path, 
                   char *output, size_t output_size) {
    /* 检查参数 */
    if (base_path == NULL || user_path == NULL || 
        output == NULL || output_size == 0) {
        return false;
    }
    
    /* 验证用户路径 */
    if (!validate_path(user_path)) {
        return false;
    }
    
    /* 检查用户路径是否为绝对路径 */
    if (strlen(user_path) >= 2 && user_path[1] == ':') {
        return false;
    }
    
    /* 构建完整路径 */
    safe_strcpy(output, base_path, output_size);
    safe_strcat(output, "\\", output_size);
    safe_strcat(output, user_path, output_size);
    
    return true;
}

/**
 * 安全文件读取
 * @param file_path 文件路径
 * @param buffer 输出缓冲区
 * @param buffer_size 缓冲区大小
 * @return 是否成功
 */
bool safe_file_read(const char *file_path, char *buffer, size_t buffer_size) {
    /* 检查参数 */
    if (file_path == NULL || buffer == NULL || buffer_size == 0) {
        return false;
    }
    
    /* 打开文件 */
    FILE *file = fopen(file_path, "r");
    if (file == NULL) {
        return false;
    }
    
    /* 读取文件内容 */
    size_t bytes_read = fread(buffer, 1, buffer_size - 1, file);
    buffer[bytes_read] = '\0';
    
    /* 关闭文件 */
    fclose(file);
    
    return true;
}

/**
 * 安全文件写入
 * @param file_path 文件路径
 * @param content 文件内容
 * @return 是否成功
 */
bool safe_file_write(const char *file_path, const char *content) {
    /* 检查参数 */
    if (file_path == NULL || content == NULL) {
        return false;
    }
    
    /* 打开文件 */
    FILE *file = fopen(file_path, "w");
    if (file == NULL) {
        return false;
    }
    
    /* 写入内容 */
    size_t content_len = strlen(content);
    size_t bytes_written = fwrite(content, 1, content_len, file);
    
    /* 关闭文件 */
    fclose(file);
    
    return bytes_written == content_len;
}

/**
 * 简单的哈希函数（仅用于演示）
 * @param input 输入字符串
 * @return 哈希值
 */
unsigned long simple_hash(const char *input) {
    unsigned long hash = 5381;
    int c;
    
    while ((c = *input++)) {
        hash = ((hash << 5) + hash) + c; /* hash * 33 + c */
    }
    
    return hash;
}

/**
 * 演示输入验证
 */
void demonstrate_input_validation(void) {
    printf("============================================================\n");
    printf("输入验证演示\n");
    printf("============================================================\n");
    
    /* 测试用例 */
    struct {
        const char *input;
        bool expected;
        const char *description;
    } test_cases[] = {
        {"", false, "空输入"},
        {"hello_world", true, "正常输入"},
        {"file.txt & del /f /q C:\\*.*", false, "命令注入攻击"},
        {"..\\..\\..\\Windows\\System32\\config\\SAM", false, "路径遍历攻击"},
        {"file:name.txt", false, "包含非法字符"},
        {"normal_file.txt", true, "正常文件名"},
        {NULL, false, NULL}
    };
    
    for (int i = 0; test_cases[i].input != NULL; i++) {
        bool result = validate_input(test_cases[i].input, MAX_BUFFER_SIZE);
        const char *status = (result == test_cases[i].expected) ? "PASS" : "FAIL";
        printf("[%s] %s: '%s' -> %s\n", 
               status, test_cases[i].description, 
               test_cases[i].input, result ? "true" : "false");
    }
}

/**
 * 演示路径安全
 */
void demonstrate_path_security(void) {
    printf("\n============================================================\n");
    printf("路径安全演示\n");
    printf("============================================================\n");
    
    /* 测试用例 */
    struct {
        const char *input;
        bool expected;
        const char *description;
    } test_cases[] = {
        {"file.txt", true, "正常文件"},
        {"..\\..\\secret.txt", false, "路径遍历攻击"},
        {"C:\\Windows\\System32\\cmd.exe", false, "绝对路径"},
        {"subdir\\file.txt", true, "子目录文件"},
        {NULL, false, NULL}
    };
    
    char base_path[] = "C:\\Users\\test";
    char output[MAX_PATH_LENGTH];
    
    for (int i = 0; test_cases[i].input != NULL; i++) {
        bool result = safe_path_join(base_path, test_cases[i].input, 
                                    output, sizeof(output));
        const char *status = (result == test_cases[i].expected) ? "PASS" : "FAIL";
        printf("[%s] %s: '%s' -> %s\n", 
               status, test_cases[i].description, 
               test_cases[i].input, result ? "安全" : "不安全");
    }
}

/**
 * 演示字符串安全
 */
void demonstrate_string_security(void) {
    printf("\n============================================================\n");
    printf("字符串安全演示\n");
    printf("============================================================\n");
    
    /* 测试安全字符串复制 */
    char buffer[20];
    const char *long_string = "This is a very long string that should be truncated";
    
    printf("安全字符串复制:\n");
    printf("  原始字符串: '%s'\n", long_string);
    printf("  缓冲区大小: %zu\n", sizeof(buffer));
    
    bool result = safe_strcpy(buffer, long_string, sizeof(buffer));
    printf("  复制结果: %s\n", result ? "成功" : "截断");
    printf("  复制后字符串: '%s'\n", buffer);
    
    /* 测试安全字符串连接 */
    printf("\n安全字符串连接:\n");
    char dest[30] = "Hello, ";
    const char *src = "World! This is a test.";
    
    printf("  目标字符串: '%s'\n", dest);
    printf("  源字符串: '%s'\n", src);
    
    result = safe_strcat(dest, src, sizeof(dest));
    printf("  连接结果: %s\n", result ? "成功" : "截断");
    printf("  连接后字符串: '%s'\n", dest);
}

/**
 * 演示输入消毒
 */
void demonstrate_sanitization(void) {
    printf("\n============================================================\n");
    printf("输入消毒演示\n");
    printf("============================================================\n");
    
    /* 测试用例 */
    struct {
        const char *input;
        const char *description;
    } test_cases[] = {
        {"file:name.txt", "文件名消毒"},
        {"  hello world  ", "空格处理"},
        {"file.txt & command", "命令注入消毒"},
        {"..\\..\\path", "路径遍历消毒"},
        {NULL, NULL}
    };
    
    char sanitized[MAX_BUFFER_SIZE];
    
    for (int i = 0; test_cases[i].input != NULL; i++) {
        printf("%s:\n", test_cases[i].description);
        printf("  输入: '%s'\n", test_cases[i].input);
        
        sanitize_input(test_cases[i].input, sanitized, sizeof(sanitized));
        printf("  输出: '%s'\n", sanitized);
        printf("\n");
    }
}

/**
 * 演示文件操作安全
 */
void demonstrate_file_security(void) {
    printf("\n============================================================\n");
    printf("文件操作安全演示\n");
    printf("============================================================\n");
    
    /* 创建测试文件 */
    const char *test_file = "test_security.txt";
    const char *test_content = "Hello, this is a test file for security demonstration.";
    
    printf("创建测试文件: %s\n", test_file);
    if (safe_file_write(test_file, test_content)) {
        printf("  文件创建成功\n");
        
        /* 读取文件 */
        char buffer[MAX_BUFFER_SIZE];
        if (safe_file_read(test_file, buffer, sizeof(buffer))) {
            printf("  文件内容: '%s'\n", buffer);
        } else {
            printf("  文件读取失败\n");
        }
        
        /* 计算哈希 */
        unsigned long hash = simple_hash(buffer);
        printf("  文件哈希: %lu\n", hash);
        
        /* 删除测试文件 */
        remove(test_file);
        printf("  测试文件已删除\n");
    } else {
        printf("  文件创建失败\n");
    }
}

/**
 * 主函数
 */
int main(void) {
    printf("C语言安全编程对比示例\n");
    printf("============================================================\n");
    
    demonstrate_input_validation();
    demonstrate_path_security();
    demonstrate_string_security();
    demonstrate_sanitization();
    demonstrate_file_security();
    
    printf("\n============================================================\n");
    printf("所有演示完成\n");
    printf("============================================================\n");
    
    return 0;
}