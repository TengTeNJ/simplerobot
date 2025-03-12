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
    func ModeSwitchDelegate(_ view: CameraPickCanvas, didSendData data: Int)
    func beginPickBallDelegate(_ view: CameraPickCanvas, didSendData data: Bool)
    
}

/// 捡球界面画布view
class CameraPickCanvas: UIView, ModeSwitchViewDelegate {
    
    func ModeSwitchViewDelegate(_ view: ModeSwitchView, didSendData data: Int) {
        delegate?.ModeSwitchDelegate(self, didSendData: data)
        if (data == 99) {
            let area = AreaChooseView() // 四个捡球区域选择View
            self.addSubview(area)
        }
    }
    
    ///原点icon
    lazy var robot: RobotView = {
        let robot = RobotView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        return robot
    }()
    
    weak var delegate: CameraPickCanvasDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let backBtn = CommonTool.createbackImageBtn(CGRect(x: 24, y: 24, width: 36, height: 36), imagenName: "back_icon", bgColor: UIColor(red: 19/255.0, green: 19/255.0, blue: 20/255.0, alpha: 0.8))
        backBtn.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        self.addSubview(backBtn)

        /// 虚拟地图
        let virtualView = VirtualMapView(frame: CGRect(x: 82, y: 60, width: 500, height: 280))
        self.addSubview(virtualView)
        
        /// 机器人视图
        self.addSubview(robot)
        
        let cameraState = CameraStateView(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
        self.addSubview(cameraState)
        cameraState.center.x = virtualView.center.x
        cameraState.frame.origin.y = virtualView.frame.origin.y - 4 - 20
        
        
        let modeView = ModeSwitchView()
        modeView.delegate = self
        self.addSubview(modeView)
        
    
        let lebel = UILabel(frame: CGRect(x: 700, y: 64, width: 60, height: 20))
        lebel.text = "Mode"
        lebel.textColor = UIColor(red: 156/255.0, green: 156/255.0, blue: 156/255.0, alpha: 1.0)
        self.addSubview(lebel)
        
        let actionBtn = CommonTool.createBtn(CGRect(x: 664, y: 157, width: 84, height: 84), title: "Start", bgColor: UIColor(red: 233/255.0, green: 100/255.0, blue: 21/255.0, alpha: 1.0))
        actionBtn.addTarget(self, action: #selector(beginPick(_:)), for: .touchUpInside)
        self.addSubview(actionBtn)
        
        let batteryView = BatteryView()
        self.addSubview(batteryView)
        
        let caliBtn = CommonTool.createImageBtn(CGRect(x: batteryView.frame.origin.x + 75 + 18, y: 304, width: 36, height: 36), imagenName: "calibration_icon", bgColor: UIColor(red: 19/255.0, green: 19/255.0, blue: 20/255.0, alpha: 0.8))
        //caliBtn.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        self.addSubview(caliBtn)

    }
    
    @objc func back(_ sender: UIButton) {
        delegate?.CameraPickCanvasDelegate(self, didSendData: "")
    }
    
    @objc func beginPick(_ sender: UIButton) {
        delegate?.beginPickBallDelegate(self, didSendData: true)
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
        robot.frame.origin.x = x
        robot.frame.origin.y = y

    }
    
    // MARK: -计算机器人的角度
    func calculateRobotAngle(lastPoint: CGPoint, currentPoint: CGPoint) -> Double {
        let deltaX = currentPoint.x - lastPoint.x
        let deltaY = currentPoint.y - lastPoint.y
        let angleInRadians = atan2(deltaY, deltaX)
        let angleInDegrees = angleInRadians * (180 / Double.pi)
        print("机器人的角度\(angleInDegrees)")
        UIView.animate(withDuration: 0.1) {
            
            self.robot.transform = self.robot.transform.rotated(by: 2*CGFloat.pi * angleInDegrees / 360) 
        }
        return angleInDegrees
    }

}
