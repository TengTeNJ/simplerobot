//
//  BallTypeChooseView.swift
//  Runner
//
//  Created by 孟恒 on 2025/5/31.
//

import UIKit

class BallTypeChooseView: UIView {
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    lazy var iconImageVIew: UIImageView = {
        let iconImageVIew = UIImageView()
        iconImageVIew.image = UIImage(named: "ball_icon_gray")
        return iconImageVIew
      }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "65 kPa"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
      }()
    
    lazy var choosebtn: UIButton = {
        let choosebtn = UIButton(type: .custom)
        choosebtn.setBackgroundImage(UIImage(named: "icon_normal"), for: .normal)
        choosebtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)

        choosebtn.setBackgroundImage(UIImage(named: "icon_highlight"), for: .highlighted)
        return choosebtn
    }()
    
    @objc func btnAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.setBackgroundImage(UIImage(named: "icon_highlight"), for: .normal)
            iconImageVIew.image = UIImage(named: "ball_icon")
        } else {
            sender.setBackgroundImage(UIImage(named: "icon_normal"), for: .normal)
            iconImageVIew.image = UIImage(named: "ball_icon_gray")
        }
     }
    
    private func setupView() {
        self.backgroundColor = UIColor(red: 39/255.0, green: 41/255.0, blue: 51/255.0, alpha: 1.0)
        addSubview(iconImageVIew)
        addSubview(label)
        addSubview(choosebtn)
       
        iconImageVIew.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 32, height: 32))
        }
        
        label.snp.makeConstraints { make in
            make.left.equalTo(iconImageVIew.snp_rightMargin).offset(13)
            make.centerY.equalToSuperview()
            
        }
        
        choosebtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 24, height: 24))

            
        }
    }
  

}
