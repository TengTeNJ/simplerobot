//
//  TimerManager.swift
//  Runner
//
//  Created by 孟恒 on 2025/6/4.
//


import Foundation

class TimerManager {
    private var timer: Timer?
    private var startTime: Date?
    private var elapsedTime: TimeInterval = 0

    // 创建并开始一个定时器
func startTimer(interval: TimeInterval, repeats: Bool, action: @escaping () -> Void) {
        stopTimer() // 停止当前定时器（如果存在）
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats) { [weak self] _ in
            guard let self = self else { return }
            self.elapsedTime += interval
            action()
        }
    }

    // 暂停定时器
    func pauseTimer() {
        guard let timer = timer else { return }
        timer.invalidate()
        self.timer = nil
        elapsedTime = -startTime!.timeIntervalSinceNow
    }

    // 继续定时器
    func resumeTimer(interval: TimeInterval, repeats: Bool, action: @escaping () -> Void) {
        stopTimer()
        startTime = Date(timeIntervalSinceNow: elapsedTime)
        startTimer(interval: interval, repeats: repeats, action: action)
    }

    // 停止并销毁定时器
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        startTime = nil
        elapsedTime = 0
    }
}

