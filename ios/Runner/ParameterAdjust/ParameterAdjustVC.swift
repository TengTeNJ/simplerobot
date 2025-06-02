//
//  ParameterAdjustVC.swift
//  Runner
//
//  Created by 孟恒 on 2025/5/30.
//

import UIKit
import SnapKit

// 参数调节Vc
class ParameterAdjustVC: UIViewController {
    
    lazy var backBtn: UIButton = {
          let backBtn = UIButton(type: .custom)
        backBtn.frame = .zero
        backBtn.backgroundColor = Constants.disableBGColor
        backBtn.layer.cornerRadius = 18;
        backBtn.setImage(UIImage(named: "back_icon"), for: .normal)
        backBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        backBtn.clipsToBounds = true

        return backBtn
      }()
    
    lazy var saveBtn: UIButton = {
        let backBtn = UIButton(type: .custom)
        backBtn.frame = .zero
        backBtn.backgroundColor = Constants.hignBGColor
        backBtn.layer.cornerRadius = 18;
        backBtn.setTitle("Save", for: .normal)
        backBtn.clipsToBounds = true
        backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return backBtn
      }()
    
    lazy var balltypelabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Ball Type"
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)

    
        return label
      }()
    
    @objc func btnAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft // 默认横屏方向
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 28/255.0, green: 29/255.0, blue: 32/255.0, alpha: 1)
        
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(24)
            make.width.equalTo(36)
            make.height.equalTo(36)
         }
        // 调整背景图片的大小
        backBtn.imageView?.snp.makeConstraints { make in
            make.width.equalTo(7) // 设置背景图片的宽度为 7
            make.height.equalTo(14) // 设置背景图片的高度为 14
        }
        
        
        view.addSubview(saveBtn)
        saveBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.width.equalTo(65)
            make.height.equalTo(36)
         }
        
        let adjustViewRollerSpeed = ParameterAdjustView()
        adjustViewRollerSpeed.typeLabel.text = "Roller Speed"
        adjustViewRollerSpeed.numLabel.text = "0.42m/s"
        view.addSubview(adjustViewRollerSpeed)
        adjustViewRollerSpeed.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(55)
            make.top.equalTo(backBtn.snp_bottomMargin).offset(34)
            make.width.equalTo(345)
            make.height.equalTo(91)
        }
        adjustViewRollerSpeed.viewDidChoosed = { [weak self] value in
            if (value == 1) {
                adjustViewRollerSpeed.numLabel.text = "0.42m/s"
            } else {
                adjustViewRollerSpeed.numLabel.text = "0.45m/s"

            }
        }
        
        
        let adjustViewResetGap = ParameterAdjustView()
        adjustViewResetGap.typeLabel.text = "Reset Gap"
        adjustViewResetGap.numLabel.text = "1min"
        view.addSubview(adjustViewResetGap)
        adjustViewResetGap.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-55)
            make.top.equalTo(backBtn.snp_bottomMargin).offset(34)
            make.width.equalTo(345)
            make.height.equalTo(91)
        }
        adjustViewResetGap.viewDidChoosed = { [weak self] value in
            if (value == 1) {
                adjustViewResetGap.numLabel.text = "1min"
            } else {
                adjustViewResetGap.numLabel.text = "3min"

            }
        }
        
        view.addSubview(balltypelabel)
        balltypelabel.snp.makeConstraints { make in
            make.top.equalTo(adjustViewResetGap.snp_bottomMargin).offset(32)
            make.centerX.equalToSuperview()
        }
        
        let balltypeView1 = BallTypeChooseView()
        view.addSubview(balltypeView1)
        balltypeView1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(55)
            make.top.equalTo(balltypelabel.snp_bottomMargin).offset(32)
            make.width.equalTo(226)
            make.height.equalTo(54)
        }
        
        let balltypeView2 = BallTypeChooseView()
        balltypeView2.label.text = "70 kPa"
        view.addSubview(balltypeView2)
        balltypeView2.snp.makeConstraints { make in
            make.left.equalTo(balltypeView1.snp_rightMargin).offset(12)
            make.centerY.equalTo(balltypeView1)
            make.width.equalTo(226)
            make.height.equalTo(54)
        }
        
        let balltypeView3 = BallTypeChooseView()
        balltypeView3.label.text = "75 kPa"
        view.addSubview(balltypeView3)
        balltypeView3.snp.makeConstraints { make in
            make.left.equalTo(balltypeView2.snp_rightMargin).offset(12)
            make.centerY.equalTo(balltypeView1)
            make.width.equalTo(226)
            make.height.equalTo(54)
        }
        
        
    }

}
