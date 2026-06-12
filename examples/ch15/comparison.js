/**
 * Node.js安全编程对比示例
 * 
 * 本文件展示Node.js中的安全编程实践，包括：
 * 1. 输入验证和消毒
 * 2. 路径遍历防护
 * 3. 安全文件操作
 * 4. 敏感信息处理
 * 5. 日志记录
 * 6. 哈希计算
 */

const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const os = require('os');

/**
 * 安全验证器类
 */
class SecurityValidator {
    // 危险字符正则表达式
    static DANGEROUS_CHARS = /[\\/:*?"<>|&;`$]/;
    
    // 危险模式正则表达式
    static DANGEROUS_PATTERNS = [
        /\.\./,  // 路径遍历
        /[&|<>^]/,  // 命令注入
        /[;]/,  // 命令分隔符
    ];
    
    /**
     * 验证用户输入是否安全
     * @param {string} userInput - 用户输入
     * @returns {boolean} 是否安全
     */
    static validateInput(userInput) {
        // 检查空输入
        if (!userInput || !userInput.trim()) {
            return false;
        }
        
        // 检查危险字符
        if (SecurityValidator.DANGEROUS_CHARS.test(userInput)) {
            return false;
        }
        
        // 检查危险模式
        for (const pattern of SecurityValidator.DANGEROUS_PATTERNS) {
            if (pattern.test(userInput)) {
                return false;
            }
        }
        
        return true;
    }
    
    /**
     * 验证文件名是否安全
     * @param {string} filename - 文件名
     * @returns {boolean} 是否安全
     */
    static validateFilename(filename) {
        // 检查空文件名
        if (!filename || !filename.trim()) {
            return false;
        }
        
        // 检查非法字符
        if (/[\\/:*?"<>|]/.test(filename)) {
            return false;
        }
        
        // 检查长度
        if (filename.length > 255) {
            return false;
        }
        
        return true;
    }
    
    /**
     * 验证路径是否安全
     * @param {string} pathInput - 路径
     * @returns {boolean} 是否安全
     */
    static validatePath(pathInput) {
        // 检查空路径
        if (!pathInput || !pathInput.trim()) {
            return false;
        }
        
        // 检查路径遍历
        if (pathInput.includes('..')) {
            return false;
        }
        
        // 检查危险字符
        if (/[&|<>^]/.test(pathInput)) {
            return false;
        }
        
        return true;
    }
}

/**
 * 安全路径处理器类
 */
class SafePathHandler {
    /**
     * 构造函数
     * @param {string} baseDir - 基础目录
     */
    constructor(baseDir) {
        this.baseDir = path.resolve(baseDir);
        
        // 确保基础目录存在
        if (!fs.existsSync(this.baseDir)) {
            fs.mkdirSync(this.baseDir, { recursive: true });
        }
    }
    
    /**
     * 安全地连接路径
     * @param {string} userPath - 用户提供的路径
     * @returns {string|null} 安全路径，如果不安全则返回null
     */
    safeJoin(userPath) {
        try {
            // 构建完整路径
            const fullPath = path.resolve(this.baseDir, userPath);
            
            // 验证路径是否在基础目录内
            if (!fullPath.startsWith(this.baseDir)) {
                return null;
            }
            
            return fullPath;
        } catch (error) {
            return null;
        }
    }
    
    /**
     * 安全地读取文件
     * @param {string} filename - 文件名
     * @returns {string|null} 文件内容，如果不安全则返回null
     */
    safeRead(filename) {
        // 验证路径
        const filePath = this.safeJoin(filename);
        if (filePath === null) {
            return null;
        }
        
        // 检查文件是否存在
        if (!fs.existsSync(filePath)) {
            return null;
        }
        
        try {
            return fs.readFileSync(filePath, 'utf-8');
        } catch (error) {
            return null;
        }
    }
    
    /**
     * 安全地写入文件
     * @param {string} filename - 文件名
     * @param {string} content - 文件内容
     * @returns {boolean} 是否成功
     */
    safeWrite(filename, content) {
        // 验证路径
        const filePath = this.safeJoin(filename);
        if (filePath === null) {
            return false;
        }
        
        try {
            fs.writeFileSync(filePath, content, 'utf-8');
            return true;
        } catch (error) {
            return false;
        }
    }
}

/**
 * 安全哈希计算器类
 */
class SecureHasher {
    /**
     * 计算文件的MD5哈希值
     * @param {string} filePath - 文件路径
     * @returns {string|null} MD5哈希值，如果失败则返回null
     */
    static calculateMD5(filePath) {
        try {
            const fileBuffer = fs.readFileSync(filePath);
            const hashSum = crypto.createHash('md5');
            hashSum.update(fileBuffer);
            return hashSum.digest('hex');
        } catch (error) {
            return null;
        }
    }
    
    /**
     * 计算文件的SHA256哈希值
     * @param {string} filePath - 文件路径
     * @returns {string|null} SHA256哈希值，如果失败则返回null
     */
    static calculateSHA256(filePath) {
        try {
            const fileBuffer = fs.readFileSync(filePath);
            const hashSum = crypto.createHash('sha256');
            hashSum.update(fileBuffer);
            return hashSum.digest('hex');
        } catch (error) {
            return null;
        }
    }
    
    /**
     * 安全地哈希密码
     * @param {string} password - 密码
     * @param {Buffer|null} salt - 盐值（可选）
     * @returns {Object} 包含盐和哈希值的对象
     */
    static hashPassword(password, salt = null) {
        // 生成随机盐
        if (salt === null) {
            salt = crypto.randomBytes(32);
        }
        
        // 使用PBKDF2进行密码哈希
        const hash = crypto.pbkdf2Sync(
            password,
            salt,
            100000, // 迭代次数
            64,     // 输出长度
            'sha512'
        );
        
        return {
            salt: salt.toString('hex'),
            hash: hash.toString('hex')
        };
    }
}

/**
 * 审计日志记录器类
 */
class AuditLogger {
    /**
     * 构造函数
     * @param {string} logDir - 日志目录
     */
    constructor(logDir) {
        this.logDir = logDir;
        
        // 确保日志目录存在
        if (!fs.existsSync(this.logDir)) {
            fs.mkdirSync(this.logDir, { recursive: true });
        }
        
        // 设置日志文件
        this.logFile = path.join(this.logDir, 'audit.log');
    }
    
    /**
     * 记录审计事件
     * @param {string} eventType - 事件类型
     * @param {string} message - 事件消息
     * @param {string|null} user - 用户名（可选）
     */
    logEvent(eventType, message, user = null) {
        if (user === null) {
            user = os.userInfo().username;
        }
        
        const timestamp = new Date().toISOString();
        const logMessage = `[${timestamp}] [${eventType}] User: ${user} - ${message}\n`;
        
        fs.appendFileSync(this.logFile, logMessage, 'utf-8');
    }
    
    /**
     * 记录安全事件
     * @param {string} eventType - 事件类型
     * @param {string} message - 事件消息
     */
    logSecurityEvent(eventType, message) {
        this.logEvent(`SECURITY_${eventType}`, message);
    }
    
    /**
     * 记录错误事件
     * @param {string} errorCode - 错误代码
     * @param {string} message - 错误消息
     */
    logError(errorCode, message) {
        const timestamp = new Date().toISOString();
        const logMessage = `[${timestamp}] [ERROR] Code: ${errorCode} - ${message}\n`;
        
        fs.appendFileSync(this.logFile, logMessage, 'utf-8');
    }
}

/**
 * 输入消毒器类
 */
class InputSanitizer {
    /**
     * 消毒文件名
     * @param {string} filename - 原始文件名
     * @returns {string} 消毒后的文件名
     */
    static sanitizeFilename(filename) {
        // 移除危险字符
        let sanitized = filename.replace(/[\\/:*?"<>|]/g, '');
        
        // 移除首尾空格
        sanitized = sanitized.trim();
        
        // 限制长度
        if (sanitized.length > 255) {
            sanitized = sanitized.substring(0, 255);
        }
        
        return sanitized;
    }
    
    /**
     * 消毒用户输入
     * @param {string} userInput - 原始输入
     * @returns {string} 消毒后的输入
     */
    static sanitizeInput(userInput) {
        // 移除危险字符
        let sanitized = userInput.replace(/[&|<>^;]/g, '');
        
        // 移除路径遍历
        sanitized = sanitized.replace(/\.\./g, '');
        
        // 移除首尾空格
        sanitized = sanitized.trim();
        
        return sanitized;
    }
    
    /**
     * 转义命令行参数
     * @param {string} arg - 原始参数
     * @returns {string} 转义后的参数
     */
    static escapeCommandArg(arg) {
        // 使用引号包裹
        if (arg.includes(' ') || /[&|<>^]/.test(arg)) {
            return `"${arg}"`;
        }
        return arg;
    }
}

/**
 * 演示输入验证
 */
function demonstrateInputValidation() {
    console.log("=" .repeat(60));
    console.log("输入验证演示");
    console.log("=" .repeat(60));
    
    const validator = SecurityValidator;
    
    // 测试用例
    const testCases = [
        { input: "", expected: false, description: "空输入" },
        { input: "hello_world", expected: true, description: "正常输入" },
        { input: "file.txt & del /f /q C:\\*.*", expected: false, description: "命令注入攻击" },
        { input: "..\\..\\..\\Windows\\System32\\config\\SAM", expected: false, description: "路径遍历攻击" },
        { input: "file:name.txt", expected: false, description: "包含非法字符" },
        { input: "normal_file.txt", expected: true, description: "正常文件名" },
    ];
    
    testCases.forEach(({ input, expected, description }) => {
        const result = validator.validateInput(input);
        const status = result === expected ? "PASS" : "FAIL";
        console.log(`[${status}] ${description}: '${input}' -> ${result}`);
    });
}

/**
 * 演示路径安全
 */
function demonstratePathSecurity() {
    console.log("\n" + "=" .repeat(60));
    console.log("路径安全演示");
    console.log("=" .repeat(60));
    
    // 创建临时目录
    const tempDir = path.join(__dirname, 'temp_security_test');
    if (!fs.existsSync(tempDir)) {
        fs.mkdirSync(tempDir);
    }
    
    try {
        const handler = new SafePathHandler(tempDir);
        
        // 测试安全路径
        const testPaths = [
            { input: "file.txt", expected: true, description: "正常文件" },
            { input: "..\\..\\secret.txt", expected: false, description: "路径遍历攻击" },
            { input: "C:\\Windows\\System32\\cmd.exe", expected: false, description: "绝对路径" },
            { input: "subdir\\file.txt", expected: true, description: "子目录文件" },
        ];
        
        testPaths.forEach(({ input, expected, description }) => {
            const result = handler.safeJoin(input);
            const isSafe = result !== null;
            const status = isSafe === expected ? "PASS" : "FAIL";
            console.log(`[${status}] ${description}: '${input}' -> ${isSafe ? '安全' : '不安全'}`);
        });
    } finally {
        // 清理临时目录
        fs.rmSync(tempDir, { recursive: true, force: true });
    }
}

/**
 * 演示哈希计算
 */
function demonstrateHashing() {
    console.log("\n" + "=" .repeat(60));
    console.log("哈希计算演示");
    console.log("=" .repeat(60));
    
    const hasher = SecureHasher;
    
    // 创建测试文件
    const testFile = path.join(__dirname, 'test_hash.txt');
    fs.writeFileSync(testFile, 'Hello, World!', 'utf-8');
    
    try {
        // 计算哈希
        const md5Hash = hasher.calculateMD5(testFile);
        const sha256Hash = hasher.calculateSHA256(testFile);
        
        console.log(`文件: ${testFile}`);
        console.log(`MD5: ${md5Hash}`);
        console.log(`SHA256: ${sha256Hash}`);
        
        // 测试密码哈希
        const password = "secure_password";
        const { salt, hash } = hasher.hashPassword(password);
        
        console.log(`\n密码哈希:`);
        console.log(`盐值: ${salt.substring(0, 16)}...`);
        console.log(`哈希: ${hash.substring(0, 16)}...`);
    } finally {
        // 清理测试文件
        fs.unlinkSync(testFile);
    }
}

/**
 * 演示日志记录
 */
function demonstrateLogging() {
    console.log("\n" + "=" .repeat(60));
    console.log("日志记录演示");
    console.log("=" .repeat(60));
    
    // 创建临时日志目录
    const logDir = path.join(__dirname, 'temp_logs');
    
    try {
        const logger = new AuditLogger(logDir);
        
        // 记录各种事件
        logger.logEvent('INFO', '用户登录系统');
        logger.logSecurityEvent('LOGIN_SUCCESS', '登录成功');
        logger.logError('FILE_NOT_FOUND', '找不到文件: test.txt');
        
        console.log("日志记录完成");
        console.log(`日志目录: ${logDir}`);
        
        // 显示日志内容
        const logFile = path.join(logDir, 'audit.log');
        if (fs.existsSync(logFile)) {
            console.log("\n日志内容:");
            console.log(fs.readFileSync(logFile, 'utf-8'));
        }
    } finally {
        // 清理临时日志目录
        fs.rmSync(logDir, { recursive: true, force: true });
    }
}

/**
 * 演示输入消毒
 */
function demonstrateSanitization() {
    console.log("\n" + "=" .repeat(60));
    console.log("输入消毒演示");
    console.log("=" .repeat(60));
    
    const sanitizer = InputSanitizer;
    
    // 测试用例
    const testCases = [
        { input: "file:name.txt", description: "文件名消毒" },
        { input: "  hello world  ", description: "空格处理" },
        { input: "file.txt & command", description: "命令注入消毒" },
        { input: "..\\..\\path", description: "路径遍历消毒" },
    ];
    
    testCases.forEach(({ input, description }) => {
        const sanitized = sanitizer.sanitizeInput(input);
        console.log(`${description}:`);
        console.log(`  输入: '${input}'`);
        console.log(`  输出: '${sanitized}'`);
        console.log('');
    });
}

/**
 * 主函数
 */
function main() {
    console.log("Node.js安全编程对比示例");
    console.log("=" .repeat(60));
    
    try {
        demonstrateInputValidation();
        demonstratePathSecurity();
        demonstrateHashing();
        demonstrateLogging();
        demonstrateSanitization();
        
        console.log("\n" + "=" .repeat(60));
        console.log("所有演示完成");
        console.log("=" .repeat(60));
    } catch (error) {
        console.error(`错误: ${error.message}`);
        console.error(error.stack);
    }
}

// 运行主函数
if (require.main === module) {
    main();
}

module.exports = {
    SecurityValidator,
    SafePathHandler,
    SecureHasher,
    AuditLogger,
    InputSanitizer
};