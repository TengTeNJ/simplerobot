//
//  ModeSwitchView.swift
//  Runner
//
//  Created by 孟恒 on 2025/3/4.
//

import UIKit

protocol ModeSwitchViewDelegate: AnyObject {
    func ModeSwitchViewDelegate(_ view: ModeSwitchView, didSendData data: Int)
}


/// 模式切换view
class ModeSwitchView: UIView {
    
    weak var delegate: ModeSwitchViewDelegate?

    let widgetWidth = 80.0
    let widgetHeight = 28.0
    let margin = 6.0

    lazy var trainbtn: UIButton = {
        let trainbtn = UIButton(type: .custom)
        trainbtn.frame = CGRect(x: 6, y: 4, width: widgetWidth, height: widgetHeight)
        trainbtn.setTitle("Training", for: .normal)
        //trainbtn.setTitleColor(.white, for: .selected)
        trainbtn.setTitleColor(UIColor(red: 156/255.0, green: 156/255.0, blue: 156/255.0, alpha: 1.0), for: .normal)
        trainbtn.backgroundColor = UIColor(red: 19/255.0, green: 19/255.0, blue: 20/255.0, alpha: 1.0)
        trainbtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        trainbtn.contentEdgeInsets = UIEdgeInsets(top: 20, left: 17, bottom: 17, right: 14)
        trainbtn.layer.cornerRadius = widgetHeight / 2
        trainbtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        trainbtn.tag = 99;
        trainbtn.clipsToBounds = true
        return trainbtn
    }()
    
    lazy var restbtn: UIButton = {
        let restbtn = UIButton(type: .custom)
        restbtn.frame = CGRect(x: self.bounds.width - widgetWidth - 4*2, y: 4, width: widgetWidth, height: widgetHeight)
              
        restbtn.backgroundColor = UIColor(red: 49/255.0, green: 52/255.0, blue: 67/255.0, alpha: 1.0)
        restbtn.setTitle("Rest", for: .normal)
        restbtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        restbtn.tag = 100;

        restbtn.setTitleColor(.white, for: .normal)
        restbtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        restbtn.contentEdgeInsets = UIEdgeInsets(top: 20, left: 17, bottom: 17, right: 14)
        restbtn.layer.cornerRadius = widgetHeight / 2
        restbtn.clipsToBounds = true
        return restbtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.frame = CGRect(x: UIScreen.main.bounds.width - widgetWidth*2 - 3*margin - 36, y: 24, width: widgetWidth*2 + 3*margin, height: 36)
        self.backgroundColor = UIColor(red: 19/255.0, green: 19/255.0, blue: 20/255.0, alpha: 1.0)
        self.layer.cornerRadius = 18
        
        self.addSubview(trainbtn)
        self.addSubview(restbtn)
        
    }
    
    // MARK: - 按钮点击事件处理
       @objc func btnAction(_ sender: UIButton) {
           delegate?.ModeSwitchViewDelegate(self, didSendData: sender.tag)
           if  (sender.tag == 100) {
               restbtn.setTitleColor(.white, for: .normal)
               restbtn.backgroundColor = UIColor(red: 49/255.0, green: 52/255.0, blue: 67/255.0, alpha: 1.0)
               
               //trainbtn.setTitleColor(.white, for: .selected)
               trainbtn.setTitleColor(UIColor(red: 156/255.0, green: 156/255.0, blue: 156/255.0, alpha: 1.0), for: .normal)
               trainbtn.backgroundColor = UIColor(red: 19/255.0, green: 19/255.0, blue: 20/255.0, alpha: 1.0)

           } else {
               trainbtn.setTitleColor(.white, for: .normal)
               trainbtn.backgroundColor = UIColor(red: 49/255.0, green: 52/255.0, blue: 67/255.0, alpha: 1.0)
               
               restbtn.setTitleColor(UIColor(red: 156/255.0, green: 156/255.0, blue: 156/255.0, alpha: 1.0), for: .normal)
               restbtn.backgroundColor = UIColor(red: 19/255.0, green: 19/255.0, blue: 20/255.0, alpha: 1.0)
               
           }
           sender.isSelected = !sender.isSelected
       }
    
}
