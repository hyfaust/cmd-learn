// C语言数据结构对比示例
// 展示C语言中数据结构的实现方式，与CMD的模拟方式对比

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

// 1. 数组操作
void array_demo() {
    printf("=== 1. 数组 ===\n");
    
    // 静态数组
    int arr[5] = {1, 2, 3, 4, 5};
    printf("静态数组: ");
    for (int i = 0; i < 5; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
    
    // 动态数组
    int *dynamic_arr = (int*)malloc(5 * sizeof(int));
    if (dynamic_arr == NULL) {
        printf("内存分配失败！\n");
        return;
    }
    
    for (int i = 0; i < 5; i++) {
        dynamic_arr[i] = (i + 1) * 10;
    }
    
    printf("动态数组: ");
    for (int i = 0; i < 5; i++) {
        printf("%d ", dynamic_arr[i]);
    }
    printf("\n");
    
    // 修改元素
    dynamic_arr[2] = 100;
    printf("修改后: ");
    for (int i = 0; i < 5; i++) {
        printf("%d ", dynamic_arr[i]);
    }
    printf("\n");
    
    // 释放内存
    free(dynamic_arr);
    printf("\n");
}

// 2. 结构体（字典模拟）
struct Person {
    char name[50];
    int age;
    char city[50];
    char role[50];
};

void struct_demo() {
    printf("=== 2. 结构体（字典模拟）===\n");
    
    // 创建结构体实例
    struct Person person;
    strcpy(person.name, "Alice");
    person.age = 25;
    strcpy(person.city, "Beijing");
    strcpy(person.role, "Developer");
    
    printf("姓名: %s\n", person.name);
    printf("年龄: %d\n", person.age);
    printf("城市: %s\n", person.city);
    printf("角色: %s\n", person.role);
    
    // 修改结构体
    person.age = 26;
    printf("修改后年龄: %d\n", person.age);
    printf("\n");
}

// 3. 链表节点定义
struct Node {
    int data;
    struct Node* next;
};

// 链表操作函数
struct Node* create_node(int data) {
    struct Node* new_node = (struct Node*)malloc(sizeof(struct Node));
    if (new_node == NULL) {
        printf("内存分配失败！\n");
        exit(1);
    }
    new_node->data = data;
    new_node->next = NULL;
    return new_node;
}

void append_node(struct Node** head, int data) {
    struct Node* new_node = create_node(data);
    
    if (*head == NULL) {
        *head = new_node;
        return;
    }
    
    struct Node* current = *head;
    while (current->next != NULL) {
        current = current->next;
    }
    current->next = new_node;
}

void print_list(struct Node* head) {
    struct Node* current = head;
    printf("链表: ");
    while (current != NULL) {
        printf("%d -> ", current->data);
        current = current->next;
    }
    printf("NULL\n");
}

void free_list(struct Node* head) {
    struct Node* temp;
    while (head != NULL) {
        temp = head;
        head = head->next;
        free(temp);
    }
}

void linked_list_demo() {
    printf("=== 3. 链表 ===\n");
    
    struct Node* head = NULL;
    
    // 添加节点
    append_node(&head, 10);
    append_node(&head, 20);
    append_node(&head, 30);
    append_node(&head, 40);
    
    print_list(head);
    
    // 释放内存
    free_list(head);
    printf("\n");
}

// 4. 栈实现
#define MAX_STACK_SIZE 100

struct Stack {
    int items[MAX_STACK_SIZE];
    int top;
};

void init_stack(struct Stack* stack) {
    stack->top = -1;
}

int is_stack_empty(struct Stack* stack) {
    return stack->top == -1;
}

int is_stack_full(struct Stack* stack) {
    return stack->top == MAX_STACK_SIZE - 1;
}

void push(struct Stack* stack, int item) {
    if (is_stack_full(stack)) {
        printf("栈已满！\n");
        return;
    }
    stack->items[++stack->top] = item;
    printf("入栈: %d\n", item);
}

int pop(struct Stack* stack) {
    if (is_stack_empty(stack)) {
        printf("栈为空！\n");
        return -1;
    }
    return stack->items[stack->top--];
}

int peek(struct Stack* stack) {
    if (is_stack_empty(stack)) {
        printf("栈为空！\n");
        return -1;
    }
    return stack->items[stack->top];
}

void stack_demo() {
    printf("=== 4. 栈（后进先出）===\n");
    
    struct Stack stack;
    init_stack(&stack);
    
    // 入栈
    push(&stack, 10);
    push(&stack, 20);
    push(&stack, 30);
    
    printf("栈顶元素: %d\n", peek(&stack));
    
    // 出栈
    printf("出栈: %d\n", pop(&stack));
    printf("出栈: %d\n", pop(&stack));
    printf("剩余栈顶: %d\n", peek(&stack));
    printf("\n");
}

// 5. 队列实现
#define MAX_QUEUE_SIZE 100

struct Queue {
    int items[MAX_QUEUE_SIZE];
    int front;
    int rear;
    int size;
};

void init_queue(struct Queue* queue) {
    queue->front = 0;
    queue->rear = -1;
    queue->size = 0;
}

int is_queue_empty(struct Queue* queue) {
    return queue->size == 0;
}

int is_queue_full(struct Queue* queue) {
    return queue->size == MAX_QUEUE_SIZE;
}

void enqueue(struct Queue* queue, int item) {
    if (is_queue_full(queue)) {
        printf("队列已满！\n");
        return;
    }
    queue->rear = (queue->rear + 1) % MAX_QUEUE_SIZE;
    queue->items[queue->rear] = item;
    queue->size++;
    printf("入队: %d\n", item);
}

int dequeue(struct Queue* queue) {
    if (is_queue_empty(queue)) {
        printf("队列为空！\n");
        return -1;
    }
    int item = queue->items[queue->front];
    queue->front = (queue->front + 1) % MAX_QUEUE_SIZE;
    queue->size--;
    return item;
}

int queue_front(struct Queue* queue) {
    if (is_queue_empty(queue)) {
        printf("队列为空！\n");
        return -1;
    }
    return queue->items[queue->front];
}

void queue_demo() {
    printf("=== 5. 队列（先进先出）===\n");
    
    struct Queue queue;
    init_queue(&queue);
    
    // 入队
    enqueue(&queue, 100);
    enqueue(&queue, 200);
    enqueue(&queue, 300);
    
    printf("队首元素: %d\n", queue_front(&queue));
    
    // 出队
    printf("出队: %d\n", dequeue(&queue));
    printf("出队: %d\n", dequeue(&queue));
    printf("剩余队首: %d\n", queue_front(&queue));
    printf("\n");
}

// 6. 二维数组（矩阵）
void matrix_demo() {
    printf("=== 6. 二维数组（矩阵）===\n");
    
    int matrix[3][3] = {
        {1, 2, 3},
        {4, 5, 6},
        {7, 8, 9}
    };
    
    printf("矩阵:\n");
    for (int i = 0; i < 3; i++) {
        printf("  ");
        for (int j = 0; j < 3; j++) {
            printf("%d ", matrix[i][j]);
        }
        printf("\n");
    }
    
    // 矩阵转置
    int transposed[3][3];
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            transposed[j][i] = matrix[i][j];
        }
    }
    
    printf("转置矩阵:\n");
    for (int i = 0; i < 3; i++) {
        printf("  ");
        for (int j = 0; j < 3; j++) {
            printf("%d ", transposed[i][j]);
        }
        printf("\n");
    }
    
    // 动态分配二维数组
    int rows = 2, cols = 3;
    int **dynamic_matrix = (int**)malloc(rows * sizeof(int*));
    for (int i = 0; i < rows; i++) {
        dynamic_matrix[i] = (int*)malloc(cols * sizeof(int));
    }
    
    // 初始化
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            dynamic_matrix[i][j] = (i + 1) * 10 + (j + 1);
        }
    }
    
    printf("动态矩阵 (%dx%d):\n", rows, cols);
    for (int i = 0; i < rows; i++) {
        printf("  ");
        for (int j = 0; j < cols; j++) {
            printf("%d ", dynamic_matrix[i][j]);
        }
        printf("\n");
    }
    
    // 释放内存
    for (int i = 0; i < rows; i++) {
        free(dynamic_matrix[i]);
    }
    free(dynamic_matrix);
    printf("\n");
}

// 7. 哈希表实现（简化版）
#define HASH_TABLE_SIZE 100

struct HashEntry {
    char key[50];
    int value;
    int is_occupied;
};

struct HashTable {
    struct HashEntry entries[HASH_TABLE_SIZE];
};

unsigned int hash_function(const char* key) {
    unsigned int hash = 0;
    while (*key) {
        hash = (hash * 31) + *key;
        key++;
    }
    return hash % HASH_TABLE_SIZE;
}

void hash_table_init(struct HashTable* table) {
    for (int i = 0; i < HASH_TABLE_SIZE; i++) {
        table->entries[i].is_occupied = 0;
    }
}

void hash_table_set(struct HashTable* table, const char* key, int value) {
    unsigned int index = hash_function(key);
    
    // 线性探测
    while (table->entries[index].is_occupied) {
        if (strcmp(table->entries[index].key, key) == 0) {
            table->entries[index].value = value;
            return;
        }
        index = (index + 1) % HASH_TABLE_SIZE;
    }
    
    strcpy(table->entries[index].key, key);
    table->entries[index].value = value;
    table->entries[index].is_occupied = 1;
}

int hash_table_get(struct HashTable* table, const char* key, int* value) {
    unsigned int index = hash_function(key);
    
    while (table->entries[index].is_occupied) {
        if (strcmp(table->entries[index].key, key) == 0) {
            *value = table->entries[index].value;
            return 1; // 找到
        }
        index = (index + 1) % HASH_TABLE_SIZE;
    }
    
    return 0; // 未找到
}

void hash_table_demo() {
    printf("=== 7. 哈希表（字典）===\n");
    
    struct HashTable table;
    hash_table_init(&table);
    
    // 设置键值对
    hash_table_set(&table, "name", 100);
    hash_table_set(&table, "age", 25);
    hash_table_set(&table, "score", 95);
    
    // 获取值
    int value;
    if (hash_table_get(&table, "name", &value)) {
        printf("name = %d\n", value);
    }
    if (hash_table_get(&table, "age", &value)) {
        printf("age = %d\n", value);
    }
    if (hash_table_get(&table, "score", &value)) {
        printf("score = %d\n", value);
    }
    
    // 修改值
    hash_table_set(&table, "age", 26);
    if (hash_table_get(&table, "age", &value)) {
        printf("修改后 age = %d\n", value);
    }
    printf("\n");
}

// 8. 性能测试
void performance_demo() {
    printf("=== 8. 性能对比 ===\n");
    
    clock_t start, end;
    double cpu_time_used;
    
    // 数组性能
    start = clock();
    int* big_array = (int*)malloc(1000000 * sizeof(int));
    for (int i = 0; i < 1000000; i++) {
        big_array[i] = i;
    }
    end = clock();
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
    printf("创建100万元素数组: %.4f秒\n", cpu_time_used);
    
    start = clock();
    int access = big_array[500000];
    end = clock();
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
    printf("访问数组元素: %.8f秒\n", cpu_time_used);
    
    free(big_array);
    
    // 链表性能
    start = clock();
    struct Node* list_head = NULL;
    for (int i = 0; i < 100000; i++) {
        append_node(&list_head, i);
    }
    end = clock();
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
    printf("创建10万元素链表: %.4f秒\n", cpu_time_used);
    
    free_list(list_head);
    printf("\n");
}

// 9. 函数指针和回调（高级特性）
typedef void (*PrintFunc)(int);

void print_value(int value) {
    printf("%d ", value);
}

void print_square(int value) {
    printf("%d ", value * value);
}

void apply_to_array(int arr[], int size, PrintFunc func) {
    for (int i = 0; i < size; i++) {
        func(arr[i]);
    }
    printf("\n");
}

void function_pointer_demo() {
    printf("=== 9. 函数指针（高级特性）===\n");
    
    int arr[] = {1, 2, 3, 4, 5};
    int size = sizeof(arr) / sizeof(arr[0]);
    
    printf("原始值: ");
    apply_to_array(arr, size, print_value);
    
    printf("平方值: ");
    apply_to_array(arr, size, print_square);
    printf("\n");
}

int main() {
    printf("=== C语言数据结构对比示例 ===\n");
    printf("展示C语言中数据结构的实现方式，与CMD的模拟方式对比\n\n");
    
    array_demo();
    struct_demo();
    linked_list_demo();
    stack_demo();
    queue_demo();
    matrix_demo();
    hash_table_demo();
    performance_demo();
    function_pointer_demo();
    
    printf("=== 对比总结 ===\n");
    printf("C语言数据结构的优势:\n");
    printf("1. 底层控制，内存直接管理\n");
    printf("2. 高性能，接近硬件\n");
    printf("3. 可自定义复杂数据结构\n");
    printf("4. 编译时类型检查\n");
    printf("5. 广泛的系统编程支持\n\n");
    
    printf("CMD模拟数据结构的限制:\n");
    printf("1. 无法直接管理内存\n");
    printf("2. 性能较差，解释执行\n");
    printf("3. 变量类型单一（字符串）\n");
    printf("4. 缺少指针和引用\n");
    printf("5. 调试困难，没有现代工具\n");
    
    return 0;
}