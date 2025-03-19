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
    
    enum NavigationType {
        case electronicFenceNavi /// 电子围栏导航
        case regionalNavi /// 区域导航
        case originNavi /// 原点导航
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
    
    static let areaBgColor = UIColor(red: 27/255.0, green: 66/255.0, blue: 197/255.0, alpha: 0.75)
    static let areaBgSelectedColor = UIColor(red: 25/255.0, green: 243/255.0, blue: 134/255.0, alpha: 0.75)
    
    /// 电量通知
    static let Notification_Battery = "NotificationBattery"
    /// 机器人球满通知
    static let Notification_Robot_Ball_Full = "RobotBallFullSingle"
    /// 机器人开始导航响应通知
    static let Notification_Robot_Begin_Navi = "RobotBeginNaviSingle"
    /// 机器人结束导航响应通知
    static let Notification_Robot_End_Navi = "RobotEndNaviSingle"



}
