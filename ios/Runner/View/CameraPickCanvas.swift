//
//  CameraPickCanvas.swift
//  Runner
//
//  Created by 孟恒 on 2025/3/5.
//

import UIKit
import Flutter

protocol CameraPickCanvasDelegate: AnyObject {
    func CameraPickCanvasDelegate(_ view: CameraPickCanvas, didSendData data: String)
    func ModeSwitchDelegate(_ view: CameraPickCanvas, didSendData data: Int) // 训练模式休息模式切换
    func beginPickBallDelegate(_ view: CameraPickCanvas, didSendData data: Bool) // 开始暂停捡球代理方法
    /// 训练模式 内场外场区域切换
    func trainingModeSwitchAreaDelegate(_ view: CameraPickCanvas, didSendData data: Int)
    /// 原点区域切换代理方法
    func originViewSwitch(_ view: CameraPickCanvas, didSendData data: Int)
}

/// 捡球界面画布view
class CameraPickCanvas: UIView, ModeSwitchViewDelegate, AreaChooseViewDelegate {
    var areaChoose =  AreaChooseView()
    var virtualView = VirtualMapView()
    var actionBtn = UIButton()

    
    func AreaChooseViewDelegate(_ view: AreaChooseView, didSendData data: Int) {
        delegate?.trainingModeSwitchAreaDelegate(self, didSendData: data)
        highlightStartBtn(isHighlight: true)
    }
    
    func ModeSwitchViewDelegate(_ view: ModeSwitchView, didSendData data: Int) {
        delegate?.ModeSwitchDelegate(self, didSendData: data)
        /// 模式切换的时候需要暂停机器人
//        actionBtn.setTitle("Pause", for: .normal)
//        /// 加延时不然机器人第二个指令收不到
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.beginPick(self.actionBtn)
//        }
//        
        // 训练模式如果没有选择区域，捡球按钮置灰，不可点击
        if (areaChoose.areaABtn.backgroundColor == Constants.areaBgColor && areaChoose.areaCBtn.backgroundColor == Constants.areaBgColor) {
            highlightStartBtn(isHighlight: false)

        } else {
            highlightStartBtn(isHighlight: true)
        }
        
        if (data == 99) {
            /// 训练模式
           areaChoose.delegate = self
           self.addSubview(areaChoose) // 两个捡球区域选择View
           self.bringSubviewToFront(cameraImageview)
            self.bringSubviewToFront(topleftImageview)
            self.bringSubviewToFront(bottomRightImageview)
            self.bringSubviewToFront(rightImageview)

           /// 不显示三个导航起点
//            virtualView.rightImageview.isHidden = true
//            virtualView.topleftImageview.isHidden = true
//            virtualView.bottomRightImageview.isHidden = true

        } else { // 休息模式不显示两个捡球区域选择View
            areaChoose.removeFromSuperview()
            highlightStartBtn(isHighlight: true)
        }
    }
    
    /// 高亮捡球开始按钮
    func highlightStartBtn(isHighlight: Bool) {
        actionBtn.backgroundColor =  isHighlight ? Constants.hignBGColor : Constants.disableBGColor
        actionBtn.setTitleColor(isHighlight ?  .white : Constants.disableTextColor, for: .normal)
        actionBtn.isUserInteractionEnabled = isHighlight ? true : false
    }
    
    ///机器人icon
    lazy var robot: RobotView = {
        let robot = RobotView(frame: CGRect(x: 0, y: 0, width: 20, height: 13))
        return robot
    }()
    
    /// 相机
    lazy var cameraImageview: UIImageView = {
        let cameraImageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 23, height: 25))
        cameraImageview.image = UIImage(named: "camera_right_icon")
        return cameraImageview
    }()
    
    
    ///左上角icon
    lazy var topleftImageview: UIImageView = {
        let rightImageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 21, height: 21))
        rightImageview.image = UIImage(named: "orign_icon")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bottomlefthandleTap(_:)))
        rightImageview.addGestureRecognizer(tapGesture)
        rightImageview.isUserInteractionEnabled = true
        return rightImageview
    }()
    
    ///右上角icon
    lazy var rightImageview: UIImageView = {
        let rightImageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 21, height: 21))
        rightImageview.image = UIImage(named: "orign_icon")

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(rightTophandleTap(_:)))
        rightImageview.addGestureRecognizer(tapGesture)
        rightImageview.isUserInteractionEnabled = true
         return rightImageview
    }()
  
    
    ///右下角icon
    lazy var bottomRightImageview: UIImageView = {
        let rightImageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 21, height: 21))
        rightImageview.image = UIImage(named: "orign_icon_highlight")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bottomrighthandleTap(_:)))
        rightImageview.addGestureRecognizer(tapGesture)
        rightImageview.isUserInteractionEnabled = true
        return rightImageview
    }()
    
    @objc func rightTophandleTap(_ gesture: UITapGestureRecognizer) {
        rightImageview.image = UIImage(named: "orign_icon_highlight")
        topleftImageview.image = UIImage(named: "orign_icon")
        bottomRightImageview.image = UIImage(named: "orign_icon")
//        delegate?.beginPickBallDelegate(self, didSendData: Constants.OriginViewType.originViewRightTop.hashValue)
        delegate?.originViewSwitch(self, didSendData: 1)



    }
    
    @objc func bottomlefthandleTap(_ gesture: UITapGestureRecognizer) {
        topleftImageview.image = UIImage(named: "orign_icon_highlight")
        rightImageview.image = UIImage(named: "orign_icon")
        bottomRightImageview.image = UIImage(named: "orign_icon")
        delegate?.originViewSwitch(self, didSendData: 2)

//        delegate?.beginPickBallDelegate(self, didSendData: Constants.OriginViewType.originViewRightTop.hashValue)

    }
    
    @objc func bottomrighthandleTap(_ gesture: UITapGestureRecognizer) {
        bottomRightImageview.image = UIImage(named: "orign_icon_highlight")
        rightImageview.image = UIImage(named: "orign_icon")
        topleftImageview.image = UIImage(named: "orign_icon")
        delegate?.originViewSwitch(self, didSendData: 3)

    }
    
    
    weak var delegate: CameraPickCanvasDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setUpOriginView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置原点view
    private func setUpOriginView() {
        self.addSubview(cameraImageview)
        cameraImageview.center.x = virtualView.center.x;
        cameraImageview.frame.origin.y = 60 + 280 - 21 - cameraImageview.frame.size.height
        
        self.addSubview(topleftImageview)
        topleftImageview.center.x = virtualView.center.x;
        topleftImageview.frame.origin.y = 60 + 21
        
        
        self.addSubview(rightImageview)
        rightImageview.frame.origin.x = 145 + 373 - 21;
        rightImageview.frame.origin.y = 60 + 21
        
       
        self.addSubview(bottomRightImageview)
        bottomRightImageview.frame.origin.x = rightImageview.frame.origin.x;
        bottomRightImageview.frame.origin.y = 60 + 280 - 21 - topleftImageview.frame.size.height
        
    }
    
    private func setupView() {
        let backBtn = CommonTool.createbackImageBtn(CGRect(x: 24, y: 24, width: 36, height: 36), imagenName: "back_icon", bgColor: UIColor(red: 19/255.0, green: 19/255.0, blue: 20/255.0, alpha: 0.8))
        backBtn.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        self.addSubview(backBtn)

        /// 虚拟地图
        virtualView = VirtualMapView(frame: CGRect(x: 82, y: 60, width: 500, height: 280))
        virtualView.isUserInteractionEnabled = true
        self.addSubview(virtualView)
        
        /// 原点view
        

        
        /// 机器人视图
//        self.addSubview(robot)
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        keyWindow!.addSubview(robot)
        
        let cameraState = CameraStateView(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
        self.addSubview(cameraState)
        cameraState.center.x = virtualView.center.x
        cameraState.frame.origin.y = virtualView.frame.origin.y - 4 - 20
        
        
        let modeView = ModeSwitchView()
        modeView.delegate = self
        self.addSubview(modeView)
        
    
        let lebel = UILabel(frame: CGRect(x: 700, y: 64, width: 60, height: 20))
        lebel.text = "Mode"
        lebel.textColor = Constants.disableTextColor
        lebel.font = UIFont(name: "San Francisco Display-Regular", size: 16)

        self.addSubview(lebel)
        
        actionBtn = CommonTool.createBtn(CGRect(x: 664, y: 157, width: 84, height: 84), title: "Start", bgColor: Constants.hignBGColor)
        actionBtn.addTarget(self, action: #selector(beginPick(_:)), for: .touchUpInside)
        self.addSubview(actionBtn)
        
        // 电量视图
        let batteryView = BatteryView()
        self.addSubview(batteryView)
        self.addSubview(createLab(targetVIew: batteryView, text: "Battery"))

        
        
        let caliBtn = CommonTool.createImageBtn(CGRect(x: batteryView.frame.origin.x + 75 + 18, y: 304, width: 36, height: 36), imagenName: "calibration_icon", bgColor: UIColor(red: 19/255.0, green: 19/255.0, blue: 20/255.0, alpha: 0.8))
        caliBtn.setTitle("cali", for: .normal)
        caliBtn.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        self.addSubview(caliBtn)
        self.addSubview(createLab(targetVIew: caliBtn, text: "Calibrate"))


    }
    
    func createLab(targetVIew : UIView,text: String) -> UILabel {
        let batteryLabel = UILabel(frame: CGRectZero)
        batteryLabel.center.x = targetVIew.center.x
        batteryLabel.frame.origin.y = targetVIew.frame.origin.y + targetVIew.bounds.height + 10
        batteryLabel.bounds.size = CGSize(width: 60, height: 15)
        batteryLabel.font = UIFont.systemFont(ofSize: 12)

        batteryLabel.textAlignment = .center
        batteryLabel.text = text
        batteryLabel.textColor = UIColor(red: 156/255.0, green: 156/255.0, blue: 156/255.0, alpha: 1.0)
        return batteryLabel
    }
    
    @objc func calibration(_ sender: UIButton) {
        
    }
    
    @objc func back(_ sender: UIButton) {
        delegate?.CameraPickCanvasDelegate(self, didSendData: sender.titleLabel?.text ?? "")
    }
    
    @objc func beginPick(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        // 震动效果
          let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
          impactFeedbackGenerator.prepare()
          impactFeedbackGenerator.impactOccurred()
        
        if sender.titleLabel?.text == "Start" {
            /// 开始捡球
            print("开始捡球")
            sender.setTitle("Pause", for: .normal)
            delegate?.beginPickBallDelegate(self, didSendData: true)
            virtualView.rightImageview.isHidden = false
            virtualView.topleftImageview.isHidden = false
            virtualView.bottomRightImageview.isHidden = false
        } else {
            /// 暂停捡球
            print("暂停捡球")
            sender.setTitle("Start", for: .normal)
            delegate?.beginPickBallDelegate(self, didSendData: false)
        }
           DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
               sender.isUserInteractionEnabled = true
           }
    }
    
    func ModeSwitchDelegate(_ view: CameraPickCanvas, didSendData data: Int) {
        if data == 99 { // 训练模式
            print("训练模式")
        } else {
            print("休息模式")
        }
    }
    
    // MARK: - 更新机器人位置
    func updateRobotLocation(x: Double,y: Double) {
        robot.center = CGPoint(x: x, y: y)
    }
    
    // MARK: -计算机器人的角度
    func calculateAngleAndDirection(from pointA: CGPoint, to pointB: CGPoint) -> (angle: CGFloat, direction: String) {
        // 计算向量
        let deltaX = pointB.x - pointA.x
        let deltaY = pointB.y - pointA.y
        
        // 计算角度（弧度）
        let angleRadians = atan2(deltaY, deltaX)
        
        // 转换为角度
        let angleDegrees = angleRadians * 180 / .pi
        
        // 确定方向
        let direction: String
        if angleDegrees >= -90 && angleDegrees <= 90 {
            direction = "向右"
        } else {
            direction = "向左"
        }
      //  self.startRotating(view: robot, angle: 2 * M_PI / 360) // 角度需要转成弧度
        return (angleDegrees, direction)
    }

    
    func startRotating(view: UIView,angle: Double) {
        // 更新图标方向
        UIView.animate(withDuration: 0.1) {
            /// 角度为弧度
            view.transform = CGAffineTransform(rotationAngle: angle)
        }
    }

}
