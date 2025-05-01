//
//  PerspectiveTransform.swift
//  Runner
//
//  Created by 孟恒 on 2025/3/10.
//

import Foundation
import opencv2

///未矫正的图像上（也就是相机原始拍到的图上）的点A，我们可以利用这个函数，求出在被校正过的图像（会显示在panel上）上的点B,坐标转换类
@objc(MHPerspectiveTransform)
class MHPerspectiveTransform: NSObject {
    ///这个Mat的格式，是 OpenCV 中一些函数（如 cv2.perspectiveTransform、cv2.findHomography 等）对输入点的标准要求
    public
    static
    func cgPointsToMat(_ cgPoints:[CGPoint]) throws -> Mat {
        let sourcePointsArray: [Point2f] = cgPoints.map { cgPoint in
            Point2f(x: Float(cgPoint.x), y: Float(cgPoint.y))
        }

        // 将点数组转换为 Mat
        let src = Mat(rows: Int32(sourcePointsArray.count), cols: 1, type: CvType.CV_32FC2)
        for (index, point) in sourcePointsArray.enumerated() {
            try src.put(row: Int32(index), col: 0, data: [point.x, point.y])
        }
        
        return src
    }
    
    @objc
    //也就是我们知道未矫正的图像上（也就是相机原始拍到的图上）的点A，我们可以利用这个函数，求出在被校正过的图像（会显示在panel上）上的点B
    public
    static
    func perspectiveTransform(points:[CGPoint]) throws -> [CGPoint] {
        /// 获取单应性矩阵
        let perspectiveMatrix = getIdentityPerspectiveTransformMatrix()
        
        //即使只有一个点，也要转换为这种形式
        let srcMat:Mat = try cgPointsToMat(points)
        
        let outputRef = Mat(rows: Int32(points.count), cols: 1, type: CvType.CV_32FC2)
        
        Core.perspectiveTransform(src: srcMat, dst: outputRef, m: perspectiveMatrix)
        let outputCGPoints:[CGPoint] = try matToCGPoints(outputRef)
        guard outputCGPoints.count == points.count else {
            throw NSError(domain: "输入了几个点，输出也应该是几个点", code: -3, userInfo: nil)
        }
        return outputCGPoints
    }
    
    /// 获取计算单应性矩阵
    public
    static
    func calculateHomography() throws -> Mat?{
        // 定义源点和目标点
        let srcPoints: [CGPoint] = [CGPoint(x: 0, y: 0), CGPoint(x: 100, y: 0), CGPoint(x: 100, y: 100), CGPoint(x: 0, y: 100)]
        let dstPoints: [CGPoint] = [CGPoint(x: 10, y: 10), CGPoint(x: 110, y: 10), CGPoint(x: 110, y: 110), CGPoint(x: 10, y: 110)]

        // 将 CGPoint 转换为 OpenCV 的 Mat 格式
        let srcMat:Mat = try cgPointsToMat(srcPoints)
        let dstMat:Mat = try cgPointsToMat(dstPoints)
        
        guard dstPoints.count == srcPoints.count else {
            throw NSError(domain: "输入点与输出点的数量不对", code: -3, userInfo: nil)
        }
        // 计算单应性矩阵
        var homographyMat:Mat?
        
       // let status = findHomography(srcMat, dstMat, &homographyMat, method: .RANSAC, ransacReprojThreshold: 3.0)
        return homographyMat
    }
    
    public
    static
    func getIdentityPerspectiveTransformMatrix() -> Mat {
        // 构造单位透视变换矩阵
        let identityMatrix = Mat(rows: 3, cols: 3, type: CvType.CV_32F)

        // 设置矩阵元素为单位矩阵
        try! identityMatrix.put(row: 0, col: 0, data: [
//            1.0, 0.0, 0.0, // 第一行
//            0.0, 1.0, 0.0, // 第二行
//            0.0, 0.0, 1.0  // 第三行
             
//             -0.230052, -6.28901, 414.084,
//             -0.117509, -5.93065, 503.002,
//             0.000227851, -0.0183749, 1
              
              0.0914144, -5.61273, 394.194,
              0.0583937, -4.90964, 468.117,
              0.000868258, -0.0156872, 1
        ] as [Float])

        return identityMatrix
    }
    
    
    ///假设输入的 Mat 是一个 CV_32FC2 类型的单列矩阵，表示一组二维点
    private
    static
    func matToCGPoints(_ mat: Mat) throws -> [CGPoint] {
        // 检查 Mat 类型是否正确
        guard mat.type() == CvType.CV_32FC2 else {
            throw NSError(domain: "Invalid Mat type", code: -1, userInfo: nil)
        }
        
        // 检查 Mat 的列数是否为 1
        guard mat.cols() == 1 else {
            throw NSError(domain: "Invalid Mat format: expected single column", code: -2, userInfo: nil)
        }
        
        var cgPoints: [CGPoint] = []
        for row in 0..<mat.rows() {
            // 获取一行数据（x 和 y）
            let data = mat.get(row: row, col: 0) // 2 个 float 数字表示 x 和 y
            guard data.count == 2 else {
                throw NSError(domain: "Invalid Mat data", code: -3, userInfo: nil)
            }
            let x = CGFloat(data[0])
            let y = CGFloat(data[1])
            cgPoints.append(CGPoint(x: x, y: y))
        }
        
        return cgPoints
    }
}
