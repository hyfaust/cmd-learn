/**
 * comparison.js - Node.js任务调度实现对比
 * 本脚本展示Node.js中任务调度的多种实现方式
 * 包括node-cron库和内置setTimeout/setInterval
 */

const cron = require('node-cron');
const { setTimeout: sleep } = require('timers/promises');

// ============================================================
// 方法1: 使用node-cron库（推荐）
// ============================================================

function cronDemo() {
    console.log('=== node-cron库演示 ===');
    console.log('Cron表达式格式: 秒 分 时 日 月 周');
    console.log('');

    // 基础用法
    console.log('1. 基础Cron任务:');
    
    // 每分钟执行
    const task1 = cron.schedule('* * * * *', () => {
        console.log(`[${new Date().toISOString()}] 每分钟任务执行`);
    }, {
        scheduled: false // 先不启动
    });

    // 每天凌晨2点执行
    const task2 = cron.schedule('0 2 * * *', () => {
        console.log(`[${new Date().toISOString()}] 每日任务执行`);
    }, {
        scheduled: false
    });

    // 每周一到周五上午9点执行
    const task3 = cron.schedule('0 9 * * 1-5', () => {
        console.log(`[${new Date().toISOString()}] 工作日任务执行`);
    }, {
        scheduled: false
    });

    // 每月1号和15号执行
    const task4 = cron.schedule('0 10 1,15 * *', () => {
        console.log(`[${new Date().toISOString()}] 每月任务执行`);
    }, {
        scheduled: false
    });

    // 每5秒执行（用于演示）
    const demoTask = cron.schedule('*/5 * * * * *', () => {
        console.log(`[${new Date().toISOString()}] 演示任务（每5秒）`);
    }, {
        scheduled: false
    });

    return { task1, task2, task3, task4, demoTask };
}

// ============================================================
// 方法2: 使用setInterval（内置）
// ============================================================

function intervalDemo() {
    console.log('\n=== setInterval演示 ===');
    
    let count = 0;
    
    // 每秒执行
    const interval1 = setInterval(() => {
        count++;
        console.log(`[${new Date().toISOString()}] setInterval任务 #${count}`);
        
        if (count >= 5) {
            clearInterval(interval1);
            console.log('setInterval任务完成');
        }
    }, 1000);
    
    return interval1;
}

// ============================================================
// 方法3: 使用setTimeout（内置）
// ============================================================

function timeoutDemo() {
    console.log('\n=== setTimeout演示 ===');
    
    // 延迟执行
    setTimeout(() => {
        console.log(`[${new Date().toISOString()}] setTimeout任务执行（延迟2秒）`);
    }, 2000);
    
    // 链式延迟
    setTimeout(() => {
        console.log(`[${new Date().toISOString()}] 第一个延迟任务`);
        
        setTimeout(() => {
            console.log(`[${new Date().toISOString()}] 第二个延迟任务`);
            
            setTimeout(() => {
                console.log(`[${new Date().toISOString()}] 第三个延迟任务`);
            }, 1000);
        }, 1000);
    }, 1000);
}

// ============================================================
// 方法4: 使用Promise和async/await
// ============================================================

async function asyncDemo() {
    console.log('\n=== async/await演示 ===');
    
    // 异步延迟函数
    const delay = (ms) => new Promise(resolve => setTimeout(resolve, ms));
    
    // 异步任务
    async function asyncTask(name, delayMs) {
        console.log(`开始任务: ${name}`);
        await delay(delayMs);
        console.log(`完成任务: ${name} (延迟 ${delayMs}ms)`);
    }
    
    // 串行执行
    await asyncTask('任务A', 1000);
    await asyncTask('任务B', 1500);
    await asyncTask('任务C', 800);
    
    // 并行执行
    console.log('\n并行执行任务...');
    await Promise.all([
        asyncTask('并行任务1', 1000),
        asyncTask('并行任务2', 1200),
        asyncTask('并行任务3', 800)
    ]);
    
    console.log('所有并行任务完成');
}

// ============================================================
// 实用工具类
// ============================================================

class TaskScheduler {
    constructor() {
        this.tasks = new Map();
        this.running = false;
    }
    
    // 添加任务
    addTask(name, func, intervalMs) {
        if (this.tasks.has(name)) {
            throw new Error(`任务 ${name} 已存在`);
        }
        
        this.tasks.set(name, {
            func,
            interval: intervalMs,
            lastRun: 0,
            runCount: 0,
            errors: []
        });
        
        console.log(`已添加任务: ${name} (间隔: ${intervalMs}ms)`);
        return this;
    }
    
    // 启动调度器
    start(durationMs = null) {
        this.running = true;
        const startTime = Date.now();
        
        console.log('调度器开始运行...');
        if (durationMs) {
            console.log(`运行时长: ${durationMs}ms`);
        }
        
        // 主循环
        const runLoop = () => {
            if (!this.running) return;
            
            const now = Date.now();
            
            // 检查是否超过运行时间
            if (durationMs && (now - startTime) >= durationMs) {
                this.stop();
                return;
            }
            
            // 执行任务
            for (const [name, task] of this.tasks) {
                if (now - task.lastRun >= task.interval) {
                    try {
                        task.func();
                        task.lastRun = now;
                        task.runCount++;
                    } catch (error) {
                        task.errors.push({
                            time: now,
                            error: error.message
                        });
                        console.error(`任务 ${name} 执行失败:`, error.message);
                    }
                }
            }
            
            // 继续循环
            setTimeout(runLoop, 10); // 10ms检查间隔
        };
        
        runLoop();
    }
    
    // 停止调度器
    stop() {
        this.running = false;
        console.log('调度器已停止');
    }
    
    // 获取统计信息
    getStats() {
        console.log('\n任务统计:');
        for (const [name, task] of this.tasks) {
            console.log(`  - ${name}: 执行次数 ${task.runCount}, 错误 ${task.errors.length}`);
        }
    }
}

// ============================================================
// 与CMD对比分析
// ============================================================

function comparisonAnalysis() {
    console.log('\n=== Node.js vs CMD 任务调度对比 ===');
    
    const comparison = {
        '持久化': {
            'CMD': '系统级持久化（任务计划程序）',
            'Node.js': '内存级（需额外存储）'
        },
        '精确度': {
            'CMD': '分钟级',
            'Node.js': '秒级甚至毫秒级'
        },
        '异步支持': {
            'CMD': '无',
            'Node.js': '完整异步支持'
        },
        '复杂调度': {
            'CMD': '基本（每日、每周等）',
            'Node.js': '强大（Cron表达式、复杂条件）'
        },
        '错误处理': {
            'CMD': '有限',
            'Node.js': '完整（Promise、async/await）'
        },
        '跨平台': {
            'CMD': '仅Windows',
            'Node.js': '跨平台'
        },
        '依赖': {
            'CMD': '无',
            'Node.js': '需要Node.js环境'
        }
    };
    
    for (const [feature, details] of Object.entries(comparison)) {
        console.log(`\n${feature}:`);
        for (const [lang, description] of Object.entries(details)) {
            console.log(`  ${lang}: ${description}`);
        }
    }
}

// ============================================================
// 主程序
// ============================================================

async function main() {
    console.log('Node.js任务调度实现对比');
    console.log('='.repeat(50));
    
    // 显示对比分析
    comparisonAnalysis();
    
    console.log('\n' + '='.repeat(50));
    console.log('开始运行演示（按Ctrl+C停止）');
    console.log('='.repeat(50));
    
    try {
        // 方法1: node-cron
        const cronTasks = cronDemo();
        
        // 启动演示任务（每5秒执行）
        cronTasks.demoTask.start();
        console.log('node-cron演示任务已启动（每5秒执行）');
        
        // 等待一段时间
        await sleep(15000);
        
        // 停止任务
        cronTasks.demoTask.stop();
        console.log('node-cron演示任务已停止');
        
        // 方法2: setInterval
        intervalDemo();
        
        // 等待间隔任务完成
        await sleep(6000);
        
        // 方法3: setTimeout
        timeoutDemo();
        
        // 等待超时任务完成
        await sleep(5000);
        
        // 方法4: async/await
        await asyncDemo();
        
        // 自定义调度器演示
        console.log('\n=== 自定义调度器演示 ===');
        const customScheduler = new TaskScheduler();
        
        customScheduler
            .addTask('任务A', () => {
                console.log(`[${new Date().toISOString()}] 任务A执行`);
            }, 1000)
            .addTask('任务B', () => {
                console.log(`[${new Date().toISOString()}] 任务B执行`);
            }, 2000)
            .addTask('任务C', () => {
                console.log(`[${new Date().toISOString()}] 任务C执行`);
            }, 3000);
        
        customScheduler.start(10000); // 运行10秒
        customScheduler.getStats();
        
    } catch (error) {
        console.error('演示过程中发生错误:', error);
    }
    
    console.log('\n' + '='.repeat(50));
    console.log('演示完成！');
    console.log('='.repeat(50));
    
    // 退出程序
    process.exit(0);
}

// 运行主程序
main().catch(console.error);