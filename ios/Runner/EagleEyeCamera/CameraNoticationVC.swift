//
//  CameraNoticationVC.swift
//  Runner
//
//  Created by 孟恒 on 2025/3/28.
//

import UIKit

/// FLutter 机器人指令交互的通知方法
extension CameraCalibrationController {
    // MARK: - 与FLutter 机器人指令交互的通知方法
    @objc func handleFullNotification(_ notification: Notification) {
          //App 收到机器人 球满的指令// 0x57
        print("收到机器人的球满指令了开始通知机器人导航")
        
        /// 导航机器人到右下角的原点
        originNavigation = true
        commonNavigation(directionVectorX: 1, directionVectorY: 1)
        
        /// 1. 原点导航过程中 超过30s就让原点导航结束（防止中间过程中失去视野导致机器人会一直走。）
        ///  开启定时器
//        timerManager.startTimer(interval: 30) {
//            /// APP 发送导航结束指令*/ //0x54   1 到达原点  2 区域位置到达
//             print("导航到原点了")
//            if (self.originNavigation) {
//                self.channel.invokeMethod("endNavigation", arguments: "1")
//            }
//            /// 停止计时器
//            self.timerManager.stopTimer()
//            
//        }
        
     }
    
    @objc func handleBeginNotification(_ notification: Notification) {
        /// 开始给机器人发送角度信息0x53
        print("收到机器人的回复开始导航指令了")
   }
    
    @objc func handleEndNotification(_ notification: Notification) {
      if originNavigation { // 原点导航需要给机器人发送stop
            // 通知机器人stop
            // channel.invokeMethod("beginPickBall", arguments: false)
           ///  app 修改按钮
            self.canvas.actionBtn.setTitle("Start", for: .normal)
        }
        
        /// 机器人导航结束以后 ///
        // 获取通知中传递的数据
        if let userInfo = notification.userInfo,
           let message = userInfo["message"] as? String {
            if message == "2" { // 区域导航
                electronicFenceNavigation = false
                print("机器人区域导航结束")
            } else if message == "1" { // 原点导航
                originNavigation = false
                print("机器人原点导航结束")

            }
        }
      
    }
    
    /// 机器人避障结束了
    @objc func handleAvoEndNotification(_ notification: Notification) {
        print("机器人避障结束了")
        channel.invokeMethod("endNavigation", arguments: "2")
     }
    
    @objc func handleDisconnectNotification(_ notification: Notification) {
        print("机器人连接断开")
        self.canvas.robot.isHidden = true
        self.dismiss(animated: false)
    }
    
    /// 0x62（机器人应答start,stop成功)
    @objc func handleStartOrStopNotification(_ notification: Notification) {
        timer.invalidate()
        if let userInfo = notification.userInfo,
           let message = userInfo["message"] as? String {
            if message == "0" { //  stop
                print("机器人应答stop成功")

            } else if message == "1" { // start
                print("机器人应答start成功")
            }
        }
    }
}

class CameraNoticationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
