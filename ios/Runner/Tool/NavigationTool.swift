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
        return CGPoint(x: 488, y: 75)
    }
    
    /// 获取右下角 导航原点的中心点
    public
    static
    func getRightBottomOriginCoordinate() -> CGPoint {
        return CGPoint(x: 488, y: 322)
//        return CGPoint(x: 500, y: 300)

    }
    
    /// 获取右下角 导航原点的矩形框
    public
    static
    func getRightBottomOriginRectangle() -> CGRect {
       // return CGRect(x: 488, y: 322, width: 21, height:21)
        return CGRect(x: 470, y: 290, width: 80, height:80)
    }
    
    /// 获取左下角 导航原点的中心点
    public
    static
    func getLeftBottomOriginCoordinate() -> CGPoint {
        
        return CGPoint(x: 332 , y: 322)

    }
    
    //  MARK: - 导航常量 电子围栏1
    /// 电子围栏内场的矩形框
    public
    static
    func getEletronicFenceInfieldRectangle() -> CGRect {
        
        return CGRect(x: 344, y: 66, width: Constants.ElectronicFence.infieldWidth, height: Constants.ElectronicFence.infieldOutfieldHeight)
    }
    
    /// 电子围栏内场的中心点
    public
    static
    func getEletronicFenceInfieldCenterPoint() -> CGPoint {
        var centerPoint = CGPoint(x: getEletronicFenceInfieldRectangle().midX, y: getEletronicFenceInfieldRectangle().midY)
        return centerPoint
    }
    
    /// 电子围栏外场的矩形框
    public
    static
    func getEletronicFenceOutfieldRectangle() -> CGRect {
        return CGRect(x: 344 + 260 - 54, y: 66, width: Constants.ElectronicFence.outfieldWidth, height: Constants.ElectronicFence.infieldOutfieldHeight)
    }
    
    /// 电子围栏外场的中心点
    public
    static
    func getEletronicFenceOutfieldCenterPoint() -> CGPoint {
        var centerPoint = CGPoint(x: getEletronicFenceOutfieldRectangle().midX, y: getEletronicFenceOutfieldRectangle().midY)
        return centerPoint
    }
    
    /// 休息模式电子围栏的矩形框
    public
    static
    func getRestModelEletronicFenceRectangle() -> CGRect {
        return CGRect(x: 300, y: 66, width: 250, height: 280)
    }
    
    /// 休息模式电子围栏的中心点
    public
    static
    func getRestModelEletronicFenceCenterPoint() -> CGPoint {
        let centerPoint = CGPoint(x: getRestModelEletronicFenceRectangle().midX, y: getRestModelEletronicFenceRectangle().midY)
        return centerPoint
    }
  
}
