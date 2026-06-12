/*
 * comparison.c
 * C语言进程管理对比
 * 使用 system() 和 popen() 实现与 CMD 类似的功能
 * 编译: gcc comparison.c -o comparison
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#ifdef _WIN32
    #define OS_WINDOWS 1
    #include <windows.h>
#else
    #define OS_WINDOWS 0
    #include <unistd.h>
    #include <sys/types.h>
    #include <sys/wait.h>
#endif

#define MAX_BUFFER 4096

/**
 * 获取系统信息 - 对比 CMD 的 systeminfo
 */
void get_system_info() {
    printf("============================================================\n");
    printf("系统信息 (对比 systeminfo)\n");
    printf("============================================================\n\n");
    
    if (OS_WINDOWS) {
        printf("[Windows 系统信息]\n\n");
        
        // 使用 system() 调用 systeminfo
        printf("执行: systeminfo\n");
        printf("-" "------------------------------------------------------------\n");
        system("systeminfo | findstr /i \"OS Name OS Version System Model Processor Total Physical Memory\"");
        printf("\n");
        
        // 使用 wmic 获取更详细的信息
        printf("CPU 信息:\n");
        system("wmic cpu get name,numberofcores /format:list 2>nul | findstr /i \"name cores\"");
        
        printf("\n内存信息:\n");
        system("wmic memorychip get capacity,speed,manufacturer /format:list 2>nul | findstr /i \"capacity speed\"");
        
    } else {
        printf("[Linux/Mac 系统信息]\n\n");
        system("uname -a");
        printf("\nCPU 信息:\n");
        system("lscpu | head -10");
        printf("\n内存信息:\n");
        system("free -h");
    }
}

/**
 * 获取进程列表 - 对比 CMD 的 tasklist
 */
void get_process_list() {
    printf("\n============================================================\n");
    printf("进程列表 (对比 tasklist)\n");
    printf("============================================================\n\n");
    
    if (OS_WINDOWS) {
        // 使用 popen() 获取进程列表
        FILE *fp;
        char buffer[MAX_BUFFER];
        int count = 0;
        
        printf("执行: tasklist /fo TABLE\n\n");
        
        fp = popen("tasklist /fo TABLE", "r");
        if (fp == NULL) {
            printf("无法执行 tasklist 命令\n");
            return;
        }
        
        // 读取并显示输出
        printf("PID\t\t进程名\t\t\t内存使用\n");
        printf("------------------------------------------------------------\n");
        
        while (fgets(buffer, sizeof(buffer), fp) != NULL && count < 25) {
            printf("%s", buffer);
            count++;
        }
        
        pclose(fp);
        printf("\n... (显示前25行)\n");
        
    } else {
        printf("执行: ps aux\n\n");
        system("ps aux | head -25");
    }
}

/**
 * 查找特定进程 - 对比 CMD 的 tasklist /fi
 */
void find_process(const char *process_name) {
    printf("\n查找进程: %s\n", process_name);
    printf("------------------------------------------------------------\n");
    
    char command[MAX_BUFFER];
    
    if (OS_WINDOWS) {
        snprintf(command, sizeof(command), 
                "tasklist /fi \"imagename eq %s\" /fo TABLE", process_name);
        
        FILE *fp = popen(command, "r");
        if (fp == NULL) {
            printf("无法执行命令\n");
            return;
        }
        
        char buffer[MAX_BUFFER];
        int found = 0;
        
        while (fgets(buffer, sizeof(buffer), fp) != NULL) {
            if (strstr(buffer, process_name) != NULL) {
                printf("%s", buffer);
                found = 1;
            }
        }
        
        if (!found) {
            printf("未找到进程: %s\n", process_name);
        }
        
        pclose(fp);
        
    } else {
        snprintf(command, sizeof(command), "pgrep -l %s", process_name);
        printf("执行: %s\n", command);
        system(command);
    }
}

/**
 * 终止进程 - 对比 CMD 的 taskkill
 * 注意: 仅演示安全的终止方法
 */
void kill_process(int pid, int force) {
    printf("\n终止进程 PID: %d\n", pid);
    printf("------------------------------------------------------------\n");
    
    char command[MAX_BUFFER];
    
    if (OS_WINDOWS) {
        if (force) {
            snprintf(command, sizeof(command), "taskkill /pid %d /f", pid);
        } else {
            snprintf(command, sizeof(command), "taskkill /pid %d", pid);
        }
    } else {
        if (force) {
            snprintf(command, sizeof(command), "kill -9 %d", pid);
        } else {
            snprintf(command, sizeof(command), "kill %d", pid);
        }
    }
    
    printf("执行命令: %s\n", command);
    printf("[模拟] 命令已准备，实际执行需要确认\n");
    
    // 安全起见，仅显示命令不执行
    // 如果需要实际执行，取消下面的注释
    // system(command);
}

/**
 * 获取服务列表 - 对比 CMD 的 sc query
 */
void get_service_list() {
    printf("\n============================================================\n");
    printf("服务列表 (对比 sc query)\n");
    printf("============================================================\n\n");
    
    if (OS_WINDOWS) {
        FILE *fp;
        char buffer[MAX_BUFFER];
        
        printf("执行: sc query state= all\n\n");
        
        fp = popen("sc query state= all", "r");
        if (fp == NULL) {
            printf("无法执行 sc 命令\n");
            return;
        }
        
        // 解析并显示服务信息
        char service_name[256] = "";
        char service_state[256] = "";
        
        while (fgets(buffer, sizeof(buffer), fp) != NULL) {
            // 查找服务名称
            if (strstr(buffer, "SERVICE_NAME") != NULL) {
                sscanf(buffer, "SERVICE_NAME: %s", service_name);
            }
            // 查找服务状态
            if (strstr(buffer, "STATE") != NULL && service_name[0] != '\0') {
                sscanf(buffer, " STATE : %s", service_state);
                printf("  %-40s %s\n", service_name, service_state);
                service_name[0] = '\0';
                service_state[0] = '\0';
            }
        }
        
        pclose(fp);
        
    } else {
        printf("执行: systemctl list-units --type=service\n\n");
        system("systemctl list-units --type=service | head -30");
    }
}

/**
 * 获取进程详细信息 - 使用 wmic
 */
void get_process_details_wmic() {
    printf("\n============================================================\n");
    printf("进程详细信息 (使用 WMIC)\n");
    printf("============================================================\n\n");
    
    if (!OS_WINDOWS) {
        printf("WMIC 仅适用于 Windows 系统\n");
        return;
    }
    
    FILE *fp;
    char buffer[MAX_BUFFER];
    
    printf("执行: wmic process get name,processid,parentprocessid /format:csv\n\n");
    
    fp = popen("wmic process get name,processid,parentprocessid /format:csv", "r");
    if (fp == NULL) {
        printf("无法执行 wmic 命令\n");
        return;
    }
    
    printf("名称\t\t\tPID\t\t父PID\n");
    printf("------------------------------------------------------------\n");
    
    int count = 0;
    while (fgets(buffer, sizeof(buffer), fp) != NULL && count < 20) {
        // 跳过标题行
        if (strstr(buffer, "Node") != NULL || strstr(buffer, "Name") != NULL) {
            continue;
        }
        
        // 解析 CSV 格式
        char *token;
        char *rest = buffer;
        char *parts[4];
        int i = 0;
        
        while ((token = strtok_r(rest, ",", &rest)) && i < 4) {
            parts[i++] = token;
        }
        
        if (i >= 3) {
            printf("%-20s %-15s %s", 
                   parts[1] ? parts[1] : "N/A",
                   parts[2] ? parts[2] : "N/A",
                   parts[3] ? parts[3] : "N/A");
        }
        count++;
    }
    
    pclose(fp);
}

/**
 * 监控进程 - 对比 CMD 的进程监控脚本
 */
void monitor_process(const char *process_name, int interval, int duration) {
    printf("\n开始监控进程: %s\n", process_name);
    printf("监控间隔: %d 秒\n", interval);
    printf("监控时长: %d 秒\n", duration);
    printf("------------------------------------------------------------\n");
    
    char command[MAX_BUFFER];
    time_t start_time = time(NULL);
    int check_count = 0;
    
    while (difftime(time(NULL), start_time) < duration) {
        check_count++;
        
        // 获取当前时间
        time_t now = time(NULL);
        struct tm *tm_info = localtime(&now);
        char time_str[20];
        strftime(time_str, sizeof(time_str), "%H:%M:%S", tm_info);
        
        if (OS_WINDOWS) {
            snprintf(command, sizeof(command), 
                    "tasklist /fi \"imagename eq %s\" | find \"%s\" >nul 2>&1",
                    process_name, process_name);
        } else {
            snprintf(command, sizeof(command), 
                    "pgrep %s > /dev/null 2>&1", process_name);
        }
        
        int result = system(command);
        
        if (result == 0) {
            printf("[%s] 运行中 (检查 #%d)\n", time_str, check_count);
        } else {
            printf("[%s] 未运行 (检查 #%d)\n", time_str, check_count);
        }
        
        // 等待指定间隔
        #ifdef _WIN32
            Sleep(interval * 1000);
        #else
            sleep(interval);
        #endif
    }
    
    printf("\n监控结束，共检查 %d 次\n", check_count);
}

/**
 * 主函数 - 演示各种功能
 */
int main() {
    printf("C语言 进程管理演示\n");
    printf("对比 CMD 的 tasklist, taskkill, systeminfo 等命令\n");
    printf("\n");
    
    // 1. 获取系统信息
    get_system_info();
    
    // 2. 获取进程列表
    get_process_list();
    
    // 3. 查找特定进程
    find_process("explorer.exe");
    
    // 4. 获取服务列表
    get_service_list();
    
    // 5. 获取详细进程信息
    get_process_details_wmic();
    
    // 6. 演示进程终止（仅显示命令）
    kill_process(1234, 0);
    
    printf("\n============================================================\n");
    printf("演示完成\n");
    printf("============================================================\n");
    
    return 0;
}
