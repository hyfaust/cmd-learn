/* ============================================================
 * comparison.c - C语言函数对比
 * 第07章 函数与模块化示例
 *
 * 安全提示：本脚本仅进行变量操作和控制流演示
 *
 * 编译命令: gcc comparison.c -o comparison.exe
 * 运行命令: comparison.exe
 * ============================================================ */

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

/* 1. 基本函数定义 */
void greet(const char *name) {
    /* 对应CMD的:greet */
    printf("你好, %s! 欢迎学习批处理编程。\n", name);
}

/* 2. 带返回值的函数 */
int add(int a, int b) {
    /* 对应CMD的:add */
    return a + b;
}

int multiply(int a, int b) {
    /* 对应CMD的:multiply */
    return a * b;
}

/* 3. 通过指针返回多个值 */
void get_min_max(int numbers[], int size, int *min, int *max) {
    /* 对应CMD的:get_min_max */
    if (size <= 0) {
        *min = 0;
        *max = 0;
        return;
    }
    
    *min = numbers[0];
    *max = numbers[0];
    
    for (int i = 1; i < size; i++) {
        if (numbers[i] < *min) *min = numbers[i];
        if (numbers[i] > *max) *max = numbers[i];
    }
}

/* 4. 默认参数（C没有，但可以通过宏模拟）*/
#define GREET_WITH_DEFAULT(name) greet_with_default(name, "Hello")
#define GREET_WITH_MSG(name, msg) greet_with_default(name, msg)

void greet_with_default(const char *name, const char *greeting) {
    printf("%s, %s!\n", greeting, name);
}

/* 5. 可变参数函数 */
int sum_all(int count, ...) {
    /* 对应CMD的sum_array */
    va_list args;
    int sum = 0;
    
    va_start(args, count);
    for (int i = 0; i < count; i++) {
        sum += va_arg(args, int);
    }
    va_end(args);
    
    return sum;
}

/* 6. 作用域演示 */
void scope_demo(void) {
    /* 对应CMD的setlocal/endlocal */
    char *local_var = "I am local";  /* 局部变量 */
    printf("函数内 local_var: %s\n", local_var);
    /* 注意：C语言中局部变量在函数返回后自动销毁 */
}

/* 7. 函数指针（高阶函数）*/
typedef int (*Operation)(int, int);

int apply_operation(int a, int b, Operation op) {
    return op(a, b);
}

/* 8. 递归函数 */
int factorial(int n) {
    /* 对应CMD的递归调用 */
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}

/* 9. 回调函数 */
void process_array(int arr[], int size, void (*callback)(int)) {
    for (int i = 0; i < size; i++) {
        callback(arr[i]);
    }
}

void print_number(int n) {
    printf("%d ", n);
}

void print_square(int n) {
    printf("%d ", n * n);
}

/* ============================================================
 * 主程序
 * ============================================================ */
int main(void) {
    printf("==================================================\n");
    printf("C语言函数对比演示\n");
    printf("==================================================\n\n");
    
    /* 调用基本函数 */
    printf("=== 基本函数调用 ===\n");
    greet("Alice");
    greet("Bob");
    printf("\n");
    
    /* 调用带返回值的函数 */
    printf("=== 返回值 ===\n");
    printf("add(3, 5) = %d\n", add(3, 5));
    printf("multiply(4, 6) = %d\n", multiply(4, 6));
    printf("\n");
    
    /* 多返回值（通过指针）*/
    printf("=== 多返回值（通过指针）===\n");
    int numbers[] = {5, 2, 8, 1, 9};
    int min_val, max_val;
    get_min_max(numbers, 5, &min_val, &max_val);
    printf("最小值: %d, 最大值: %d\n", min_val, max_val);
    printf("\n");
    
    /* 默认参数（宏模拟）*/
    printf("=== 默认参数（宏模拟）===\n");
    GREET_WITH_DEFAULT("Alice");
    GREET_WITH_MSG("Bob", "Hi");
    printf("\n");
    
    /* 可变参数 */
    printf("=== 可变参数 ===\n");
    printf("sum_all(5, 1, 2, 3, 4, 5) = %d\n", sum_all(5, 1, 2, 3, 4, 5));
    printf("\n");
    
    /* 作用域演示 */
    printf("=== 作用域演示 ===\n");
    char *global_var = "I am global";
    printf("调用前 global_var: %s\n", global_var);
    scope_demo();
    printf("调用后 global_var: %s\n", global_var);
    printf("\n");
    
    /* 函数指针 */
    printf("=== 函数指针 ===\n");
    printf("apply_operation(10, 5, add) = %d\n", apply_operation(10, 5, add));
    printf("apply_operation(10, 5, multiply) = %d\n", apply_operation(10, 5, multiply));
    printf("\n");
    
    /* 递归 */
    printf("=== 递归函数 ===\n");
    printf("factorial(5) = %d\n", factorial(5));
    printf("factorial(10) = %d\n", factorial(10));
    printf("\n");
    
    /* 回调函数 */
    printf("=== 回调函数 ===\n");
    int arr[] = {1, 2, 3, 4, 5};
    printf("数组: ");
    process_array(arr, 5, print_number);
    printf("\n");
    printf("平方: ");
    process_array(arr, 5, print_square);
    printf("\n\n");
    
    /* 结构体和函数 */
    printf("=== 结构体和函数 ===\n");
    /* 注意：C语言中结构体可以直接作为参数传递 */
    printf("C语言支持结构体作为函数参数\n");
    printf("这比CMD的参数传递更灵活\n");
    
    return 0;
}
