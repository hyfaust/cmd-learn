"""
comparison.py - Python requests库示例
功能：演示使用Python requests库进行HTTP请求
对比：与CMD curl命令的对比

注意：需要安装requests库: pip install requests
"""

import requests
import json
from datetime import datetime

def main():
    print("=" * 50)
    print("Python requests库示例")
    print("=" * 50)
    print()
    
    # 1. GET请求
    print("[1] GET请求示例")
    print("-" * 30)
    
    # 基本GET请求
    response = requests.get('https://httpbin.org/get')
    print(f"状态码: {response.status_code}")
    print(f"响应头: {response.headers['Content-Type']}")
    print(f"响应内容: {response.text[:200]}...")
    print()
    
    # 带参数的GET请求
    params = {
        'name': 'test',
        'value': '123'
    }
    response = requests.get('https://httpbin.org/get', params=params)
    print(f"带参数的URL: {response.url}")
    print(f"状态码: {response.status_code}")
    print()
    
    # 2. POST请求
    print("[2] POST请求示例")
    print("-" * 30)
    
    # JSON数据POST
    data = {
        'username': 'admin',
        'password': 'secret123',
        'email': 'admin@example.com'
    }
    
    response = requests.post('https://httpbin.org/post', json=data)
    print(f"JSON POST状态码: {response.status_code}")
    print(f"响应JSON: {response.json()}")
    print()
    
    # 表单数据POST
    form_data = {
        'username': 'admin',
        'password': 'secret123'
    }
    
    response = requests.post('https://httpbin.org/post', data=form_data)
    print(f"表单POST状态码: {response.status_code}")
    print()
    
    # 3. 设置请求头
    print("[3] 设置请求头示例")
    print("-" * 30)
    
    headers = {
        'User-Agent': 'Python-Tutorial/1.0',
        'Accept': 'application/json',
        'Authorization': 'Bearer test_token_12345'
    }
    
    response = requests.get('https://httpbin.org/get', headers=headers)
    print(f"状态码: {response.status_code}")
    print(f"请求头已设置: User-Agent, Accept, Authorization")
    print()
    
    # 4. 文件下载
    print("[4] 文件下载示例")
    print("-" * 30)
    
    # 下载文件
    response = requests.get('https://httpbin.org/bytes/1024')
    with open('downloaded_file.bin', 'wb') as f:
        f.write(response.content)
    
    print(f"文件大小: {len(response.content)} 字节")
    print(f"已保存到: downloaded_file.bin")
    print()
    
    # 5. 错误处理
    print("[5] 错误处理示例")
    print("-" * 30)
    
    try:
        # 测试不存在的URL
        response = requests.get('https://nonexistent.example.com', timeout=5)
    except requests.exceptions.ConnectionError:
        print("连接错误: 无法连接到服务器")
    except requests.exceptions.Timeout:
        print("超时错误: 连接超时")
    except requests.exceptions.RequestException as e:
        print(f"请求错误: {e}")
    print()
    
    # 6. 会话保持
    print("[6] 会话保持示例")
    print("-" * 30)
    
    with requests.Session() as session:
        # 设置默认头
        session.headers.update({
            'User-Agent': 'Python-Session/1.0'
        })
        
        # 第一个请求
        response1 = session.get('https://httpbin.org/get')
        print(f"第一个请求状态码: {response1.status_code}")
        
        # 第二个请求（保持会话）
        response2 = session.get('https://httpbin.org/cookies/set/session_id/abc123')
        print(f"第二个请求状态码: {response2.status_code}")
        
        # 第三个请求（获取cookies）
        response3 = session.get('https://httpbin.org/cookies')
        print(f"Cookies: {response3.json()}")
    print()
    
    # 7. 响应处理
    print("[7] 响应处理示例")
    print("-" * 30)
    
    response = requests.get('https://httpbin.org/get')
    
    print(f"状态码: {response.status_code}")
    print(f"是否成功: {response.ok}")
    print(f"编码: {response.encoding}")
    print(f"内容类型: {response.headers['Content-Type']}")
    
    # JSON响应
    if response.headers['Content-Type'] == 'application/json':
        json_data = response.json()
        print(f"JSON数据: {json_data}")
    print()
    
    # 8. 超时设置
    print("[8] 超时设置示例")
    print("-" * 30)
    
    try:
        # 设置超时时间为3秒
        response = requests.get('https://httpbin.org/delay/1', timeout=3)
        print(f"请求成功，状态码: {response.status_code}")
    except requests.exceptions.Timeout:
        print("请求超时")
    print()
    
    # 9. 批量请求
    print("[9] 批量请求示例")
    print("-" * 30)
    
    urls = [
        'https://httpbin.org/get',
        'https://httpbin.org/ip',
        'https://httpbin.org/user-agent'
    ]
    
    results = []
    for url in urls:
        response = requests.get(url)
        results.append({
            'url': url,
            'status': response.status_code,
            'size': len(response.content)
        })
    
    for result in results:
        print(f"URL: {result['url']}")
        print(f"  状态: {result['status']}, 大小: {result['size']} 字节")
    print()
    
    # 10. 与CMD curl对比
    print("[10] 与CMD curl对比")
    print("-" * 30)
    
    print("Python requests vs CMD curl:")
    print()
    print("GET请求:")
    print("  Python: requests.get('https://httpbin.org/get')")
    print("  CMD:    curl https://httpbin.org/get")
    print()
    print("POST请求:")
    print("  Python: requests.post('https://httpbin.org/post', json=data)")
    print("  CMD:    curl -X POST https://httpbin.org/post -H \"Content-Type: application/json\" -d \"{}\"")
    print()
    print("设置头:")
    print("  Python: requests.get(url, headers={'User-Agent': 'test'})")
    print("  CMD:    curl -H \"User-Agent: test\" url")
    print()
    print("超时:")
    print("  Python: requests.get(url, timeout=5)")
    print("  CMD:    curl --connect-timeout 5 url")
    print()
    
    print("=" * 50)
    print("示例完成")
    print("=" * 50)

if __name__ == "__main__":
    main()