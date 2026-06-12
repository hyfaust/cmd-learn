/**
 * C语言 文件操作对比示例
 * 功能：演示C语言中与CMD等效的文件系统操作
 * 使用头文件：stdio.h, stdlib.h, direct.h, io.h, sys/stat.h
 * 编译：gcc comparison.c -o comparison.exe
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <direct.h>    // Windows目录操作
#include <io.h>        // Windows文件操作
#include <sys/stat.h>  // 文件状态
#include <time.h>

// 路径分隔符
#define PATH_SEP "\\"
#define MAX_PATH_LEN 260

// 辅助函数：创建目录（递归）
int mkdir_recursive(const char *path) {
    char tmp[MAX_PATH_LEN];
    char *p = NULL;
    size_t len;
    
    snprintf(tmp, sizeof(tmp), "%s", path);
    len = strlen(tmp);
    if (tmp[len - 1] == PATH_SEP[0]) {
        tmp[len - 1] = 0;
    }
    
    for (p = tmp + 1; *p; p++) {
        if (*p == PATH_SEP[0]) {
            *p = 0;
            _mkdir(tmp);
            *p = PATH_SEP[0];
        }
    }
    return _mkdir(tmp);
}

// 辅助函数：删除目录（递归）
int rmdir_recursive(const char *path) {
    struct _finddata_t fileinfo;
    intptr_t handle;
    char pattern[MAX_PATH_LEN];
    char fullpath[MAX_PATH_LEN];
    
    snprintf(pattern, sizeof(pattern), "%s\\*", path);
    handle = _findfirst(pattern, &fileinfo);
    
    if (handle == -1) {
        return _rmdir(path);
    }
    
    do {
        if (strcmp(fileinfo.name, ".") == 0 || strcmp(fileinfo.name, "..") == 0) {
            continue;
        }
        
        snprintf(fullpath, sizeof(fullpath), "%s\\%s", path, fileinfo.name);
        
        if (fileinfo.attrib & _A_SUBDIR) {
            rmdir_recursive(fullpath);
        } else {
            _chmod(fullpath, _S_IREAD | _S_IWRITE);
            remove(fullpath);
        }
    } while (_findnext(handle, &fileinfo) == 0);
    
    _findclose(handle);
    return _rmdir(path);
}

// 辅助函数：复制文件
int copy_file(const char *src, const char *dst) {
    FILE *fin, *fout;
    char buffer[4096];
    size_t bytes;
    
    fin = fopen(src, "rb");
    if (!fin) {
        perror("打开源文件失败");
        return -1;
    }
    
    fout = fopen(dst, "wb");
    if (!fout) {
        fclose(fin);
        perror("创建目标文件失败");
        return -1;
    }
    
    while ((bytes = fread(buffer, 1, sizeof(buffer), fin)) > 0) {
        fwrite(buffer, 1, bytes, fout);
    }
    
    fclose(fin);
    fclose(fout);
    return 0;
}

int main() {
    // 设置基准目录
    char base_dir[MAX_PATH_LEN];
    char temp_path[MAX_PATH_LEN];
    
    // 获取脚本所在目录（简化版本，实际应用中需要更复杂的处理）
    snprintf(base_dir, sizeof(base_dir), ".\\sandbox");
    
    // 清理可能存在的旧sandbox
    rmdir_recursive(base_dir);
    
    printf("==================================================\n");
    printf("C语言 文件操作对比示例\n");
    printf("==================================================\n");
    printf("\n");
    
    // 创建目录结构
    printf("[1] 创建目录结构\n");
    // CMD: mkdir dir
    mkdir_recursive(base_dir);
    snprintf(temp_path, sizeof(temp_path), "%s\\sub1", base_dir);
    mkdir_recursive(temp_path);
    snprintf(temp_path, sizeof(temp_path), "%s\\sub2", base_dir);
    mkdir_recursive(temp_path);
    snprintf(temp_path, sizeof(temp_path), "%s\\sub1\\deep", base_dir);
    mkdir_recursive(temp_path);
    printf("创建完成\n");
    printf("\n");
    
    // 创建测试文件
    printf("[2] 创建测试文件\n");
    // CMD: echo content > file.txt
    FILE *f;
    snprintf(temp_path, sizeof(temp_path), "%s\\test1.txt", base_dir);
    f = fopen(temp_path, "w");
    if (f) {
        fprintf(f, "这是第一个测试文件\n");
        fclose(f);
    }
    
    snprintf(temp_path, sizeof(temp_path), "%s\\test2.txt", base_dir);
    f = fopen(temp_path, "w");
    if (f) {
        fprintf(f, "这是第二个测试文件\n");
        fclose(f);
    }
    
    snprintf(temp_path, sizeof(temp_path), "%s\\test3.txt", base_dir);
    f = fopen(temp_path, "w");
    if (f) {
        fprintf(f, "Hello World\n");
        fclose(f);
    }
    printf("创建完成\n");
    printf("\n");
    
    // 复制文件
    printf("[3] 复制文件\n");
    // CMD: copy src dst
    snprintf(temp_path, sizeof(temp_path), "%s\\test1_backup.txt", base_dir);
    char src_path[MAX_PATH_LEN];
    snprintf(src_path, sizeof(src_path), "%s\\test1.txt", base_dir);
    copy_file(src_path, temp_path);
    printf("复制: test1.txt -> test1_backup.txt\n");
    
    // 批量复制到backup目录
    char backup_dir[MAX_PATH_LEN];
    snprintf(backup_dir, sizeof(backup_dir), "%s\\backup", base_dir);
    mkdir_recursive(backup_dir);
    
    struct _finddata_t fileinfo;
    intptr_t handle;
    char pattern[MAX_PATH_LEN];
    snprintf(pattern, sizeof(pattern), "%s\\*.txt", base_dir);
    handle = _findfirst(pattern, &fileinfo);
    
    if (handle != -1) {
        do {
            char src[MAX_PATH_LEN], dst[MAX_PATH_LEN];
            snprintf(src, sizeof(src), "%s\\%s", base_dir, fileinfo.name);
            snprintf(dst, sizeof(dst), "%s\\%s", backup_dir, fileinfo.name);
            copy_file(src, dst);
        } while (_findnext(handle, &fileinfo) == 0);
        _findclose(handle);
    }
    printf("批量复制完成\n");
    printf("\n");
    
    // 移动文件（C语言没有直接的move，需要复制后删除）
    printf("[4] 移动文件\n");
    // CMD: move src dst
    char dst_path[MAX_PATH_LEN];
    snprintf(src_path, sizeof(src_path), "%s\\test2.txt", base_dir);
    snprintf(dst_path, sizeof(dst_path), "%s\\sub1\\test2.txt", base_dir);
    if (copy_file(src_path, dst_path) == 0) {
        remove(src_path);
        printf("移动: test2.txt -> sub1/test2.txt\n");
    }
    printf("\n");
    
    // 重命名文件
    printf("[5] 重命名文件\n");
    // CMD: ren old new
    snprintf(src_path, sizeof(src_path), "%s\\test3.txt", base_dir);
    snprintf(dst_path, sizeof(dst_path), "%s\\test3_renamed.txt", base_dir);
    rename(src_path, dst_path);
    printf("重命名: test3.txt -> test3_renamed.txt\n");
    printf("\n");
    
    // 读取文件内容
    printf("[6] 读取文件内容\n");
    // CMD: type file.txt
    snprintf(temp_path, sizeof(temp_path), "%s\\test1.txt", base_dir);
    f = fopen(temp_path, "r");
    if (f) {
        char line[256];
        printf("test1.txt 内容: ");
        while (fgets(line, sizeof(line), f)) {
            printf("%s", line);
        }
        fclose(f);
    }
    printf("\n");
    
    // 文件属性操作
    printf("[7] 文件属性操作\n");
    snprintf(temp_path, sizeof(temp_path), "%s\\test1.txt", base_dir);
    struct _stat file_stat;
    if (_stat(temp_path, &file_stat) == 0) {
        printf("文件大小: %ld 字节\n", file_stat.st_size);
        printf("修改时间: %s", ctime(&file_stat.st_mtime));
    }
    
    // 设置只读属性
    // CMD: attrib +R file.txt
    _chmod(temp_path, _S_IREAD);
    printf("设置只读属性完成\n");
    printf("\n");
    
    // 遍历目录
    printf("[8] 遍历目录\n");
    // CMD: for /R %dir% %%f in (*.txt) do echo %%f
    snprintf(pattern, sizeof(pattern), "%s\\*.txt", base_dir);
    handle = _findfirst(pattern, &fileinfo);
    
    if (handle != -1) {
        printf("所有.txt文件:\n");
        do {
            printf("  %s\n", fileinfo.name);
        } while (_findnext(handle, &fileinfo) == 0);
        _findclose(handle);
    }
    printf("\n");
    
    // 删除文件
    printf("[9] 删除文件\n");
    // CMD: del file.txt
    snprintf(temp_path, sizeof(temp_path), "%s\\test1_backup.txt", base_dir);
    _chmod(temp_path, _S_IREAD | _S_IWRITE);  // 确保可写
    remove(temp_path);
    printf("删除: test1_backup.txt\n");
    printf("\n");
    
    // 清理sandbox目录
    printf("[10] 清理sandbox目录\n");
    // CMD: rmdir /s /q sandbox
    rmdir_recursive(base_dir);
    printf("清理完成\n");
    
    printf("\n");
    printf("演示结束\n");
    
    return 0;
}