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
    
    /// 原点区域
    enum OriginViewType {
       case originViewLeftTop /// 左上角
       case originViewRightTop /// 右上角
       case originViewRightBottom /// 右下角
    }
    
    class ElectronicFence{ // 电子围栏
        static let infieldOutfieldHeight = 266 // 内外场矩形的高度
        static let infieldWidth = 91 // 内场矩形的宽度
        static let outfieldWidth = 54 // 外场矩形的宽度
    }
    
    // 小地图
    class VirvutalMap {
        static let smallWidth = 373
        static let smallHeight = 179

    }
    /// 校准点的宽高
    static let calibrationPointWidthHeight = 16
    
    static let ScreenWidth = UIScreen.main.bounds.size.width
    static let ScreenHeight = UIScreen.main.bounds.size.height
    static let Scale =  500.0 / 748.0
    
    /// ABC 按钮的颜色
    static let areaBtnColor = UIColor(red: 19/255.0, green: 19/255.0, blue: 20/255.0, alpha: 1.0)
    static let areaBtnSelectedColor = UIColor(red: 233/255.0, green: 100/255.0, blue: 21/255.0, alpha: 1.0)
    
    static let areaBgColor = UIColor(red: 27/255.0, green: 66/255.0, blue: 197/255.0, alpha: 0.75)
    static let areaBgSelectedColor = UIColor(red: 25/255.0, green: 243/255.0, blue: 134/255.0, alpha: 0.75)
    
    static let hignBGColor = UIColor(red: 233/255.0, green: 100/255.0, blue: 21/255.0, alpha: 1.0)
    static let disableBGColor = UIColor(red: 49/255.0, green: 52/255.0, blue: 67/255.0, alpha: 1.0)
    static let disableTextColor = UIColor(red: 156/255.0, green: 156/255.0, blue: 156/255.0, alpha: 1.0)
    
    static let maskColor = UIColor(red: 28/255.0, green: 29/255.0, blue: 32/255.0, alpha: 0.85)
    
    static let alertBGColor = UIColor(red: 25/255.0, green: 25/255.0, blue: 25/255.0, alpha: 0.8)
    static let alertCanvasBGColor = UIColor(red: 49/255.0, green: 52/255.0, blue: 67/255.0, alpha: 1.0)

    /// 电量通知
    static let Notification_Battery = "NotificationBattery"
    /// 机器人球满通知
    static let Notification_Robot_Ball_Full = "RobotBallFullSingle"
    /// 机器人开始导航响应通知
    static let Notification_Robot_Begin_Navi = "RobotBeginNaviSingle"
    /// 机器人结束导航响应通知
    static let Notification_Robot_End_Navi = "RobotEndNaviSingle"
    /// 机器人避障结束通知
    static let Notification_Robot_Obstacle_Avoidance_End_Navi = "RobotObstacleAvoidanceEndSingle"
    
    /// 机器人蓝牙断连通知
    static let Notification_Robot_Bluetooth_Disconnect = "bluetoothDisconnectSingle"
    
    /// 0x62机器人应答start,stop成功
    static let Notification_Robot_Receive_StartOrStopSingle = "RobotReceiveStartOrStopSingle"
    
    /// 捡球成功上报
    static let Notification_Robot_Pick_Ball_Success = "RobotPickupBallSuccess"



}
