//
//  CameraNavigation.swift
//  Runner
//
//  Created by 孟恒 on 2025/3/28.
//

import UIKit

/// 导航
extension CameraCalibrationController {
    //  MARK: - 导航通用方法  电子围栏1，区域导航2，原点导航3
    func commonNavigation(
        directionVectorX: Double ,directionVectorY: Double) {
        /// 导航机器人到原点
        let currentPoint = (x: Double(curentRobotPosition.x), y: Double(curentRobotPosition.y))
        let currentDirection = (x: directionVectorX, y: directionVectorY)
        let targetPoint = (x: Double(currebtOriginPoint.x), y: Double(currebtOriginPoint.y))
        let result = ElectronicFence.new1calculateSteeringDirectionAndAngle(currentPoint: currentPoint, currentDirection: currentDirection , targetPoint: targetPoint )
              print("转向方向: \(result.direction), 夹角: \(result.angle) 度")
        
        var realAngle = result.angle
        if (Int(realAngle) ?? 0 > 120) {
            realAngle =  "120"
        }
        /// 通知机器人开始导航 // 0x52
        channel.invokeMethod("beginNavigation", arguments: [
          "type":"3",
          "direction": "\(result.direction)",
          "angle": "\(realAngle)"
      ])
    }
    
    // 电子围栏导航
    func electronicFenceNavigation(
        directionVectorX: Double ,directionVectorY: Double) {
        /// 导航机器人到电子围栏中间
        let currentPoint = (x: Double(curentRobotPosition.x), y: Double(curentRobotPosition.y))
        let currentDirection = (x: directionVectorX, y: directionVectorY)
        let targetPoint = (x: Double(currebtElectronicfenceDesinationPoint.x), y: Double(currebtElectronicfenceDesinationPoint.y))
        let result = ElectronicFence.new1calculateSteeringDirectionAndAngle(currentPoint: currentPoint, currentDirection: currentDirection , targetPoint: targetPoint )
              print("电子围栏导航转向方向: \(result.direction), 夹角: \(result.angle) 度")
        
        var realAngle = result.angle
        if (Int(realAngle) ?? 0 > 120) {
            realAngle =  "120"
        }
        /// 通知机器人开始导航 // 0x52
        channel.invokeMethod("beginNavigation", arguments: [
          "type":"1",
          "direction": "\(result.direction)",
          "angle": "\(realAngle)"
      ])
    }
    
    // 自动导航
    func autoNavigation(directionVectorX: Double ,directionVectorY: Double) {
        let currentPoint = (x: Double(curentRobotPosition.x), y: Double(curentRobotPosition.y))
        let currentDirection = (x: directionVectorX, y: directionVectorY)
        let targetPoint = (x: Double(currentAutoNaviDesinationPoint.x), y: Double(currentAutoNaviDesinationPoint.y))
        let result = ElectronicFence.new1calculateSteeringDirectionAndAngle(currentPoint: currentPoint, currentDirection: currentDirection , targetPoint: targetPoint )
              print("自动导航转向方向: \(result.direction), 夹角: \(result.angle) 度")
        
        var realAngle = result.angle
        if (Int(realAngle) ?? 0 > 120) {
            realAngle =  "120"
        }
        /// 通知机器人开始导航 // 0x52
        channel.invokeMethod("beginNavigation", arguments: [
          "type":"1",
          "direction": "\(result.direction)",
          "angle": "\(realAngle)"
      ])
    }
    
    
    
     /// 显示虚拟地图机器人的位置
     /// - Parameter dstPoint: 虚拟地图机器人的坐标
     func showVirtualRobotPosition(dstPoint: CGPoint) {
        curentRobotPosition = dstPoint

        /// 到达原点（默认右下角）
         if (currebtOriginRectangle.contains(dstPoint) && originNavigation) {
             /// APP 发送导航结束指令*/ //0x54   1 到达原点  2 区域位置到达
              print("导航到原点了")
              channel.invokeMethod("endNavigation", arguments: "1")
         }
         
         /// 到达电子围栏区域了
         if (currentElectronicFenceDesinationSamllRectangle.contains(dstPoint) && electronicFenceNavigation && CommonTool.calculateTimeStamp(lastDate: lastNaviEndDate, currentDate: Date()) > 1) {
             /// APP 发送导航结束指令*/ //0x54   1 到达原点  2 区域位置到达
              print("导航到内场的电子围栏里面了了")
              channel.invokeMethod("endNavigation", arguments: "2")
              lastNaviEndDate = Date()
         }
         
         /// 自动导航到达终点的判定
         if (currentAutoNaviDedinationRectangle.contains(dstPoint) && autoNavigation) {
             autoNavigation = false
             print("导航到自动导航区域里面了了")
             channel.invokeMethod("endNavigation", arguments: "2")
         }
         
         
         let doubleXValue: Double = Double(dstPoint.x) as Double
         let doubleYValue: Double = Double(dstPoint.y) as Double

         /// 坐标进行线性
         self.queue.add((doubleXValue,doubleYValue))
         if (self.queue.count == 5) {
             let c = ElectronicFence.fitMotionTrend(coordinateQueue: queue as! [(Double, Double)])
             averagePoint = CGPoint(x: c.x, y: c.y)
             /// 清空queue 数据
             self.queue.removeAllObjects()
             /// 计算机器人角度
             let calulteAngle =  canvas.calculateAngleAndDirection(from: CGPoint(x: c.x, y: c.y), to: dstPoint)
             firstRobotAngle = Double(Int(calulteAngle.angle))
                 // 更新图标方向（角度为弧度）
             let hu = 2 * (M_PI) * self.firstRobotAngle / 360.0
             self.canvas.robot.transform = CGAffineTransform(rotationAngle:hu + M_PI)
             
             /// 计算当前小车的方向向量
             var directVector = ElectronicFence.calculateVector(angle: firstRobotAngle + 180)
             if (originNavigation) { // 开始原点导航
                 if(CommonTool.calculateTimeStamp(lastDate: lastNaviDate, currentDate: Date()) >= 1) {
                     commonNavigation(directionVectorX: directVector.x, directionVectorY: directVector.y)
                     lastNaviDate = Date()
                 }
                 
             } else if (!currentElectronicFenceArea.contains(dstPoint)) {
                 electronicFenceNavigation = true
                 /// 自动导航计时停止
                 self.pickBalltimerManager.pauseTimer()
                 /// 开启电子围栏导航
                 if(CommonTool.calculateTimeStamp(lastDate: lastNaviDate, currentDate: Date()) >= 1 && self.canvas.actionBtn.titleLabel?.text == "Pause") {
                     electronicFenceNavigation(directionVectorX: directVector.x, directionVectorY: directVector.y)
                     lastNaviDate = Date()
                   }
             } else if (autoNavigation) { //开始自动导航（在一个区域捡球超过30s没有捡球上报，自动导航到另一个区域
                    if(CommonTool.calculateTimeStamp(lastDate: lastNaviDate, currentDate: Date()) >= 1 ) {
                        autoNavigation(directionVectorX: directVector.x, directionVectorY: directVector.y)
                         lastNaviDate = Date()
                       }
                
            }
             
        }
        
         lastRobotPosition = dstPoint
        
         /// 更新机器人位置
         canvas.updateRobotLocation(x: Double(dstPoint.x), y: Double(dstPoint.y))

   }
     
     
    
}


class CameraNavigation: UIViewController {
   override func viewDidLoad() {
        super.viewDidLoad()
    }
    

}
