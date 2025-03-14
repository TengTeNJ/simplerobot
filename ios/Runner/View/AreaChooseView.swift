//
//  AreaChooseView.swift
//  Runner
//
//  Created by 孟恒 on 2025/3/4.
//

import UIKit

/// 区域选择view
class AreaChooseView: UIView {
    let widgetWidthHorizontal = 119
    let widgetHeightHorizontal = 26
    
    let widgetWidthVertical = 54
    let widgetHeightVertical = 266


    let margin = 4
    
    let bgColor = UIColor(red: 27/255.0, green: 66/255.0, blue: 197/255.0, alpha: 0.75)
    let bgSelectedColor = UIColor(red: 25/255.0, green: 243/255.0, blue: 134/255.0, alpha: 0.75)
    
    var leftSelected = false;
    var topSelected = false;
    var rightSelected = false;
    var bottomSelected = false;

    lazy var areaABtn: UIButton = {
          let trainbtn = UIButton(type: .custom)
          trainbtn.frame = CGRect(x: 0, y: 0, width: 79, height: widgetHeightVertical)
          trainbtn.backgroundColor = bgColor
          trainbtn.layer.cornerRadius = 4;
          trainbtn.tag = 10
          trainbtn.clipsToBounds = true
          trainbtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
          return trainbtn
      }()
          
    lazy var areaCBtn: UIButton = {
          let trainbtn = UIButton(type: .custom)
        trainbtn.frame = CGRect(x: widgetWidthHorizontal + widgetWidthVertical + 2 * margin, y: 0, width: widgetWidthVertical, height: widgetHeightVertical)
          trainbtn.backgroundColor = bgColor
        trainbtn.layer.cornerRadius = 4;
        trainbtn.tag = 12

        trainbtn.clipsToBounds = true
          trainbtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
          return trainbtn
      }()
      
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.frame = CGRect(x: 344, y: 66 , width: widgetWidthVertical*2 + 2*margin + widgetWidthHorizontal +  25, height: widgetHeightVertical)
        self.addSubview(areaABtn)
        self.addSubview(areaCBtn)

    }
    
    // MARK: - 按钮点击事件处理
       @objc func btnAction(_ sender: UIButton) {
           if (sender.tag == 10 && areaCBtn.backgroundColor != bgSelectedColor) {
               areaABtn.backgroundColor = bgSelectedColor
           }
           
           if (sender.tag == 12 && areaABtn.backgroundColor != bgSelectedColor) {
               areaCBtn.backgroundColor = bgSelectedColor
           }

       }
    
 
}
