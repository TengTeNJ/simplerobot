//
//  RobotView.swift
//  Runner
//
//  Created by 孟恒 on 2025/3/6.
//

import UIKit

class RobotView: UIView {
    ///原点icon
    lazy var robotIconImageview: UIImageView = {
        let rightImageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 19, height: 13))
        rightImageview.image = UIImage(named: "robot")
         return rightImageview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(robotIconImageview)
        
    }
    
  
}
