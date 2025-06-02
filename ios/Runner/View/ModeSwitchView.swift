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

    let widgetWidth = 60.0
    let widgetHeight = 30.0
    let margin = 3.0

    lazy var Abtn: UIButton = {
        let trainbtn = UIButton(type: .custom)
        trainbtn.frame = CGRect(x: 3, y: 3, width: widgetWidth, height: widgetHeight)
        trainbtn.setTitle("ZoneA", for: .normal)
        //trainbtn.setTitleColor(.white, for: .selected)
        trainbtn.setTitleColor(.white, for: .normal)
        trainbtn.backgroundColor = Constants.areaBtnSelectedColor
        trainbtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        trainbtn.contentEdgeInsets = UIEdgeInsets(top: 20, left: 7, bottom: 17, right: 7)
        trainbtn.layer.cornerRadius = widgetHeight / 2
        trainbtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        trainbtn.tag = 99;
        trainbtn.clipsToBounds = true
        
        // 设置文字居中
        trainbtn.contentHorizontalAlignment = .center
        trainbtn.contentVerticalAlignment = .center
               
        return trainbtn
    }()
    
    
    lazy var Bbtn: UIButton = {
        let restbtn = UIButton(type: .custom)
        restbtn.frame = CGRect(x: self.bounds.width - 2*widgetWidth - margin*3, y: 3, width: widgetWidth, height: widgetHeight)
        restbtn.backgroundColor = Constants.areaBtnColor
        restbtn.setTitle("ZoneB", for: .normal)
        restbtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        restbtn.tag = 100;

        restbtn.setTitleColor(UIColor(red: 156/255.0, green: 156/255.0, blue: 156/255.0, alpha: 1.0), for: .normal)
        restbtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        restbtn.contentEdgeInsets = UIEdgeInsets(top: 20, left: 7, bottom: 17, right: 7)
        restbtn.layer.cornerRadius = widgetHeight / 2
        restbtn.clipsToBounds = true
        return restbtn
    }()
    
    lazy var restbtn: UIButton = {
        let restbtn = UIButton(type: .custom)
        restbtn.frame = CGRect(x: self.bounds.width - widgetWidth - 4*2, y: 3, width: widgetWidth, height: widgetHeight)
        restbtn.backgroundColor = Constants.areaBtnColor
        restbtn.setTitle("ZoneC", for: .normal)
        restbtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        restbtn.tag = 101;

        restbtn.setTitleColor(UIColor(red: 156/255.0, green: 156/255.0, blue: 156/255.0, alpha: 1.0), for: .normal)
        restbtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        restbtn.contentEdgeInsets = UIEdgeInsets(top: 20, left: 7, bottom: 17, right: 7)
        restbtn.layer.cornerRadius = widgetHeight / 2
        restbtn.clipsToBounds = true
        return restbtn
    }()
    
    

    
    // MARK: - 按钮点击事件处理
       @objc func btnAction(_ sender: UIButton) {
           delegate?.ModeSwitchViewDelegate(self, didSendData: sender.tag)
           if  (sender.tag == 100) {
               Bbtn.setTitleColor(.white, for: .normal)
               Bbtn.backgroundColor = Constants.areaBtnSelectedColor
               
               Abtn.setTitleColor(UIColor(red: 156/255.0, green: 156/255.0, blue: 156/255.0, alpha: 1.0), for: .normal)
               Abtn.backgroundColor = Constants.areaBtnColor
               
               restbtn.backgroundColor = Constants.areaBtnColor
               restbtn.setTitleColor(UIColor(red: 156/255.0, green: 156/255.0, blue: 156/255.0, alpha: 1.0), for: .normal)


           } else if(sender.tag == 99){
               Abtn.setTitleColor(.white, for: .normal)
               Abtn.backgroundColor = Constants.areaBtnSelectedColor
               
               restbtn.setTitleColor(UIColor(red: 156/255.0, green: 156/255.0, blue: 156/255.0, alpha: 1.0), for: .normal)
               restbtn.backgroundColor = Constants.areaBtnColor
               
               Bbtn.backgroundColor = Constants.areaBtnColor
               Bbtn.setTitleColor(UIColor(red: 156/255.0, green: 156/255.0, blue: 156/255.0, alpha: 1.0), for: .normal)

               
           } else {
               restbtn.setTitleColor(.white, for: .normal)
               restbtn.backgroundColor = Constants.areaBtnSelectedColor
               
               Bbtn.setTitleColor(UIColor(red: 156/255.0, green: 156/255.0, blue: 156/255.0, alpha: 1.0), for: .normal)
               Bbtn.backgroundColor = Constants.areaBtnColor
               
               Abtn.backgroundColor = Constants.areaBtnColor
               Abtn.setTitleColor(UIColor(red: 156/255.0, green: 156/255.0, blue: 156/255.0, alpha: 1.0), for: .normal)
               
           }
           sender.isSelected = !sender.isSelected
       }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.frame = CGRect(x: UIScreen.main.bounds.width - widgetWidth*3 - 4*margin - 36, y: 24, width: widgetWidth*3 + 4*margin, height: 36)
        self.backgroundColor = UIColor(red: 19/255.0, green: 19/255.0, blue: 20/255.0, alpha: 1.0)
        self.layer.cornerRadius = 18
        
        self.addSubview(Abtn)
        self.addSubview(restbtn)
        self.addSubview(Bbtn)

        
    }
   
    
}
