//
//  ElectronicFence.swift
//  Runner
//
//  Created by 孟恒 on 2025/3/12.
//

import UIKit

/// 电子围栏 相关
class ElectronicFence: NSObject {
    
    /// 运动坐标合集
    var queue = NSMutableArray()
   
    ///  计算训练模式下电子围栏 内场四个点的坐标
    public
    static
    func getInfieldRectangleCoordinate() -> [CGPoint]{
        let cgPoints: [CGPoint] = [CGPoint(x: 344, y: 66), // 左上
                                   CGPoint(x: 344 + Constants.ElectronicFence.infieldWidth, y: 66), // 右上
                                   CGPoint(x: 344, y: 66 + 266), // 左下
                                   CGPoint(x: 344 + Constants.ElectronicFence.infieldWidth, y: 66 + 266) // 右下
        ]

        return cgPoints
    }
    
    ///  计算训练模式下电子围栏 外场四个点的坐标
    public
    static
    func getOutfieldRectangleCoordinate() -> [CGPoint]{
        let cgPoints: [CGPoint] = [CGPoint(x: 360 + 96 + Constants.ElectronicFence.infieldWidth, y: 72), // 左上
                                   CGPoint(x: 360 + 96 + Constants.ElectronicFence.infieldWidth + Constants.ElectronicFence.outfieldWidth, y: 72), // 右上
                                   CGPoint(x:  360 + 96 + Constants.ElectronicFence.infieldWidth, y: 72 + Constants.ElectronicFence.infieldOutfieldHeight), // 左下
                                   CGPoint(x: 360 + 96 + Constants.ElectronicFence.infieldWidth + Constants.ElectronicFence.outfieldWidth, y: 72 + Constants.ElectronicFence.infieldOutfieldHeight) // 右下
        ]

        return cgPoints
    }
    
    /// 判定机器人有没有在电子围栏里面
    static func isPointInsideElectronicFence(point: CGPoint, quadrilateralPoints: [CGPoint]) -> Bool {
        guard quadrilateralPoints.count == 4 else {
               print("Error: Invalid number of points. Need exactly 4 points.")
               return false
           }
        // 创建一个 CGPath
           let path = CGMutablePath()
           path.addLines(between: quadrilateralPoints)
           path.closeSubpath()
         // 判定点是否在路径内
           return path.contains(point)
    }

    /// 计算机器人触碰到电子围栏后 机器人回到围栏中心的方向与角度
    public
    static
    func calculateSteeringDirectionAndAngle(currentPoint: (x: Double, y: Double),
                                            currentDirection: (x: Double, y: Double),
                                            targetPoint: (x: Double, y: Double)) -> (direction: String, angle: Double) {
        // 计算目标向量
        let targetVector = (x: targetPoint.x - currentPoint.x,y: targetPoint.y - currentPoint.y)
        
        // 计算当前运动向量和目标向量的点积
        let dotProduct = currentDirection.x * targetVector.x + currentDirection.y * targetVector.y
        
        // 计算当前运动向量和目标向量的模
        let currentDirectionLength = sqrt(pow(currentDirection.x, 2) + pow(currentDirection.y, 2))
        let targetVectorLength = sqrt(pow(targetVector.x, 2) + pow(targetVector.y, 2))
        
        // 计算夹角（弧度）
        let angle = acos(dotProduct / (currentDirectionLength * targetVectorLength))
        
        // 计算向量的叉积，用于确定转向方向
        let crossProduct = currentDirection.x * targetVector.y - currentDirection.y * targetVector.x
        
        // 确定转向方向
        let direction: String
        if crossProduct > 0 {
            direction = "左"
        } else {
            direction = "右"
        }
        
        // 将弧度转换为角度
        let angleDegrees = angle * 180.0 / Double.pi
        
        return (direction, angleDegrees)
    }

    
    
    /// 对前十次机器人的坐标进行线性拟合，得到机器人的大概运行方向  // 拟合运动趋势
    public
    static
    func fitMotionTrend(coordinateQueue: [(Double, Double)])  -> (x: Double, y: Double) {
        guard coordinateQueue.count >= 2 else {
            return (0, 0) // 返回两个常量函数，始终返回 0.0
        }
           // 分离 x 坐标和 y 坐标
           let xCoords = coordinateQueue.map { $0.0 }
           let yCoords = coordinateQueue.map { $0.1 }
           
           // 创建时间序列（帧序号）
           let frames = (0..<coordinateQueue.count).map { Double($0) }
           
           // 对 x 坐标进行线性拟合
           let (xSlope, xIntercept) = linearRegression(x: frames, y: xCoords)
           _ = { x in xSlope * x + xIntercept }
           // 对 y 坐标进行线性拟合
           let (ySlope, yIntercept) = linearRegression(x: frames, y: yCoords)
           _ = { y in ySlope * y + yIntercept }
         
           return (xIntercept, yIntercept)
     }
    
    // 线性回归函数
    public
    static
    func linearRegression(x: [Double], y: [Double]) -> (slope: Double, intercept: Double) {
        let n = Double(x.count)
        let sumX = x.reduce(0, +)
        let sumY = y.reduce(0, +)
        let sumXY = zip(x, y).map { $0 * $1 }.reduce(0, +)
        let sumX2 = x.map { $0 * $0 }.reduce(0, +)
        
        let slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX)
        let intercept = (sumY - slope * sumX) / n
        
        return (slope, intercept)
    }
    
}
