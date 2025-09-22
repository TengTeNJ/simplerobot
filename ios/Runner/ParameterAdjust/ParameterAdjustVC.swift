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
    
    let bigMargin = 135.0
    let margin = 10.0
    
    var channel: FlutterMethodChannel
    var binaryMessenger: FlutterBinaryMessenger

    init(binaryMessenger: FlutterBinaryMessenger) {
        self.binaryMessenger = binaryMessenger
        self.channel = FlutterMethodChannel(name: "com.example/native", binaryMessenger: binaryMessenger)
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    lazy var balltypelabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = Strings.ballType
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
      }()
    
    @objc func btnAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft // 默认横屏方向
    }
    
    func feedback() {
        // 创建震动效果
       let generator = UIImpactFeedbackGenerator(style: .medium)
       generator.impactOccurred()
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
        
        let adjustViewRollerSpeed = ParameterAdjustView()
        adjustViewRollerSpeed.typeLabel.text = Strings.rollerSpeed
        adjustViewRollerSpeed.numLabel.text = "0.42m/s"
        view.addSubview(adjustViewRollerSpeed)
        adjustViewRollerSpeed.sliderDefalutValue = 2.0
        adjustViewRollerSpeed.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(135)
            make.top.equalTo(backBtn.snp_bottomMargin).offset(34)
            make.width.equalTo(540)
            make.height.equalTo(91)
        }
        adjustViewRollerSpeed.viewDidChoosed = { [weak self] value in
            print("滑竿的值\(value)")
            if (value == 1) {
                adjustViewRollerSpeed.numLabel.text = "0.42m/s"
                self?.channel.invokeMethod("changeRobotSpeed", arguments: true)
                UserDefaults.standard.set(1, forKey: "flutter.robotSpeedData")
             } else {
                adjustViewRollerSpeed.numLabel.text = "0.45m/s"
                self?.channel.invokeMethod("changeRobotSpeed", arguments: false)
                UserDefaults.standard.set(2, forKey: "flutter.robotSpeedData")
            }
            self?.feedback()
        }
        
        // 读取 Flutter 保存的数据 Roller speed
        let rollerSpeedvalue = UserDefaults.standard.integer(forKey: "flutter.robotSpeedData") as? Int ?? 1
        
        if (rollerSpeedvalue == 1) { // 1min
            adjustViewRollerSpeed.sliderDefalutValue = 1
            adjustViewRollerSpeed.numLabel.text = "0.42m/s"

            
        } else if(rollerSpeedvalue == 2) { // 3min
            adjustViewRollerSpeed.sliderDefalutValue = 2
            adjustViewRollerSpeed.numLabel.text = "0.45m/s"

         }
        
        view.addSubview(balltypelabel)
        balltypelabel.snp.makeConstraints { make in
          make.top.equalTo(adjustViewRollerSpeed.snp_bottomMargin).offset(32)
          make.centerX.equalToSuperview()
        }
        
        
        let ballTypeWidth = (Constants.ScreenWidth - bigMargin * 2 - margin * 2)/3.0
        
        let balltypeView1 = BallTypeChooseView()
        view.addSubview(balltypeView1)
        balltypeView1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(135)
            make.top.equalTo(balltypelabel.snp_bottomMargin).offset(32)
            make.width.equalTo(ballTypeWidth)
            make.height.equalTo(54)
        }
        
        let balltypeView2 = BallTypeChooseView()
        balltypeView2.label.text = "70 kPa"
        view.addSubview(balltypeView2)
        balltypeView2.snp.makeConstraints { make in
            make.left.equalTo(balltypeView1.snp_rightMargin).offset(12)
            make.centerY.equalTo(balltypeView1)
            make.width.equalTo(ballTypeWidth)
            make.height.equalTo(54)
        }
        
        let balltypeView3 = BallTypeChooseView()
        balltypeView3.label.text = "75 kPa"
        view.addSubview(balltypeView3)
        balltypeView3.snp.makeConstraints { make in
            make.left.equalTo(balltypeView2.snp_rightMargin).offset(12)
            make.centerY.equalTo(balltypeView1)
            make.width.equalTo(ballTypeWidth)
            make.height.equalTo(54)
        }
        
        // 读取 Flutter 保存的数据 ballTypeData
        let ballTypevalue = UserDefaults.standard.integer(forKey: "flutter.ballTypeData") as? Int ?? 1
        if (ballTypevalue == 1) {
            balltypeView1.isSelected = true
        } else if(ballTypevalue == 2) {
            balltypeView2.isSelected = true
        } else {
            balltypeView3.isSelected = true

        }
        
 
        
        balltypeView1.didSelected = { [weak self] value in
            balltypeView2.isSelected = false
            balltypeView3.isSelected = false
            UserDefaults.standard.set(1, forKey: "flutter.ballTypeData")
            self?.channel.invokeMethod("changeRobotBallType", arguments: "1")
        }
        
        balltypeView2.didSelected = { [weak self] value in
            balltypeView1.isSelected = false
            balltypeView3.isSelected = false
            UserDefaults.standard.set(2, forKey: "flutter.ballTypeData")
            self?.channel.invokeMethod("changeRobotBallType", arguments: "2")


        }
        balltypeView3.didSelected = { [weak self] value in
            balltypeView1.isSelected = false
            balltypeView2.isSelected = false
            UserDefaults.standard.set(3, forKey: "flutter.ballTypeData")
            self?.channel.invokeMethod("changeRobotBallType", arguments: "3")
       }
        
        
    }

}
