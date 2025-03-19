//
//  ElectronicFence.swift
//  Runner
//
//  Created by 孟恒 on 2025/3/12.
//

import UIKit
import Accelerate

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
                                            targetPoint: (x: Double, y: Double)) -> (direction: String, angle: String) {
        print("方向\(currentPoint)===\(targetPoint)==\(currentDirection)")
        
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
            direction = "1" // 左
        } else {
            direction = "2" // 右
        }
        
        // 将弧度转换为角度
        let angleDegrees = angle * 180.0 / Double.pi
        
        return (direction, "\(Int(angleDegrees))")
    }
    
    public
    static
    func new1calculateSteeringDirectionAndAngle(currentPoint: (x: Double, y: Double),
                                           currentDirection: (x: Double, y: Double),
                                           targetPoint: (x: Double, y: Double)) -> (direction: String, angle: String) {
        // 计算目标向量
        let targetVector = (x: targetPoint.x - currentPoint.x,y: targetPoint.y - currentPoint.y)


        // 计算点积
        let dotProduct = currentDirection.x * targetVector.x + currentDirection.y * targetVector.y

        // 计算模
        let currentDirectionLength = sqrt(currentDirection.x * currentDirection.x + currentDirection.y * currentDirection.y)
        let targetVectorLength = sqrt(targetVector.x * targetVector.x + targetVector.y * targetVector.y)

        // 计算夹角的余弦值
        let cosTheta = dotProduct / (currentDirectionLength * targetVectorLength)

        // 计算夹角（弧度）
        let angle = acos(cosTheta)

        // 计算叉积
        let crossProduct = currentDirection.x * targetVector.y - currentDirection.y * targetVector.x

        // 确定旋转方向
        let direction: String
        if crossProduct > 0 {
          //  direction = "逆时针" // 右
            direction = "2" // 右

        } else {
           // direction = "顺时针" // 左
            direction = "1" // 左
        }
        // 将弧度转换为度数
        let angleDegrees = angle * 180 / .pi
//        return (direction, "\(angleDegrees) 度")
        return (direction, "\(Int(angleDegrees))")
   }

    
    ///两个点的坐标计算方向可以通过计算两个点之间的角度来实
    public
    static
    func calculateDirection(from pointA: CGPoint, to pointB: CGPoint) -> (angle: CGFloat, direction: String) {
        // 计算向量
        let deltaX = pointB.x - pointA.x
        let deltaY = pointB.y - pointA.y
        
        // 计算角度（弧度）
        let angleRadians = atan2(deltaY, deltaX)
        
        // 转换为角度
        let angleDegrees = angleRadians * 180 / .pi
        
        // 确定方向
        let direction: String
        if angleDegrees >= -90 && angleDegrees <= 90 {
            direction = "向右"
        } else {
            direction = "向左"
        }
        
        return (angleDegrees, direction)
    }
    
    /// 角度转换为方向向量
    public
    static
    func angleToDirectionVector(angle: Double) -> (x: Double, y: Double) {
        // 将角度转换为弧度
        let radians = angle * Double.pi / 180
        
        // 计算方向向量的分量
        let x = cos(radians)
        let y = sin(radians)
        
        return (x, y)
    }
    
    public
    static
    func calculateVector(angle: Double) -> (x: Double, y: Double) {
        // 将角度转换为弧度，因为 Swift 标准库中的三角函数使用弧度制
        let angleRad = angle * Double.pi / 180
        // 计算向量在 x 轴上的分量
        let x = -cos(angleRad)
        // 计算向量在 y 轴上的分量
        let y = -sin(angleRad)
        return (x, y)
    }
//    // 示例使用
//    let angle: Double = 45
//    // 假设角度为 45 度
//    let vector = calculateVector(angle: angle)
//    print("物体指向的向量为: \(vector)")
    
    

    
    
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
    
    
    public
    static
    func newFitMotionTrend(coordinateQueue: [(Double, Double)]) -> ((Double) -> Double, (Double) -> Double) {
        guard coordinateQueue.count >= 2 else {
            return ({ _ in 0.0 }, { _ in 0.0 })
        }

        // 分离 x 坐标和 y 坐标
        let xCoords = coordinateQueue.map { $0.0 }
        let yCoords = coordinateQueue.map { $0.1 }

        // 创建时间序列（帧序号）
        let frames = (0..<coordinateQueue.count).map { Double($0) }

        // 对 x 坐标进行线性拟合
        let xTrend = linearFit(frames: frames, values: xCoords)

        // 对 y 坐标进行线性拟合
        let yTrend = linearFit(frames: frames, values: yCoords)

        return (xTrend, yTrend)
    }

    public
    static
    func linearFit(frames: [Double], values: [Double]) -> (Double) -> Double {
        // 转换为数组
        var framesArray = [Double](repeating: 0.0, count: frames.count)
        var valuesArray = [Double](repeating: 0.0, count: values.count)
        framesArray = frames
        valuesArray = values

        // 创建矩阵
        var A = [Double](repeating: 0.0, count: frames.count * 2)
        var b = [Double](repeating: 0.0, count: frames.count)

        // 填充矩阵 A 和向量 b
        for i in 0..<frames.count {
            A[i * 2] = frames[i]
            A[i * 2 + 1] = 1.0
            b[i] = values[i]
        }

        // 转换为矩阵
        var AMatrix = [__CLPK_doublereal](repeating: 0.0, count: A.count)
        var bMatrix = [__CLPK_doublereal](repeating: 0.0, count: b.count)
        AMatrix = A.map { __CLPK_doublereal($0) }
        bMatrix = b.map { __CLPK_doublereal($0) }

        // 解线性方程组
        var ipiv = [__CLPK_integer](repeating: 0, count: 2)
        var info: __CLPK_integer = 0
        
        var infoTwo: __CLPK_integer = 2
        var infoOne: __CLPK_integer = 1
        var infoNewTwo: __CLPK_integer = 2
        var infoNewNewTwo: __CLPK_integer = 2




        dgesv_(&infoNewTwo, &infoOne, &AMatrix, &infoTwo, &ipiv, &bMatrix, &infoNewNewTwo, &info)

        // 提取系数
        let slope = Double(bMatrix[0])
        let intercept = Double(bMatrix[1])

        // 返回线性函数
        return { x in slope * x + intercept }
    }

    
    // 线性拟合函数，返回斜率和截距
    public
    static
    func linearFit(x: [Double], y: [Double]) -> (Double, Double) {
        precondition(x.count == y.count, "输入的 x 和 y 数组长度必须相同")
        let n = Double(x.count)
        if n < 2 { return (0, 0) }
        var sumX: Double = 0
        var sumY: Double = 0
        var sumXY: Double = 0
        var sumX2: Double = 0
        for i in 0..<x.count {
            sumX += x[i]
            sumY += y[i]
            sumXY += x[i] * y[i]
            sumX2 += x[i] * x[i]
        }
        let slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX)
        let intercept = (sumY - slope * sumX) / n
        return (slope, intercept)
    }
    // 拟合运动趋势的函数
    public
    static
    func NewNewfitMotionTrend(coordinateQueue: [(Double, Double)]) -> ((Double, Double), (Double, Double)) { if coordinateQueue.count < 2 { return ((0, 0), (0, 0)) } // 分离 x 坐标和 y 坐标
        var xCoords: [Double] = []
        var yCoords: [Double] = []
        for coord in coordinateQueue {
            xCoords.append(coord.0)
            yCoords.append(coord.1)
        }
        // 创建时间序列（帧序号）
        let frames = (0..<coordinateQueue.count).map { Double($0) }
        // 对 x 坐标进行线性拟合
        let xFit = linearFit(x: frames, y: xCoords) //
        // 对 y 坐标进行线性拟合
        let yFit = linearFit(x: frames, y: yCoords)
        return (xFit, yFit)
    }
    
    //let coordinateQueue: [(Double, Double)] = [(1, 2), (2, 4), (3, 6), (4, 8)]
   // let (xFit, yFit) = fitMotionTrend(coordinateQueue: coordinateQueue)
    //print("x 坐标拟合结果: 斜率 \(xFit.0), 截距 \(xFit.1)") print("y 坐标拟合结果: 斜率 \(yFit.0), 截距 \(yFit.1)")
    
}
