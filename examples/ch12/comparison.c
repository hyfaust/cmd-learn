/**
 * comparison.c - C语言任务调度实现对比
 * 本程序展示C语言中任务调度的多种实现方式
 * 包括Windows API定时器、标准库和信号处理
 */

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <windows.h>
#include <process.h>
#include <signal.h>

// ============================================================
// 方法1: 使用标准库time.h（跨平台）
// ============================================================

void standard_timer_demo() {
    printf("\n=== 标准库time.h演示 ===\n");
    
    time_t start_time, current_time;
    int elapsed_seconds = 0;
    
    // 记录开始时间
    start_time = time(NULL);
    
    printf("开始计时...\n");
    
    // 模拟定时任务
    while (elapsed_seconds < 10) {
        current_time = time(NULL);
        elapsed_seconds = (int)difftime(current_time, start_time);
        
        // 每2秒执行一次任务
        if (elapsed_seconds % 2 == 0 && elapsed_seconds > 0) {
            printf("[%s] 定时任务执行 (已过去 %d 秒)\n", 
                   ctime(&current_time), elapsed_seconds);
        }
        
        Sleep(1000); // 暂停1秒
    }
    
    printf("标准库计时演示完成\n");
}

// ============================================================
// 方法2: 使用Windows API定时器
// ============================================================

// 定时器回调函数
VOID CALLBACK TimerProc(HWND hwnd, UINT uMsg, UINT_PTR idEvent, DWORD dwTime) {
    static int call_count = 0;
    call_count++;
    
    time_t now = time(NULL);
    printf("[Timer回调] 第 %d 次执行 (时间: %s)\n", call_count, ctime(&now));
    
    // 5次后停止定时器
    if (call_count >= 5) {
        KillTimer(hwnd, idEvent);
        printf("定时器已停止\n");
        PostQuitMessage(0);
    }
}

void windows_timer_demo() {
    printf("\n=== Windows API定时器演示 ===\n");
    
    // 创建定时器（每1秒触发）
    UINT_PTR timer_id = SetTimer(NULL, 1, 1000, TimerProc);
    
    if (timer_id == 0) {
        printf("创建定时器失败\n");
        return;
    }
    
    printf("定时器已启动（每1秒触发）\n");
    
    // 消息循环
    MSG msg;
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }
    
    printf("Windows定时器演示完成\n");
}

// ============================================================
// 方法3: 使用多线程实现定时任务
// ============================================================

// 任务参数结构体
typedef struct {
    char* task_name;
    int interval_ms;
    int max_count;
} TaskParam;

// 工作线程函数
unsigned __stdcall worker_thread(void* param) {
    TaskParam* task = (TaskParam*)param;
    int count = 0;
    
    printf("线程开始: %s (间隔: %dms)\n", task->task_name, task->interval_ms);
    
    while (count < task->max_count) {
        time_t now = time(NULL);
        printf("[%s] 任务 '%s' 第 %d 次执行\n", ctime(&now), task->task_name, count + 1);
        
        Sleep(task->interval_ms);
        count++;
    }
    
    printf("线程结束: %s\n", task->task_name);
    return 0;
}

void thread_timer_demo() {
    printf("\n=== 多线程定时任务演示 ===\n");
    
    // 创建多个任务参数
    TaskParam task1 = {"任务A", 1000, 5};  // 每1秒，执行5次
    TaskParam task2 = {"任务B", 2000, 3};  // 每2秒，执行3次
    TaskParam task3 = {"任务C", 1500, 4};  // 每1.5秒，执行4次
    
    // 创建线程
    HANDLE threads[3];
    threads[0] = (HANDLE)_beginthreadex(NULL, 0, worker_thread, &task1, 0, NULL);
    threads[1] = (HANDLE)_beginthreadex(NULL, 0, worker_thread, &task2, 0, NULL);
    threads[2] = (HANDLE)_beginthreadex(NULL, 0, worker_thread, &task3, 0, NULL);
    
    // 等待所有线程完成
    WaitForMultipleObjects(3, threads, TRUE, INFINITE);
    
    // 关闭线程句柄
    for (int i = 0; i < 3; i++) {
        CloseHandle(threads[i]);
    }
    
    printf("多线程演示完成\n");
}

// ============================================================
// 方法4: 使用信号处理（SIGALRM）
// ============================================================

volatile int signal_count = 0;

void signal_handler(int signum) {
    signal_count++;
    time_t now = time(NULL);
    printf("[信号处理] SIGALRM 第 %d 次触发 (时间: %s)\n", signal_count, ctime(&now));
}

void signal_timer_demo() {
    printf("\n=== 信号处理定时器演示 ===\n");
    
    // 注意：SIGALRM在Windows上不可用
    // 这里使用模拟方式演示信号处理的概念
    
    printf("注意：SIGALRM在Windows上不可用\n");
    printf("使用模拟方式演示信号处理概念\n");
    
    // 模拟信号处理
    for (int i = 0; i < 5; i++) {
        printf("[模拟信号] 第 %d 次触发\n", i + 1);
        Sleep(1000);
    }
    
    printf("信号处理演示完成\n");
}

// ============================================================
// 方法5: 使用WaitableTimer（Windows特有）
// ============================================================

void waitable_timer_demo() {
    printf("\n=== WaitableTimer演示 ===\n");
    
    // 创建可等待定时器
    HANDLE hTimer = CreateWaitableTimer(NULL, TRUE, NULL);
    if (hTimer == NULL) {
        printf("创建定时器失败\n");
        return;
    }
    
    // 设置定时器（5秒后触发）
    LARGE_INTEGER liDueTime;
    liDueTime.QuadPart = -50000000LL; // 5秒（单位：100纳秒）
    
    if (!SetWaitableTimer(hTimer, &liDueTime, 0, NULL, NULL, FALSE)) {
        printf("设置定时器失败\n");
        CloseHandle(hTimer);
        return;
    }
    
    printf("定时器已设置，5秒后触发...\n");
    
    // 等待定时器
    DWORD result = WaitForSingleObject(hTimer, INFINITE);
    
    if (result == WAIT_OBJECT_0) {
        time_t now = time(NULL);
        printf("[WaitableTimer] 定时器触发 (时间: %s)\n", ctime(&now));
    }
    
    // 清理
    CancelWaitableTimer(hTimer);
    CloseHandle(hTimer);
    
    printf("WaitableTimer演示完成\n");
}

// ============================================================
// 实用工具结构体和函数
// ============================================================

// 定时任务结构体
typedef struct {
    char name[50];
    int interval_ms;
    int max_runs;
    int current_runs;
    time_t last_run;
    void (*callback)(void*);
    void* callback_data;
} ScheduledTask;

// 任务调度器结构体
typedef struct {
    ScheduledTask tasks[10];
    int task_count;
    int running;
} TaskScheduler;

// 初始化调度器
void scheduler_init(TaskScheduler* scheduler) {
    scheduler->task_count = 0;
    scheduler->running = 0;
}

// 添加任务
int scheduler_add_task(TaskScheduler* scheduler, const char* name, 
                      int interval_ms, int max_runs, 
                      void (*callback)(void*), void* data) {
    if (scheduler->task_count >= 10) {
        printf("错误：任务数量已达上限\n");
        return -1;
    }
    
    ScheduledTask* task = &scheduler->tasks[scheduler->task_count];
    strncpy(task->name, name, sizeof(task->name) - 1);
    task->interval_ms = interval_ms;
    task->max_runs = max_runs;
    task->current_runs = 0;
    task->last_run = 0;
    task->callback = callback;
    task->callback_data = data;
    
    scheduler->task_count++;
    printf("已添加任务: %s (间隔: %dms, 最大执行次数: %d)\n", name, interval_ms, max_runs);
    return 0;
}

// 任务回调函数示例
void sample_task_callback(void* data) {
    char* task_name = (char*)data;
    time_t now = time(NULL);
    printf("[任务回调] %s 执行 (时间: %s)\n", task_name, ctime(&now));
}

// 运行调度器
void scheduler_run(TaskScheduler* scheduler, int duration_ms) {
    scheduler->running = 1;
    time_t start_time = time(NULL);
    
    printf("调度器开始运行...\n");
    
    while (scheduler->running) {
        time_t current_time = time(NULL);
        int elapsed_ms = (int)difftime(current_time, start_time) * 1000;
        
        // 检查是否超过运行时间
        if (duration_ms > 0 && elapsed_ms >= duration_ms) {
            scheduler->running = 0;
            break;
        }
        
        // 检查任务
        for (int i = 0; i < scheduler->task_count; i++) {
            ScheduledTask* task = &scheduler->tasks[i];
            
            // 检查是否达到最大执行次数
            if (task->max_runs > 0 && task->current_runs >= task->max_runs) {
                continue;
            }
            
            // 检查是否到了执行时间
            int time_since_last = (int)difftime(current_time, task->last_run) * 1000;
            if (task->last_run == 0 || time_since_last >= task->interval_ms) {
                if (task->callback) {
                    task->callback(task->callback_data);
                }
                task->current_runs++;
                task->last_run = current_time;
            }
        }
        
        Sleep(100); // 100ms检查间隔
    }
    
    printf("调度器已停止\n");
}

// 获取调度器统计信息
void scheduler_get_stats(TaskScheduler* scheduler) {
    printf("\n任务统计:\n");
    for (int i = 0; i < scheduler->task_count; i++) {
        ScheduledTask* task = &scheduler->tasks[i];
        printf("  - %s: 执行次数 %d\n", task->name, task->current_runs);
    }
}

// ============================================================
// 与CMD对比分析
// ============================================================

void comparison_analysis() {
    printf("\n=== C语言 vs CMD 任务调度对比 ===\n");
    
    printf("\n持久化:\n");
    printf("  CMD: 系统级持久化（任务计划程序）\n");
    printf("  C: 内存级（需额外存储）\n");
    
    printf("\n精确度:\n");
    printf("  CMD: 分钟级\n");
    printf("  C: 毫秒级甚至微秒级\n");
    
    printf("\n复杂调度:\n");
    printf("  CMD: 基本（每日、每周等）\n");
    printf("  C: 强大（自定义逻辑、多线程）\n");
    
    printf("\n错误处理:\n");
    printf("  CMD: 有限\n");
    printf("  C: 完整（信号处理、异常处理）\n");
    
    printf("\n性能:\n");
    printf("  CMD: 一般\n");
    printf("  C: 高性能（原生代码）\n");
    
    printf("\n跨平台:\n");
    printf("  CMD: 仅Windows\n");
    printf("  C: 跨平台（需条件编译）\n");
    
    printf("\n开发复杂度:\n");
    printf("  CMD: 简单\n");
    printf("  C: 复杂（手动内存管理）\n");
}

// ============================================================
// 主程序
// ============================================================

int main() {
    printf("C语言任务调度实现对比\n");
    printf("==================================================\n");
    
    // 显示对比分析
    comparison_analysis();
    
    printf("\n==================================================\n");
    printf("开始运行演示\n");
    printf("==================================================\n");
    
    // 方法1: 标准库计时
    standard_timer_demo();
    
    // 方法2: Windows API定时器
    windows_timer_demo();
    
    // 方法3: 多线程定时任务
    thread_timer_demo();
    
    // 方法4: 信号处理
    signal_timer_demo();
    
    // 方法5: WaitableTimer
    waitable_timer_demo();
    
    // 自定义调度器演示
    printf("\n=== 自定义调度器演示 ===\n");
    
    TaskScheduler scheduler;
    scheduler_init(&scheduler);
    
    // 添加任务
    scheduler_add_task(&scheduler, "任务A", 1000, 5, sample_task_callback, "任务A");
    scheduler_add_task(&scheduler, "任务B", 2000, 3, sample_task_callback, "任务B");
    scheduler_add_task(&scheduler, "任务C", 1500, 4, sample_task_callback, "任务C");
    
    // 运行调度器（10秒）
    scheduler_run(&scheduler, 10000);
    
    // 显示统计信息
    scheduler_get_stats(&scheduler);
    
    printf("\n==================================================\n");
    printf("演示完成！\n");
    printf("==================================================\n");
    
    return 0;
}