//
//  NavigationTool.swift
//  Runner
//
//  Created by 孟恒 on 2025/3/14.
//

import UIKit

/// 导航相关
class NavigationTool: NSObject {
    /// 获取右上角 导航原点的中心点
    public
    static
    func getRightTopOriginCoordinate() -> CGPoint {
        
        return CGPoint(x: 488, y: 75)
    }
    
    /// 获取左下角 导航原点的中心点
    public
    static
    func getLeftBottomOriginCoordinate() -> CGPoint {
        
        return CGPoint(x: 332 , y: 322)

    }
    
    /// 获取右下角 导航原点的中心点
    public
    static
    func getRightBottomOriginCoordinate() -> CGPoint {
        
        return CGPoint(x: 488, y: 322)

    }
}
