//
//  VirtualMapView.swift
//  Runner
//
//  Created by 孟恒 on 2025/3/3.
//

import UIKit

/// 虚拟地图
class VirtualMapView: UIView {
    
    /// 相机
    lazy var cameraImageview: UIImageView = {
        let cameraImageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 23, height: 25))
        cameraImageview.image = UIImage(named: "camera_icon")
        return cameraImageview
    }()
    
    ///原点icon
    lazy var rightImageview: UIImageView = {
        let rightImageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 21, height: 21))
        rightImageview.image = UIImage(named: "orign_icon")
         return rightImageview
    }()
    
    ///原点icon
    lazy var bottomleftImageview: UIImageView = {
        let rightImageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 21, height: 21))
        rightImageview.image = UIImage(named: "orign_icon")
         return rightImageview
    }()
    
    ///原点icon
    lazy var bottomRightImageview: UIImageView = {
        let rightImageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 21, height: 21))
        rightImageview.image = UIImage(named: "orign_icon_highlight")
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
        self.backgroundColor = UIColor(red: 28/255.0, green: 29/255.0, blue: 32/255.0, alpha: 0.85)
        
        let bgOuterImageView = UIImageView(frame: self.bounds)
        bgOuterImageView.image = UIImage(named: "outer_court")
        self.addSubview(bgOuterImageView)
        
        let innerImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 334, height: 214))
        innerImageView.image = UIImage(named: "inner_court")
        innerImageView.center = bgOuterImageView.center
        bgOuterImageView.addSubview(innerImageView)
        
        bgOuterImageView.addSubview(cameraImageview)
        cameraImageview.center.x = bgOuterImageView.center.x;
        cameraImageview.frame.origin.y = bgOuterImageView.frame.origin.y + 5
        
        bgOuterImageView.addSubview(rightImageview)
        rightImageview.frame.origin.x = innerImageView.frame.origin.x + 334;
        rightImageview.frame.origin.y = bgOuterImageView.frame.origin.y + 5
        
        bgOuterImageView.addSubview(bottomleftImageview)
        bottomleftImageview.center.x = bgOuterImageView.center.x;
        bottomleftImageview.frame.origin.y = bgOuterImageView.frame.origin.y + bgOuterImageView.frame.size.height - 7 - bottomleftImageview.frame.size.height
        
        bgOuterImageView.addSubview(bottomRightImageview)
        bottomRightImageview.frame.origin.x = rightImageview.frame.origin.x;
        bottomRightImageview.frame.origin.y = bgOuterImageView.frame.origin.y + bgOuterImageView.frame.size.height - 7 - bottomleftImageview.frame.size.height

        
    }
       
}
