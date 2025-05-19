//
//  DraggableView.swift
//  TestTransformios
//
//  Created by 孟恒 on 2025/5/16.
//

import UIKit

class DraggableView: UIView {
    
    var didMoveView: ((CGPoint) -> Void)?

    // 初始化方法
   override init(frame: CGRect) {
       super.init(frame: frame)
       setupView()
   }
   
   required init?(coder: NSCoder) {
       super.init(coder: coder)
   }
    
    // 设置视图的初始状态
   private func setupView() {

       // 设置背景颜色
       self.backgroundColor = UIColor(red: 91/255.0, green: 204/255.0, blue: 106/255.0, alpha: 1.0)
       self.layer.cornerRadius = 15 / 2
       
       // 添加平移手势识别器
       let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
       self.addGestureRecognizer(panGesture)
   }
    
    // 处理平移手势
     @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
         switch gesture.state {
         case .began, .changed:
             // 获取手势的平移量
             let translation = gesture.translation(in: self.superview)
             // 更新视图的位置
             self.center = CGPoint(
                 x: self.center.x + translation.x,
                 y: self.center.y + translation.y
             )
             // 重置平移量
             gesture.setTranslation(.zero, in: self.superview)
             print("视图的中心\(self.center)")
             didMoveView?(self.center)

         default:
             break
         }
     }

}
