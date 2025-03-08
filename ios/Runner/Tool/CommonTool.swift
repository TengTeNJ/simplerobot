//
//  CommonTool.swift
//  Runner
//
//  Created by 孟恒 on 2025/3/4.
//

import UIKit

class CommonTool: NSObject {
    static func createBtn(_ frame: CGRect,title: String,bgColor: UIColor) -> UIButton {
        let trainbtn = UIButton(type: .custom)
        trainbtn.frame = frame
        trainbtn.setTitle(title, for: .normal)
        trainbtn.setTitleColor(.white, for: .normal)
        trainbtn.backgroundColor = bgColor
//        trainbtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        trainbtn.contentEdgeInsets = UIEdgeInsets(top: 20, left: 17, bottom: 17, right: 14)

        trainbtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
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
    
    
}
