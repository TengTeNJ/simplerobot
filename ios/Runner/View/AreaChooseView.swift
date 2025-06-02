//
//  AreaChooseView.swift
//  Runner
//
//  Created by 孟恒 on 2025/3/4.
//

import UIKit

protocol AreaChooseViewDelegate: AnyObject {
    func AreaChooseViewDelegate(_ view: AreaChooseView, didSendData data: Int)
}

/// 区域选择view
class AreaChooseView: UIView {
    weak var delegate: AreaChooseViewDelegate?
    
    let margin = 4
   
    lazy var areaABtn: UIButton = {
          let trainbtn = UIButton(type: .custom)
          trainbtn.frame = CGRect(x: 0, y: 0, width: Constants.ElectronicFence.infieldWidth, height: Constants.ElectronicFence.infieldOutfieldHeight)
          trainbtn.backgroundColor = Constants.areaBgSelectedColor
          trainbtn.layer.cornerRadius = 4;
          trainbtn.tag = 10
          trainbtn.clipsToBounds = true
          trainbtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
          return trainbtn
      }()
          
    lazy var areaCBtn: UIButton = {
          let trainbtn = UIButton(type: .custom)
        trainbtn.frame = CGRect(x: Constants.ElectronicFence.infieldWidth + 99, y: 0, width: Constants.ElectronicFence.outfieldWidth, height: Constants.ElectronicFence.infieldOutfieldHeight)
        trainbtn.backgroundColor = Constants.areaBgSelectedColor
        trainbtn.layer.cornerRadius = 4;
        trainbtn.tag = 12

        trainbtn.clipsToBounds = true
          trainbtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
          return trainbtn
      }()
    
    
    lazy var areaBigABtn: UIButton = {
          let trainbtn = UIButton(type: .custom)
        trainbtn.frame = CGRect(x: 0, y: 0, width: 239, height: Constants.ElectronicFence.infieldOutfieldHeight)
        trainbtn.backgroundColor = Constants.areaBgSelectedColor
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
        self.frame = CGRect(x: 334, y: 66 , width: Constants.ElectronicFence.infieldWidth +  Constants.ElectronicFence.outfieldWidth + 99, height: Constants.ElectronicFence.infieldOutfieldHeight)
        self.addSubview(areaABtn)
        self.addSubview(areaCBtn)
        self.addSubview(areaBigABtn)

    }
    
    // MARK: - 按钮点击事件处理
       @objc func btnAction(_ sender: UIButton) {
           delegate?.AreaChooseViewDelegate(self, didSendData: sender.tag)
//          if (sender.tag == 10) {
//               areaABtn.backgroundColor = Constants.areaBgSelectedColor
//               areaCBtn.backgroundColor = Constants.areaBgColor
//           }
//           
//           if (sender.tag == 12 ) {
//               areaCBtn.backgroundColor = Constants.areaBgSelectedColor
//               areaABtn.backgroundColor = Constants.areaBgColor
//            }
       }
}
