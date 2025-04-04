//
//  CommonTool.swift
//  Runner
//
//  Created by 孟恒 on 2025/3/4.
//

import UIKit
import Vision
import opencv2

class CommonTool: NSObject {
    static func createBtn(_ frame: CGRect,title: String,bgColor: UIColor) -> UIButton {
        let trainbtn = UIButton(type: .custom)
        trainbtn.frame = frame
        trainbtn.setTitle(title, for: .normal)
        trainbtn.setTitleColor(.white, for: .normal)
        trainbtn.backgroundColor = bgColor
//        trainbtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        trainbtn.contentEdgeInsets = UIEdgeInsets(top: 20, left: 17, bottom: 17, right: 14)

        trainbtn.titleLabel?.font = UIFont(name: "San Francisco Display-Regular", size: 18)
        
        trainbtn.clipsToBounds = true
        trainbtn.layer.cornerRadius = frame.size.width / 2
        return trainbtn
    }
    
    static func createImageBtn(_ frame: CGRect,imagenName: String,bgColor: UIColor) -> UIButton {
        let trainbtn = UIButton(type: .custom)
        trainbtn.frame = frame
        trainbtn.setImage(UIImage(named: imagenName), for: .normal)
        trainbtn.setTitleColor(.white, for: .normal)
        trainbtn.backgroundColor = bgColor
//        trainbtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        trainbtn.contentEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)

        trainbtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        trainbtn.clipsToBounds = true
        trainbtn.layer.cornerRadius = frame.size.width / 2
        return trainbtn
    }
    
    static func createbackImageBtn(_ frame: CGRect,imagenName: String,bgColor: UIColor) -> UIButton {
        let trainbtn = UIButton(type: .custom)
        trainbtn.frame = frame
        trainbtn.setImage(UIImage(named: imagenName), for: .normal)
        trainbtn.setTitleColor(.white, for: .normal)
        trainbtn.backgroundColor = bgColor
//        trainbtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        trainbtn.contentEdgeInsets = UIEdgeInsets(top: 12, left: 14, bottom: 12, right: 14)

        trainbtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        trainbtn.clipsToBounds = true
        trainbtn.layer.cornerRadius = frame.size.width / 2
        return trainbtn
    }
    
    static func createVIew(_ frame: CGRect) -> UIView {
        let point2 = UIView(frame: frame)
        point2.backgroundColor = UIColor(red: 91/255.0, green: 204/255.0, blue: 106/255.0, alpha: 1.0)
        point2.layer.cornerRadius = 5 / 2

        return point2
    }
    
    /// 计算矩形的坐标
    static func tranferRectangle(point1: CGPoint ,point2: CGPoint,point3: CGPoint,point4: CGPoint) {
        let leftTopPointx = min(min(min(point1.x, point2.x), point3.x), point4.x)
        let leftTopPointy = min(min(min(point1.y, point2.y), point3.y), point4.y)

        let rightTopPointx = max(max(max(point1.x, point2.x), point3.x), point4.x)
        let rightTopPointy = min(min(min(point1.x, point2.x), point3.x), point4.x)
        
        let rightBottomPointx = max(max(max(point1.x, point2.x), point3.x), point4.x)
        let rightBottomPointy = max(max(max(point1.x, point2.x), point3.x), point4.x)
        
        let leftBottomPointx = min(min(min(point1.x, point2.x), point3.x), point4.x)
        let righBottomPointy = max(max(max(point1.x, point2.x), point3.x), point4.x)
        print("\(leftTopPointx)--\(leftTopPointy)\n\(rightTopPointx)--\(rightTopPointy)\n\(rightBottomPointx)--\(rightBottomPointy)\n\(leftBottomPointx)--\(righBottomPointy)")
    }
    
    // 计算两个坐标点之间的距离
    static func calculateDistance(point1: CGPoint, point2: CGPoint) -> CGFloat {
        let deltaX = point2.x - point1.x
        let deltaY = point2.y - point1.y
        return sqrt(deltaX * deltaX + deltaY * deltaY)
    }
    
    /// 判定一个点的坐标是否在四边形内
    static func isPointInsideQuadrilateral(point: CGPoint, quadrilateralPoints: [CGPoint]) -> Bool {
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

    
    // 计算透视变换矩阵
//    static func calculatePerspectiveTransform(from srcPoints: [CGPoint], to dstPoints: [CGPoint]) -> CGAffineTransform? {
//        guard srcPoints.count == 4, dstPoints.count == 4 else {
//            print("Invalid number of points. Need exactly 4 points.")
//            return nil
//        }
//        
//        // 使用 Vision 框架计算透视变换矩阵
//        let src = srcPoints.map { VNImagePointForNormalizedPoint($0, 1, 1) }
//        let dst = dstPoints.map { VNImagePointForNormalizedPoint($0, 1, 1) }
//        
//        guard let transform = VNImageHomographicAlignmentObservation(requestedTransform: VNImageHomographicAlignmentObservation(srcPoints: src, dstPoints: dst))?.transform else {
//              print("Failed to calculate homography.")
//              return nil
//          }
//          
//        
//        return CGAffineTransform(a: transform.a, b: transform.b, c: transform.c, d: transform.d, tx: transform.tx, ty: transform.ty)
//    }
//    
    // 应用透视变换
    static func applyTransform(_ transform: CGAffineTransform, to point: CGPoint) -> CGPoint {
        return point.applying(transform)
    }
    
    /// 计算两个时间的时间差
    public
    static
    func calculateTimeStamp(lastDate:Date ,currentDate:Date) -> Int{
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: lastDate, to: currentDate)
        //print("时间差（秒）: \(components.second ?? 0)")
        return components.second ?? 0
        
    }

}
