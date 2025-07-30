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
        /// 自动导航计时停止
        self.pickBalltimerManager.pauseTimer()

        
        /// 导航机器人到右下角的原点
        originNavigation = true
        commonNavigation(directionVectorX: 1, directionVectorY: 1)
        
        /// 1. 原点导航过程中 超过30s就让原点导航结束（防止中间过程中失去视野导致机器人会一直走。）
        ///  开启定时器
        timerManager.startTimer(interval: 30, repeats: true) {
            /// APP 发送导航结束指令*/ //0x54   1 到达原点  2 区域位置到达
             print("导航到原点了")
            if (self.originNavigation) {
                self.channel.invokeMethod("endNavigation", arguments: "1")
            }
            /// 停止计时器
            self.timerManager.pauseTimer()
            
        }
        
     }
    
    @objc func handleBeginNotification(_ notification: Notification) {
        /// 开始给机器人发送角度信息0x53
        print("收到机器人的回复开始导航指令了")
   }
    
    @objc func handleEndNotification(_ notification: Notification) {
      if originNavigation { // 原点导航结束机器人停止 以后APP 重置按钮状态
            // 通知机器人stop
            // channel.invokeMethod("beginPickBall", arguments: false)
           ///  app 修改按钮
            self.canvas.actionBtn.setTitle("Start", for: .normal)
          /// 停止计时器
//            self.timerManager.stopTimer()
        }
        
        /// 机器人导航结束以后 ///
        // 获取通知中传递的数据
        if let userInfo = notification.userInfo,
           let message = userInfo["message"] as? String {
            if message == "2" { // 区域导航
                electronicFenceNavigation = false
                print("机器人区域导航结束")
                ///
                commonAutoNavigation()
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
    
    
    /// 捡球成功上报
    @objc func handlePickBallSuccessNotification(_ notication: Notification) {
        print("Swift 捡球成功")
        lastPickBallSuccessDate = Date()
        self.pickBalltimerManager.pauseTimer()

       
        commonAutoNavigation()
    }
    
    
    // MARK: - 自动导航逻辑处理
    func commonAutoNavigation() {
        if (self.autoNavigation == true ){ /// 防止重复的执行该方法
            return
        }
        print("创建自动导航定时器了")
        /// 在一个区域捡球超过30s没有捡球上报，导航到另一个区域
        pickBalltimerManager.startTimer(interval: 30, repeats: true) {
            print("\(self.calculateTime(index: 2))一个区域捡球超过30s没有捡球上报，导航到另一个区域")
            self.autoNavigation = true
             
            
            /// 设置自动导航的终点相关参数
            if (self.currentElectronicFenceArea == NavigationTool.getEletronicFenceInfieldRectangle()) { // 内场
                self.autoNavigationAlgorithmForInfield()
                print("电子围栏内场")
            } else if (self.currentElectronicFenceArea == NavigationTool.getEletronicFenceOutfieldRectangle()) { // 外场
                self.autoNavigationAlgorithmForOutfield()
                print("电子围栏外场")

            } else if (self.currentElectronicFenceArea == NavigationTool.getRestModelEletronicFenceRectangle()) { // 整个半场
                print("电子围栏整个半场")
                self.autoNavigationAlogorithmForHalfCourt()
        
                

            }

        }
    }
    
    ///  整个半场的自动导航导航算法
    func autoNavigationAlogorithmForHalfCourt() {
        if(NavigationTool.getEletronicFenceTopRightOneFourthInfieldRectangle().contains(self.curentRobotPosition)) { // 机器人在的右上角区域，导航机器人到右下角区域
            self.currentAutoNaviDesinationPoint = NavigationTool.getEletronicFenceBottomRightOneFourthInfieldRectangleCenterPoint()
            self.currentAutoNaviDedinationRectangle =
            NavigationTool.getEletronicFenceBottomRightOneFourthInfieldRectangle()
        }
        
        if(NavigationTool.getEletronicFenceBottomRightOneFourthInfieldRectangle().contains(self.curentRobotPosition)) {  /// 机器人在的右下角区域，导航机器人到左下角区域
            self.currentAutoNaviDesinationPoint = NavigationTool.getEletronicFenceBottomHalfInfieldCenterPoint()
            self.currentAutoNaviDedinationRectangle =
            NavigationTool.getEletronicFenceBottomHalfInfieldRectangle()
        }
        
        if(NavigationTool.getEletronicFenceBottomHalfInfieldRectangle().contains(self.curentRobotPosition)) { // 机器人在内场的下半场区域，导航机器人到内场的上半场区域
            self.currentAutoNaviDesinationPoint = NavigationTool.getEletronicFenceTopHalfInfieldCenterPoint()
            self.currentAutoNaviDedinationRectangle =
            NavigationTool.getEletronicFenceTopHalfInfieldRectangle()
        }
        
        if(NavigationTool.getEletronicFenceTopHalfInfieldRectangle().contains(self.curentRobotPosition)) { // 机器人在内场的上半场区域，导航机器人到半场的右上角
            self.currentAutoNaviDesinationPoint = NavigationTool.getEletronicFenceTopRightOneFourthInfieldRectangleCenterPoint()
            self.currentAutoNaviDedinationRectangle =
            NavigationTool.getEletronicFenceTopRightOneFourthInfieldRectangle()
        }
        
    }
    
    
    // 单打线 的两个区域切换
    func autoNavigationAlgorithmForSingleInfield() {
        if(NavigationTool.getEletronicFenceTopRightOneFourthInfieldRectangle().contains(self.curentRobotPosition)) { // 机器人在的右上角区域，导航机器人到右下角区域
            self.currentAutoNaviDesinationPoint = NavigationTool.getEletronicFenceBottomRightOneFourthInfieldRectangleCenterPoint()
            self.currentAutoNaviDedinationRectangle =
            NavigationTool.getEletronicFenceBottomRightOneFourthInfieldRectangle()
        }
        
        if(NavigationTool.getEletronicFenceBottomRightOneFourthInfieldRectangle().contains(self.curentRobotPosition)) {  /// 机器人在的右下角区域，导航机器人到右上角区域
            self.currentAutoNaviDesinationPoint = NavigationTool.getEletronicFenceTopRightOneFourthInfieldRectangleCenterPoint()
            self.currentAutoNaviDedinationRectangle =
            NavigationTool.getEletronicFenceTopRightOneFourthInfieldRectangle()
        }
        
    }
    
    //内场的自动导航导航算法
    func autoNavigationAlgorithmForInfield() {
        if(NavigationTool.getEletronicFenceTopHalfInfieldRectangle().contains(self.curentRobotPosition)) { // 机器人在内场的上半场区域，导航机器人到内场的下半场区域
            self.currentAutoNaviDesinationPoint = NavigationTool.getEletronicFenceBottomHalfInfieldCenterPoint()
            self.currentAutoNaviDedinationRectangle =
            NavigationTool.getEletronicFenceBottomHalfInfieldRectangle()
        }
        
        if(NavigationTool.getEletronicFenceBottomHalfInfieldRectangle().contains(self.curentRobotPosition)) { // 机器人在内场的下半场区域，导航机器人到内场的上半场区域
            self.currentAutoNaviDesinationPoint = NavigationTool.getEletronicFenceTopHalfInfieldCenterPoint()
            self.currentAutoNaviDedinationRectangle =
            NavigationTool.getEletronicFenceTopHalfInfieldRectangle()
        }
    }
    
    //外场的自动导航导航算法
    func autoNavigationAlgorithmForOutfield() {
        if(NavigationTool.getEletronicFenceTopHalfOutfieldRectangle().contains(self.curentRobotPosition)) { // 机器人在外场的上半场区域，导航机器人到外场的下半场区域
            self.currentAutoNaviDesinationPoint = NavigationTool.getEletronicFenceBottomHalfOutfieldRectangleCenterPoint()
            self.currentAutoNaviDedinationRectangle =
            NavigationTool.getEletronicFenceBottomHalfOutfieldRectangle()
        }
        
        if(NavigationTool.getEletronicFenceBottomHalfOutfieldRectangle().contains(self.curentRobotPosition)) { // 机器人在外场的下半场区域，导航机器人到外场的上半场区域
            self.currentAutoNaviDesinationPoint = NavigationTool.getEletronicFenceTopHalfOutfieldRectangleCenterPoint()
            self.currentAutoNaviDedinationRectangle =
            NavigationTool.getEletronicFenceTopHalfOutfieldRectangle()
        }
        
    }
    
}

class CameraNoticationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
