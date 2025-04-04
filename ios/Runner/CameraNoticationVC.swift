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
     }
    
    @objc func handleBeginNotification(_ notification: Notification) {
        /// 开始给机器人发送角度信息0x53
        print("收到机器人的回复开始导航指令了")
   }
    
    @objc func handleEndNotification(_ notification: Notification) {
        /// 机器人导航结束以后 ///
        print("机器人导航到指定地方了")
        
        if originNavigation { // 原点导航需要给机器人发送stop
            // 通知机器人stop
            channel.invokeMethod("beginPickBall", arguments: false)
           ///  app 修改按钮
            self.canvas.actionBtn.setTitle("Start", for: .normal)
        }
    }
    
    /// 机器人避障结束了
    @objc func handleAvoEndNotification(_ notification: Notification) {
        print("机器人避障结束了")
        channel.invokeMethod("endNavigation", arguments: "2")
     }
    
    @objc func handleDisconnectNotification(_ notification: Notification) {
        print("机器人连接断开")
        self.dismiss(animated: false)
    }
    
}

class CameraNoticationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
