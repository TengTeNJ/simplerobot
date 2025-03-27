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
        return CGRect(x: getEletronicFenceOutfieldRectangle().origin.x - 21 - 5, y: Constants.ScreenHeight - 85, width: 80, height:80)
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
    
    //  MARK: - 导航常量 电子围栏1
    /// 电子围栏内场的矩形框
    public
    static
    func getEletronicFenceInfieldRectangle() -> CGRect {
        
        return CGRect(x: 334, y: 62, width: Constants.ElectronicFence.infieldWidth, height: Constants.ElectronicFence.infieldOutfieldHeight)
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
