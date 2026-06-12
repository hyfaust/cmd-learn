/*
 * C语言条件语句对比示例
 * 用于与CMD的if语句进行对比
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/stat.h>

int main() {
    printf("C语言条件语句示例\n");
    printf("==================================================\n");
    
    // 1. 基本if/else if/else
    printf("\n1. 基本if/else if/else:\n");
    int score = 85;
    
    if (score >= 90) {
        printf("   成绩优秀\n");
    } else if (score >= 80) {
        printf("   成绩良好\n");
    } else if (score >= 60) {
        printf("   成绩及格\n");
    } else {
        printf("   成绩不及格\n");
    }
    
    // 2. 字符串比较
    printf("\n2. 字符串比较:\n");
    char name[] = "test";
    
    if (strcmp(name, "test") == 0) {
        printf("   字符串相等\n");
    } else {
        printf("   字符串不相等\n");
    }
    
    // 3. 数值比较运算符
    printf("\n3. 数值比较运算符:\n");
    int a = 10;
    int b = 20;
    
    printf("   比较 %d 和 %d:\n", a, b);
    printf("   %d == %d: %s\n", a, b, (a == b) ? "真" : "假");
    printf("   %d != %d: %s\n", a, b, (a != b) ? "真" : "假");
    printf("   %d < %d: %s\n", a, b, (a < b) ? "真" : "假");
    printf("   %d <= %d: %s\n", a, b, (a <= b) ? "真" : "假");
    printf("   %d > %d: %s\n", a, b, (a > b) ? "真" : "假");
    printf("   %d >= %d: %s\n", a, b, (a >= b) ? "真" : "假");
    
    // 4. 字符串比较与数值比较的区别
    printf("\n4. 字符串比较与数值比较的区别:\n");
    char str1[] = "10";
    char str2[] = "010";
    
    // 字符串比较
    if (strcmp(str1, str2) == 0) {
        printf("   字符串比较: \"%s\" == \"%s\" = 相等\n", str1, str2);
    } else {
        printf("   字符串比较: \"%s\" == \"%s\" = 不相等\n", str1, str2);
    }
    
    // 数值比较
    int num1 = atoi(str1);
    int num2 = atoi(str2);
    
    if (num1 == num2) {
        printf("   数值比较: %d == %d = 相等\n", num1, num2);
    } else {
        printf("   数值比较: %d == %d = 不相等\n", num1, num2);
    }
    
    // 5. 文件存在性检查
    printf("\n5. 文件存在性检查:\n");
    
    // 检查文件
    struct stat buffer;
    if (stat("if_basics.bat", &buffer) == 0) {
        printf("   if_basics.bat 存在\n");
    } else {
        printf("   if_basics.bat 不存在\n");
    }
    
    // 6. 逻辑运算符
    printf("\n6. 逻辑运算符:\n");
    int x = 15;
    
    // && (逻辑与)
    if (x > 10 && x < 20) {
        printf("   %d 在10到20之间 (&&)\n", x);
    }
    
    // || (逻辑或)
    if (x < 10 || x > 20) {
        printf("   %d 小于10或大于20 (||)\n", x);
    } else {
        printf("   %d 不在范围外 (||)\n", x);
    }
    
    // ! (逻辑非)
    if (!(x > 100)) {
        printf("   %d 不大于100 (!)\n", x);
    }
    
    // 7. 条件表达式（三元运算符）
    printf("\n7. 条件表达式（三元运算符）:\n");
    int age = 20;
    const char *status = (age >= 18) ? "成年" : "未成年";
    printf("   年龄: %d, 状态: %s\n", age, status);
    
    // 8. 多条件检查
    printf("\n8. 多条件检查:\n");
    char username[] = "admin";
    char password[] = "123456";
    
    if (strcmp(username, "admin") == 0 && strcmp(password, "123456") == 0) {
        printf("   登录成功\n");
    } else {
        printf("   登录失败\n");
    }
    
    // 9. switch语句
    printf("\n9. switch语句:\n");
    int day = 1; // 1 = Monday
    
    switch (day) {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
            printf("   工作日\n");
            break;
        case 6:
        case 7:
            printf("   周末\n");
            break;
        default:
            printf("   无效\n");
    }
    
    // 10. 位运算与条件
    printf("\n10. 位运算与条件:\n");
    int flags = 0x0F; // 二进制: 00001111
    
    if (flags & 0x01) {
        printf("   位0被设置\n");
    }
    
    if (flags & 0x02) {
        printf("   位1被设置\n");
    }
    
    if (flags & 0x04) {
        printf("   位2被设置\n");
    }
    
    if (flags & 0x08) {
        printf("   位3被设置\n");
    }
    
    // 11. 空值检查
    printf("\n11. 空值检查:\n");
    int *null_ptr = NULL;
    
    if (null_ptr == NULL) {
        printf("   空指针检查\n");
    }
    
    // 12. 数组边界检查
    printf("\n12. 数组边界检查:\n");
    int arr[] = {1, 2, 3, 4, 5};
    int index = 3;
    int size = sizeof(arr) / sizeof(arr[0]);
    
    if (index >= 0 && index < size) {
        printf("   arr[%d] = %d\n", index, arr[index]);
    } else {
        printf("   索引越界\n");
    }
    
    printf("\nC语言条件语句示例完成\n");
    return 0;
}