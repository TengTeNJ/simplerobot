//
//  Constants.swift
//  Runner
//
//  Created by 孟恒 on 2025/3/13.
//

import UIKit

/// 常量的定义
class Constants {
    
    enum CurrentRobotModel {
        case rest
        case training
        case remote
    }
    
    class ElectronicFence{ // 电子围栏
        static let infieldOutfieldHeight = 266 // 内外场矩形的高度
        static let infieldWidth = 78 // 内场矩形的宽度
        static let outfieldWidth = 54 // 外场矩形的宽度
    }
    
    class VirvutalMap {
        
    }
    
    static let ScreenWidth = UIScreen.main.bounds.size.width
    static let ScreenHeight = UIScreen.main.bounds.size.height
    static let Scale =  500.0 / 748.0
    
    /// 电量通知
    static let Notification_Battery = "NotificationBattery"
    /// 机器人球满通知
    static let Notification_Robot_Ball_Full = "RobotBallFullSingle"
    /// 机器人开始导航响应通知
    static let Notification_Robot_Begin_Navi = "RobotBeginNaviSingle"
    /// 机器人结束导航响应通知
    static let Notification_Robot_End_Navi = "RobotEndNaviSingle"



}
