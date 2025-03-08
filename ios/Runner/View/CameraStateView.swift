//
//  CameraStateView.swift
//  Runner
//
//  Created by 孟恒 on 2025/3/5.
//

import UIKit

class CameraStateView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
               
      
        
        let img = UIImageView(image: UIImage(named: ""))
        img.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
        img.backgroundColor = UIColor(red: 194/255.0, green: 35/255.0, blue: 38/255.0, alpha: 1.0)
        img.layer.cornerRadius = 2.5
        img.clipsToBounds = true
        addSubview(img)
        img.center.y = self.center.y
        
        let lab = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
        lab.textColor = .white
        lab.frame.origin.x = img.frame.origin.y + 7
        img.center.y = img.center.y
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.text = "Camera on"
        addSubview(lab)

    }

}
