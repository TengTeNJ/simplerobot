//
//  NavigationTool.swift
//  Runner
//
//  Created by 孟恒 on 2025/3/14.
//

import UIKit

/// 导航相关
class NavigationTool: NSObject {
    //  MARK: - 导航常量 原点导航3
    
    /// 获取右上角 导航原点的中心点
    public
    static
    func getRightTopOriginCoordinate() -> CGPoint {
        return CGPoint(x: 507, y: 90)
    }
    
    /// 获取右上角 导航原点的矩形框
    public
    static
    func getRightTopOriginRectangle() -> CGRect {
        return CGRect(x: getEletronicFenceOutfieldRectangle().origin.x - 21 - 5, y: 0, width: 80, height:110)
    }
    
    
    /// 获取右下角 导航原点的中心点
    public
    static
    func getRightBottomOriginCoordinate() -> CGPoint {
        return CGPoint(x: 507, y: 307)

    }
    
    /// 获取右下角 导航原点的矩形框
    public
    static
    func getRightBottomOriginRectangle() -> CGRect {
//        return CGRect(x: getEletronicFenceOutfieldRectangle().origin.x - 21 - 5, y: Constants.ScreenHeight - 85, width: 80, height:80)
        return CGRect(x: 490, y:286, width: 90, height:90)
        
    }
    
    /// 获取左上角 导航原点的中心点
    public
    static
    func getLeftTopOriginCoordinate() -> CGPoint {
        return CGPoint(x: 330 , y: 90)
    }
    
    /// 获取左上角 导航原点的的矩形框
    public
    static
    func getLeftTOpOriginCoordinate() -> CGRect {
        return CGRect(x: 320, y: 0, width: 110, height:100)
    }
    
    
    // MARK: -  自动导航 内场区域细分
    /// 自动导航内场上半场的矩形框
    public
    static
    func getEletronicFenceTopHalfInfieldRectangle() -> CGRect {
        return CGRect(x: Int(getEletronicFenceInfieldRectangle().minX), y: 110, width: Constants.ElectronicFence.infieldWidth + 20, height: (Constants.ElectronicFence.infieldOutfieldHeight - 86)/2)
    }
    
    /// 自动导航内场上半场的矩形框的中心点
    public
    static
    func getEletronicFenceTopHalfInfieldCenterPoint() -> CGPoint {
        let centerPoint = CGPoint(x: getEletronicFenceTopHalfInfieldRectangle().midX, y: getEletronicFenceTopHalfInfieldRectangle().midY)
        return centerPoint
    }
    
    /// 自动导航内场下半场的矩形框
    public
    static
    func getEletronicFenceBottomHalfInfieldRectangle() -> CGRect {
        return CGRect(x: Int(getEletronicFenceInfieldRectangle().minX), y: 110 + (Constants.ElectronicFence.infieldOutfieldHeight - 86)/2, width: Constants.ElectronicFence.infieldWidth + 20, height: (Constants.ElectronicFence.infieldOutfieldHeight - 86)/2)
    }
    
    /// 自动导航内场下半场的矩形框的中心点
    public
    static
    func getEletronicFenceBottomHalfInfieldCenterPoint() -> CGPoint {
        let centerPoint = CGPoint(x: getEletronicFenceBottomHalfInfieldRectangle().midX, y: getEletronicFenceBottomHalfInfieldRectangle().midY)
        return centerPoint
    }
    
    /// 自动导航半场  右上角 1/4的矩形框
    public
    static
    func getEletronicFenceTopRightOneFourthInfieldRectangle() -> CGRect {
        // 休息模式整个半场的宽度 - 内场上半场的宽度
        let width = getRestModelEletronicFenceRectangle().width - getEletronicFenceTopHalfInfieldRectangle().width
        
        return CGRect(x: Int(getEletronicFenceTopHalfInfieldRectangle().minX + getEletronicFenceTopHalfInfieldRectangle().width), y: 110, width: Int(width)  , height: (Constants.ElectronicFence.infieldOutfieldHeight - 86)/2)
    }
    
    //自动导航半场  右上角 1/4的矩形框 的中心店
    public
    static
    func getEletronicFenceTopRightOneFourthInfieldRectangleCenterPoint() -> CGPoint {
        let centerPoint = CGPoint(x: getEletronicFenceTopRightOneFourthInfieldRectangle().midX, y: getEletronicFenceTopRightOneFourthInfieldRectangle().midY)
        return centerPoint
    }
    
    /// 自动导航整个半场  右下角 1/4的矩形框
    public
    static
    func getEletronicFenceBottomRightOneFourthInfieldRectangle() -> CGRect {
        // 休息模式整个半场的宽度 - 内场下半场的宽度
        let width = getRestModelEletronicFenceRectangle().width - getEletronicFenceTopHalfInfieldRectangle().width
        
        return CGRect(x: Int(getEletronicFenceTopHalfInfieldRectangle().minX + getEletronicFenceTopHalfInfieldRectangle().width), y: 110 + Int(getEletronicFenceTopRightOneFourthInfieldRectangle().height) , width: Int(width)  , height: (Constants.ElectronicFence.infieldOutfieldHeight - 86)/2)
    }
    
    //自动导航半场  右下角 1/4的矩形框 的中心点
    public
    static
    func getEletronicFenceBottomRightOneFourthInfieldRectangleCenterPoint() -> CGPoint {
        let centerPoint = CGPoint(x: getEletronicFenceBottomRightOneFourthInfieldRectangle().midX, y: getEletronicFenceBottomRightOneFourthInfieldRectangle().midY)
        return centerPoint
    }
    
    /// 自动导航外场上半场的矩形框
    public
    static
    func getEletronicFenceTopHalfOutfieldRectangle() -> CGRect {
        return CGRect(x: Int(getEletronicFenceOutfieldRectangle().minX), y: Int(getEletronicFenceOutfieldRectangle().minY), width: Int(getEletronicFenceOutfieldRectangle().width), height: Int(getEletronicFenceOutfieldRectangle().height/2))
    }
    
    /// 自动导航外场上半场的矩形框的中心店
    public
    static
    func getEletronicFenceTopHalfOutfieldRectangleCenterPoint() -> CGPoint {
        let centerPoint = CGPoint(x: getEletronicFenceTopHalfOutfieldRectangle().midX, y: getEletronicFenceTopHalfOutfieldRectangle().midY)
        return centerPoint
    }
    
    /// 自动导航外场下半场的矩形框
    public
    static
    func getEletronicFenceBottomHalfOutfieldRectangle() -> CGRect {
        return CGRect(x: Int(getEletronicFenceOutfieldRectangle().minX), y: Int(getEletronicFenceOutfieldRectangle().midY), width: Int(getEletronicFenceOutfieldRectangle().width), height: Int(getEletronicFenceOutfieldRectangle().height/2))
    }
    
    /// 自动导航外场下半场的矩形框的中心店
    public
    static
    func getEletronicFenceBottomHalfOutfieldRectangleCenterPoint() -> CGPoint {
        let centerPoint = CGPoint(x: getEletronicFenceBottomHalfOutfieldRectangle().midX, y: getEletronicFenceBottomHalfOutfieldRectangle().midY)
        return centerPoint
    }
    
    
    
    // MARK: -如上  自动导航
    
    
    /// 休息模式自动导航的中场矩形框
    public
    static
    func getAutoAnimationRestModelEletronicFenceRectangle() -> CGRect {
        return CGRect(x: 310 + 205/2, y: 110, width: 205 / 2, height: 180)
    }
    
    
    //  MARK: - 导航常量 电子围栏1
    /// 电子围栏内场的矩形框
    public
    static
    func getEletronicFenceInfieldRectangle() -> CGRect {
        
        return CGRect(x: 334 - 20, y: 110, width: Constants.ElectronicFence.infieldWidth + 20, height: Constants.ElectronicFence.infieldOutfieldHeight - 86)
    }
  
    /// 电子围栏内场的中心点
    public
    static
    func getEletronicFenceInfieldCenterPoint() -> CGPoint {
        let centerPoint = CGPoint(x: getEletronicFenceInfieldRectangle().midX, y: getEletronicFenceInfieldRectangle().midY)
        return centerPoint
    }
    
    /// 电子围栏进入内场判定的小矩形框
    public
    static
    func getEletronicFenceInfieldCenterSmallRectangle() -> CGRect {
        return CGRect(x: getEletronicFenceInfieldCenterPoint().x - 40, y: getEletronicFenceInfieldCenterPoint().y - 40, width: 40, height: 40)
    }
    
    /// 电子围栏外场的矩形框
    public
    static
    func getEletronicFenceOutfieldRectangle() -> CGRect {
        return CGRect(x: 524, y: 62, width: Constants.ElectronicFence.outfieldWidth + 80, height: Constants.ElectronicFence.infieldOutfieldHeight)
    }
    
    /// 电子围栏外场的中心点
    public
    static
    func getEletronicFenceOutfieldCenterPoint() -> CGPoint {
        let centerPoint = CGPoint(x: getEletronicFenceOutfieldRectangle().midX, y: getEletronicFenceOutfieldRectangle().midY)
        return centerPoint
    }
    
    
    /// 电子围栏进入外场判定的小矩形框
    public
    static
    func getEletronicFenceOutfieldCenterSmallRectangle() -> CGRect {
        return CGRect(x: getEletronicFenceOutfieldCenterPoint().x - 40, y: getEletronicFenceOutfieldCenterPoint().y - 40, width: 40, height: 40)
    }
    /// 休息模式电子围栏的矩形框
    public
    static
    func getRestModelEletronicFenceRectangle() -> CGRect {
        return CGRect(x: 310, y: 110, width: 185 + 20, height: 180)
    }
    
    /// 休息模式电子围栏的中心点
    public
    static
    func getRestModelEletronicFenceCenterPoint() -> CGPoint {
        let centerPoint = CGPoint(x: 400, y: 195)
        return centerPoint
    }
    
    /// 休息模式电子围栏的中心小矩形框
    public
    static
    func getRestModelEletronicFenceCenterRectangle() -> CGRect {
//        let RestModelCenterRectangle = CGRectMake(getRestModelEletronicFenceCenterPoint().x - 100, getRestModelEletronicFenceCenterPoint().y - 100, 100, 100)
          return CGRect(x: 310, y: 111, width: 185 + 20, height: 180)
    }
  
}
