/**
 * comparison.c - C语言socket编程示例
 * 功能：演示使用C语言socket进行HTTP请求
 * 对比：与CMD curl命令的对比
 * 
 * 编译：gcc comparison.c -o comparison -lws2_32 (Windows)
 *       gcc comparison.c -o comparison (Linux/macOS)
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef _WIN32
    #include <winsock2.h>
    #include <ws2tcpip.h>
    #pragma comment(lib, "ws2_32.lib")
#else
    #include <sys/socket.h>
    #include <netinet/in.h>
    #include <arpa/inet.h>
    #include <netdb.h>
    #include <unistd.h>
#endif

#define BUFFER_SIZE 4096
#define HTTP_PORT 80
#define HTTPS_PORT 443

// 初始化socket库（Windows需要）
int init_socket() {
#ifdef _WIN32
    WSADATA wsaData;
    return WSAStartup(MAKEWORD(2, 2), &wsaData);
#else
    return 0;
#endif
}

// 清理socket库
void cleanup_socket() {
#ifdef _WIN32
    WSACleanup();
#endif
}

// 关闭socket
void close_socket(int sock) {
#ifdef _WIN32
    closesocket(sock);
#else
    close(sock);
#endif
}

// 发送HTTP GET请求
int http_get(const char *host, const char *path, char *response, int response_size) {
    int sock;
    struct sockaddr_in server_addr;
    struct hostent *server;
    char request[BUFFER_SIZE];
    int bytes_received;
    
    // 创建socket
    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) {
        perror("创建socket失败");
        return -1;
    }
    
    // 解析主机名
    server = gethostbyname(host);
    if (server == NULL) {
        fprintf(stderr, "DNS解析失败: %s\n", host);
        close_socket(sock);
        return -1;
    }
    
    // 设置服务器地址
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(HTTP_PORT);
    memcpy(&server_addr.sin_addr.s_addr, server->h_addr, server->h_length);
    
    // 连接服务器
    if (connect(sock, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("连接服务器失败");
        close_socket(sock);
        return -1;
    }
    
    // 构建HTTP请求
    snprintf(request, sizeof(request),
        "GET %s HTTP/1.1\r\n"
        "Host: %s\r\n"
        "User-Agent: C-Tutorial/1.0\r\n"
        "Accept: text/html,application/json\r\n"
        "Connection: close\r\n"
        "\r\n",
        path, host);
    
    // 发送请求
    if (send(sock, request, strlen(request), 0) < 0) {
        perror("发送请求失败");
        close_socket(sock);
        return -1;
    }
    
    // 接收响应
    int total_received = 0;
    while (total_received < response_size - 1) {
        bytes_received = recv(sock, response + total_received, response_size - total_received - 1, 0);
        if (bytes_received <= 0) break;
        total_received += bytes_received;
    }
    response[total_received] = '\0';
    
    close_socket(sock);
    return total_received;
}

// 发送HTTP POST请求
int http_post(const char *host, const char *path, const char *data, char *response, int response_size) {
    int sock;
    struct sockaddr_in server_addr;
    struct hostent *server;
    char request[BUFFER_SIZE];
    int bytes_received;
    
    // 创建socket
    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) {
        perror("创建socket失败");
        return -1;
    }
    
    // 解析主机名
    server = gethostbyname(host);
    if (server == NULL) {
        fprintf(stderr, "DNS解析失败: %s\n", host);
        close_socket(sock);
        return -1;
    }
    
    // 设置服务器地址
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(HTTP_PORT);
    memcpy(&server_addr.sin_addr.s_addr, server->h_addr, server->h_length);
    
    // 连接服务器
    if (connect(sock, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("连接服务器失败");
        close_socket(sock);
        return -1;
    }
    
    // 构建HTTP POST请求
    snprintf(request, sizeof(request),
        "POST %s HTTP/1.1\r\n"
        "Host: %s\r\n"
        "User-Agent: C-Tutorial/1.0\r\n"
        "Content-Type: application/json\r\n"
        "Content-Length: %d\r\n"
        "Connection: close\r\n"
        "\r\n"
        "%s",
        path, host, (int)strlen(data), data);
    
    // 发送请求
    if (send(sock, request, strlen(request), 0) < 0) {
        perror("发送请求失败");
        close_socket(sock);
        return -1;
    }
    
    // 接收响应
    int total_received = 0;
    while (total_received < response_size - 1) {
        bytes_received = recv(sock, response + total_received, response_size - total_received - 1, 0);
        if (bytes_received <= 0) break;
        total_received += bytes_received;
    }
    response[total_received] = '\0';
    
    close_socket(sock);
    return total_received;
}

// 解析HTTP响应状态码
int parse_status_code(const char *response) {
    int status_code = 0;
    if (sscanf(response, "HTTP/%*s %d", &status_code) == 1) {
        return status_code;
    }
    return -1;
}

// 提取HTTP响应体
const char *extract_body(const char *response) {
    const char *body = strstr(response, "\r\n\r\n");
    if (body) {
        return body + 4; // 跳过"\r\n\r\n"
    }
    return NULL;
}

// 演示GET请求
void demo_get() {
    printf("[1] GET请求示例\n");
    printf("----------------------------------------\n");
    
    char response[BUFFER_SIZE];
    int received = http_get("httpbin.org", "/get", response, sizeof(response));
    
    if (received > 0) {
        int status = parse_status_code(response);
        printf("状态码: %d\n", status);
        printf("响应长度: %d 字节\n", received);
        
        const char *body = extract_body(response);
        if (body) {
            printf("响应体（前200字符）:\n%.200s\n", body);
        }
    } else {
        printf("请求失败\n");
    }
    printf("\n");
}

// 演示POST请求
void demo_post() {
    printf("[2] POST请求示例\n");
    printf("----------------------------------------\n");
    
    const char *json_data = "{\"username\":\"admin\",\"password\":\"secret123\"}";
    char response[BUFFER_SIZE];
    
    int received = http_post("httpbin.org", "/post", json_data, response, sizeof(response));
    
    if (received > 0) {
        int status = parse_status_code(response);
        printf("状态码: %d\n", status);
        printf("提交的数据: %s\n", json_data);
        
        const char *body = extract_body(response);
        if (body) {
            printf("响应体（前200字符）:\n%.200s\n", body);
        }
    } else {
        printf("请求失败\n");
    }
    printf("\n");
}

// 演示错误处理
void demo_error_handling() {
    printf("[3] 错误处理示例\n");
    printf("----------------------------------------\n");
    
    char response[BUFFER_SIZE];
    
    // 测试不存在的主机
    printf("测试不存在的主机...\n");
    int received = http_get("nonexistent.example.com", "/", response, sizeof(response));
    
    if (received < 0) {
        printf("错误: 无法连接到服务器\n");
    }
    printf("\n");
}

// 与CMD curl对比
void compare_with_curl() {
    printf("[4] 与CMD curl对比\n");
    printf("----------------------------------------\n");
    
    printf("GET请求:\n");
    printf("  C语言: http_get(\"httpbin.org\", \"/get\", response, sizeof(response))\n");
    printf("  CMD:   curl https://httpbin.org/get\n\n");
    
    printf("POST请求:\n");
    printf("  C语言: http_post(\"httpbin.org\", \"/post\", data, response, sizeof(response))\n");
    printf("  CMD:   curl -X POST https://httpbin.org/post -d \"data\"\n\n");
    
    printf("设置头:\n");
    printf("  C语言: 在请求字符串中添加\"Header: value\\r\\n\"\n");
    printf("  CMD:   curl -H \"Header: value\" url\n\n");
    
    printf("错误处理:\n");
    printf("  C语言: 检查返回值和socket错误\n");
    printf("  CMD:   if errorlevel 1 echo 错误\n\n");
}

int main() {
    printf("C语言socket编程示例\n");
    printf("对比CMD curl命令\n\n");
    
    // 初始化socket库
    if (init_socket() != 0) {
        fprintf(stderr, "初始化socket库失败\n");
        return 1;
    }
    
    printf("=" .repeat(50) "\n");
    printf("HTTP请求示例\n");
    printf("=" .repeat(50) "\n\n");
    
    // 运行示例
    demo_get();
    demo_post();
    demo_error_handling();
    compare_with_curl();
    
    printf("=" .repeat(50) "\n");
    printf("示例完成\n");
    printf("=" .repeat(50) "\n");
    
    // 清理socket库
    cleanup_socket();
    
    return 0;
}