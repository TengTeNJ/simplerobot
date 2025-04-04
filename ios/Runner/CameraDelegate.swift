//
//  CameraDelegate.swift
//  Runner
//
//  Created by 孟恒 on 2025/3/28.
//

import UIKit

/// 相关代理
extension CameraCalibrationController {
    
    // MARK: 原点区域切换 - CameraPickCanvasDelegate
   func originViewSwitch(_ view: CameraPickCanvas, didSendData data: Int) {
       if data == 3 { // 右下
           currebtOriginPoint = NavigationTool.getRightBottomOriginCoordinate()
           currebtOriginRectangle = NavigationTool.getRightBottomOriginRectangle()
       } else if (data == 1) { // 右上
           currebtOriginPoint = NavigationTool.getRightTopOriginCoordinate()
           currebtOriginRectangle = NavigationTool.getRightTopOriginRectangle()
       } else { // 左上
           currebtOriginPoint = NavigationTool.getLeftTopOriginCoordinate()
           currebtOriginRectangle = NavigationTool.getLeftTOpOriginCoordinate()
       }
        print("原点区域切换\(data)")
    }

    
    
    // MARK: -  休息模式训练模式切换的代理方法
    func ModeSwitchDelegate(_ view: CameraPickCanvas, didSendData data: Int) {
        if data == 99 { // 训练模式
            channel.invokeMethod("changeRobotMode", arguments: "training")
            currentRobotMode = Constants.CurrentRobotModel.training
            currentElectronicFenceArea = NavigationTool.getEletronicFenceInfieldRectangle()
            currebtElectronicfenceDesinationPoint = NavigationTool.getEletronicFenceInfieldCenterPoint()
            currentElectronicFenceDesinationSamllRectangle = NavigationTool.getEletronicFenceInfieldCenterSmallRectangle()
            
         } else { // 休息模式
            channel.invokeMethod("changeRobotMode", arguments: "rest")
            currentRobotMode = Constants.CurrentRobotModel.rest
            currentElectronicFenceArea = NavigationTool.getRestModelEletronicFenceRectangle()
            currebtElectronicfenceDesinationPoint = NavigationTool.getRestModelEletronicFenceCenterPoint()
             currentElectronicFenceDesinationSamllRectangle = NavigationTool.getRestModelEletronicFenceCenterRectangle()
         }
    }
    
    // MARK: - trainingModeSwitchAreaDelegate 训练模式 内场外场区域切换的代理方法
    func trainingModeSwitchAreaDelegate(_ view: CameraPickCanvas, didSendData data: Int) {
        if data == 10 { // 内场
            currentElectronicFenceArea = NavigationTool.getEletronicFenceInfieldRectangle()
            currebtElectronicfenceDesinationPoint = NavigationTool.getEletronicFenceInfieldCenterPoint()
            currentElectronicFenceDesinationSamllRectangle = NavigationTool.getEletronicFenceInfieldRectangle()
        } else { // 外场
            currentElectronicFenceArea = NavigationTool.getEletronicFenceOutfieldRectangle()
            currebtElectronicfenceDesinationPoint = NavigationTool.getEletronicFenceOutfieldCenterPoint()
            currentElectronicFenceDesinationSamllRectangle = NavigationTool.getEletronicFenceOutfieldRectangle()
        }
    }
    
    // MARK: - beginPickBallDelegate 点击开始捡球的代理方法
    func beginPickBallDelegate(_ view: CameraPickCanvas, didSendData data: Bool) {
        channel.invokeMethod("beginPickBall", arguments: data)
    }
    
}

class CameraDelegate: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
   

}
