/**
 * C语言 环境变量操作对比
 * 文件: comparison.c
 * 作者: 教程工程师
 * 日期: 2026-06-11
 * 说明: 展示C语言中环境变量操作与CMD的对比
 * 编译: gcc comparison.c -o comparison.exe (Windows) 或 gcc comparison.c -o comparison (Linux/macOS)
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#ifdef _WIN32
    #include <windows.h>
    #include <direct.h>
    #define getcwd _getcwd
#else
    #include <unistd.h>
    #include <sys/utsname.h>
#endif

// 颜色定义（ANSI转义序列）
#define COLOR_RESET   "\033[0m"
#define COLOR_BRIGHT  "\033[1m"
#define COLOR_RED     "\033[31m"
#define COLOR_GREEN   "\033[32m"
#define COLOR_YELLOW  "\033[33m"
#define COLOR_BLUE    "\033[34m"
#define COLOR_MAGENTA "\033[35m"
#define COLOR_CYAN    "\033[36m"

/**
 * 打印带颜色的消息
 */
void print_header(const char *title) {
    printf("\n%s%s============================================================%s\n", 
           COLOR_BRIGHT, COLOR_CYAN, COLOR_RESET);
    printf("%s%s%s%s\n", COLOR_BRIGHT, COLOR_CYAN, title, COLOR_RESET);
    printf("%s%s============================================================%s\n", 
           COLOR_BRIGHT, COLOR_CYAN, COLOR_RESET);
}

void print_subheader(const char *title) {
    printf("\n%s%s[%s]%s\n", COLOR_YELLOW, COLOR_BRIGHT, title, COLOR_RESET);
    printf("%s----------------------------------------%s\n", COLOR_YELLOW, COLOR_RESET);
}

void print_success(const char *message) {
    printf("%s✓ %s%s\n", COLOR_GREEN, message, COLOR_RESET);
}

void print_error(const char *message) {
    printf("%s✗ %s%s\n", COLOR_RED, message, COLOR_RESET);
}

void print_warning(const char *message) {
    printf("%s⚠ %s%s\n", COLOR_YELLOW, message, COLOR_RESET);
}

void print_info(const char *message) {
    printf("%sℹ %s%s\n", COLOR_BLUE, message, COLOR_RESET);
}

/**
 * 环境变量操作对比
 */
void compare_environment_variables() {
    print_header("环境变量操作对比");

    // 1. 获取环境变量
    print_subheader("获取环境变量");
    
    // C语言方式
    char *c_path = getenv("PATH");
    char *c_temp = getenv("TEMP");
    char *c_userprofile = getenv("USERPROFILE");
    
    if (c_path) {
        // 截断显示
        char truncated_path[101];
        strncpy(truncated_path, c_path, 100);
        truncated_path[100] = '\0';
        printf("C语言获取PATH: %s...\n", truncated_path);
    } else {
        printf("C语言获取PATH: 未设置\n");
    }
    
    printf("C语言获取TEMP: %s\n", c_temp ? c_temp : "未设置");
    printf("C语言获取USERPROFILE: %s\n", c_userprofile ? c_userprofile : "未设置");
    
    // CMD等价命令
    printf("\nCMD等价命令:\n");
    printf("  echo %%PATH%%\n");
    printf("  echo %%TEMP%%\n");
    printf("  echo %%USERPROFILE%%\n");

    // 2. 设置环境变量
    print_subheader("设置环境变量");
    
    // C语言方式 - 设置临时环境变量
#ifdef _WIN32
    if (_putenv("C_TEST_VAR=C Test Value") == 0) {
        print_success("C语言设置C_TEST_VAR: 成功");
    } else {
        print_error("C语言设置C_TEST_VAR: 失败");
    }
#else
    if (setenv("C_TEST_VAR", "C Test Value", 1) == 0) {
        print_success("C语言设置C_TEST_VAR: 成功");
    } else {
        print_error("C语言设置C_TEST_VAR: 失败");
    }
#endif
    
    // CMD等价命令
    printf("\nCMD等价命令:\n");
    printf("  set C_TEST_VAR=C Test Value\n");

    // 3. 删除环境变量
    print_subheader("删除环境变量");
    
    // C语言方式
#ifdef _WIN32
    if (_putenv("C_TEST_VAR=") == 0) {
        print_success("C语言删除C_TEST_VAR: 成功");
    } else {
        print_error("C语言删除C_TEST_VAR: 失败");
    }
#else
    if (unsetenv("C_TEST_VAR") == 0) {
        print_success("C语言删除C_TEST_VAR: 成功");
    } else {
        print_error("C语言删除C_TEST_VAR: 失败");
    }
#endif
    
    // CMD等价命令
    printf("\nCMD等价命令:\n");
    printf("  set C_TEST_VAR=\n");

    // 4. 遍历环境变量
    print_subheader("遍历环境变量");
    
    // C语言方式 - 通过extern char **environ
    extern char **environ;
    printf("C语言遍历环境变量（前10个）:\n");
    
    int count = 0;
    for (char **env = environ; *env != NULL && count < 10; env++, count++) {
        printf("  %s\n", *env);
    }
    
    // CMD等价命令
    printf("\nCMD等价命令:\n");
    printf("  set\n");
}

/**
 * PATH变量操作对比
 */
void compare_path_operations() {
    print_header("PATH变量操作对比");

    // 1. 获取PATH
    print_subheader("获取PATH变量");
    
    // C语言方式
    char *c_path = getenv("PATH");
    if (c_path) {
        // 复制PATH以便分割
        char *path_copy = strdup(c_path);
        if (path_copy) {
            printf("C语言获取PATH（前5个目录）:\n");
            
            char *token = strtok(path_copy, ";");
            int count = 0;
            
            while (token != NULL && count < 5) {
                printf("  %d. %s\n", count + 1, token);
                token = strtok(NULL, ";");
                count++;
            }
            
            free(path_copy);
        }
    }
    
    // CMD等价命令
    printf("\nCMD等价命令:\n");
    printf("  echo %%PATH%%\n");

    // 2. 添加目录到PATH
    print_subheader("添加目录到PATH");
    
    // C语言方式
    char *current_path = getenv("PATH");
    if (current_path) {
        char new_path[4096];
        snprintf(new_path, sizeof(new_path), "%s;C:\\CTestDir", current_path);
        
#ifdef _WIN32
        if (_putenv(new_path) == 0) {
            print_success("C语言添加目录到PATH: 成功");
        } else {
            print_error("C语言添加目录到PATH: 失败");
        }
#else
        if (setenv("PATH", new_path, 1) == 0) {
            print_success("C语言添加目录到PATH: 成功");
        } else {
            print_error("C语言添加目录到PATH: 失败");
        }
#endif
    }
    
    // CMD等价命令
    printf("\nCMD等价命令:\n");
    printf("  set PATH=%%PATH%%;C:\\CTestDir\n");

    // 3. 检查目录是否存在
    print_subheader("检查PATH目录是否存在");
    
    // C语言方式
    if (c_path) {
        char *path_copy = strdup(c_path);
        if (path_copy) {
            printf("C语言检查PATH目录:\n");
            
            char *token = strtok(path_copy, ";");
            int missing_count = 0;
            
            while (token != NULL) {
#ifdef _WIN32
                DWORD attrs = GetFileAttributesA(token);
                if (attrs != INVALID_FILE_ATTRIBUTES && (attrs & FILE_ATTRIBUTE_DIRECTORY)) {
                    print_success("[存在] %s");
                } else {
                    print_error("[缺失] %s");
                    missing_count++;
                }
#else
                if (access(token, F_OK) == 0) {
                    print_success("[存在] %s");
                } else {
                    print_error("[缺失] %s");
                    missing_count++;
                }
#endif
                token = strtok(NULL, ";");
            }
            
            printf("缺失目录数量: %d\n", missing_count);
            free(path_copy);
        }
    }
    
    // CMD等价命令
    printf("\nCMD等价命令:\n");
    printf("  for %%%%i in (\"%%PATH:;=\" \"%%\") do if not exist \"%%%%~i\" echo 缺失: %%%%~i\n");
}

/**
 * 注册表操作对比（仅Windows）
 */
#ifdef _WIN32
void compare_registry_operations() {
    print_header("注册表操作对比（仅Windows）");

    // 1. 查询注册表
    print_subheader("查询注册表");
    
    HKEY hKey;
    LONG result;
    
    // 打开注册表项
    result = RegOpenKeyEx(HKEY_CURRENT_USER, "Environment", 0, KEY_READ, &hKey);
    if (result == ERROR_SUCCESS) {
        print_success("C语言打开注册表项: 成功");
        
        // 查询Path值
        char path_value[4096];
        DWORD path_size = sizeof(path_value);
        DWORD reg_type;
        
        result = RegQueryValueEx(hKey, "Path", NULL, &reg_type, (LPBYTE)path_value, &path_size);
        if (result == ERROR_SUCCESS) {
            printf("C语言查询Path值: %.100s...\n", path_value);
        } else {
            print_error("C语言查询Path值: 失败");
        }
        
        RegCloseKey(hKey);
    } else {
        print_error("C语言打开注册表项: 失败");
    }
    
    // CMD等价命令
    printf("\nCMD等价命令:\n");
    printf("  reg query \"HKCU\\Environment\"\n");
    printf("  reg query \"HKCU\\Environment\" /v Path\n");

    // 2. 添加注册表值（仅演示，不实际执行）
    print_subheader("添加注册表值（演示）");
    
    print_warning("C语言添加注册表值需要调用RegSetValueEx函数:");
    printf("  RegSetValueEx(hKey, \"C_TEST_REG\", 0, REG_SZ, (BYTE*)\"Value\", strlen(\"Value\")+1);\n");
    
    // CMD等价命令
    printf("\nCMD等价命令:\n");
    printf("  reg add \"HKCU\\Environment\" /v \"C_TEST_REG\" /t REG_SZ /d \"C Registry Value\" /f\n");

    // 3. 删除注册表值（仅演示，不实际执行）
    print_subheader("删除注册表值（演示）");
    
    print_warning("C语言删除注册表值需要调用RegDeleteValue函数:");
    printf("  RegDeleteValue(hKey, \"C_TEST_REG\");\n");
    
    // CMD等价命令
    printf("\nCMD等价命令:\n");
    printf("  reg delete \"HKCU\\Environment\" /v \"C_TEST_REG\" /f\n");
}
#endif

/**
 * 创建对比报告
 */
void create_comparison_report() {
    print_header("创建对比报告");

    // 获取当前时间
    time_t now = time(NULL);
    struct tm *tm_info = localtime(&now);
    char time_buffer[26];
    strftime(time_buffer, 26, "%Y-%m-%d %H:%M:%S", tm_info);

    // 获取系统信息
#ifdef _WIN32
    SYSTEM_INFO sys_info;
    GetSystemInfo(&sys_info);
    
    MEMORYSTATUSEX mem_info;
    mem_info.dwLength = sizeof(mem_info);
    GlobalMemoryStatusEx(&mem_info);
    
    printf("对比报告:\n");
    printf("  生成时间: %s\n", time_buffer);
    printf("  编译器: %s\n", 
#ifdef _MSC_VER
           "Microsoft Visual C++"
#elif defined(__GNUC__)
           "GCC"
#elif defined(__clang__)
           "Clang"
#else
           "Unknown"
#endif
    );
    printf("  操作系统: Windows\n");
    printf("  处理器架构: %s\n", 
           sys_info.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_AMD64 ? "AMD64" :
           sys_info.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_INTEL ? "x86" : "Other");
    
    printf("  环境变量操作:\n");
    printf("    getenv: 获取环境变量\n");
    printf("    _putenv: 设置环境变量\n");
    printf("    RegOpenKeyEx: 打开注册表项\n");
    printf("    RegQueryValueEx: 查询注册表值\n");
    printf("    RegSetValueEx: 设置注册表值\n");
    printf("    RegDeleteValue: 删除注册表值\n");
#else
    struct utsname uts;
    uname(&uts);
    
    printf("对比报告:\n");
    printf("  生成时间: %s\n", time_buffer);
    printf("  操作系统: %s %s\n", uts.sysname, uts.release);
    printf("  主机名: %s\n", uts.nodename);
    printf("  处理器架构: %s\n", uts.machine);
    
    printf("  环境变量操作:\n");
    printf("    getenv: 获取环境变量\n");
    printf("    setenv: 设置环境变量\n");
    printf("    unsetenv: 删除环境变量\n");
#endif

    // 保存报告到文件
    FILE *report_file = fopen("env_registry_comparison_c.txt", "w");
    if (report_file) {
        fprintf(report_file, "C语言环境变量操作对比报告\n");
        fprintf(report_file, "=========================\n\n");
        fprintf(report_file, "生成时间: %s\n\n", time_buffer);
        fprintf(report_file, "主要函数:\n");
        fprintf(report_file, "  getenv() - 获取环境变量\n");
        fprintf(report_file, "  setenv() - 设置环境变量\n");
        fprintf(report_file, "  unsetenv() - 删除环境变量\n");
#ifdef _WIN32
        fprintf(report_file, "  RegOpenKeyEx() - 打开注册表项\n");
        fprintf(report_file, "  RegQueryValueEx() - 查询注册表值\n");
        fprintf(report_file, "  RegSetValueEx() - 设置注册表值\n");
        fprintf(report_file, "  RegDeleteValue() - 删除注册表值\n");
#endif
        fprintf(report_file, "\nCMD等价命令:\n");
        fprintf(report_file, "  echo %%VARIABLE_NAME%% - 获取环境变量\n");
        fprintf(report_file, "  set VARIABLE_NAME=value - 设置环境变量\n");
        fprintf(report_file, "  reg query \"HKCU\\Environment\" - 查询注册表\n");
        fprintf(report_file, "  reg add \"HKCU\\Environment\" /v Name /t REG_SZ /d Value /f - 添加注册表值\n");
        fprintf(report_file, "  reg delete \"HKCU\\Environment\" /v Name /f - 删除注册表值\n");
        
        fclose(report_file);
        print_success("对比报告已保存到: env_registry_comparison_c.txt");
    } else {
        print_error("无法创建报告文件");
    }
}

/**
 * 主函数
 */
int main() {
    printf("%s%sC语言 环境变量操作对比演示%s\n", COLOR_BRIGHT, COLOR_MAGENTA, COLOR_RESET);
    printf("作者: 教程工程师\n");
    printf("日期: 2026-06-11\n");
    printf("\n");

    compare_environment_variables();
    compare_path_operations();
    
#ifdef _WIN32
    compare_registry_operations();
#endif
    
    create_comparison_report();

    print_header("对比演示完成");
    printf("\n主要区别总结:\n");
    printf("1. C语言使用getenv/setenv管理环境变量，CMD使用set命令\n");
#ifdef _WIN32
    printf("2. C语言使用Windows API操作注册表，CMD使用reg命令\n");
#else
    printf("2. Linux/macOS没有注册表概念，使用配置文件\n");
#endif
    printf("3. C语言提供更底层的控制，需要手动管理内存\n");
    printf("4. C语言更适合系统编程和性能要求高的场景\n");
    printf("5. CMD更适合简单的脚本和系统管理任务\n");

    return 0;
}