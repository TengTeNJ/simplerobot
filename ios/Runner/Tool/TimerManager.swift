//
//  TimerManager.swift
//  Runner
//
//  Created by 孟恒 on 2025/6/4.
//


import Foundation

class TimerManager {
    // 定义一个 Timer 属性
    private var timer: Timer?
    
    // 定义一个闭包，用于定时器触发时执行的任务
    private var timerTask: (() -> Void)?
    
    // 初始化方法
    init() {}
    
    // 启动定时器
    func startTimer(interval: TimeInterval, task: @escaping () -> Void) {
        // 保存任务闭包
        self.timerTask = task
        
        // 创建并启动定时器
        self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.timerTask?()
        }
    }
    
    // 停止定时器
    func stopTimer() {
        // 无效化定时器
        timer?.invalidate()
        timer = nil
    }
    
    // 销毁定时器管理器时，确保停止定时器
    deinit {
        stopTimer()
    }
}
