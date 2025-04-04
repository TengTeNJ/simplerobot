//
//  BatteryView.swift
//  Runner
//
//  Created by 孟恒 on 2025/3/4.
//

import UIKit

class BatteryView: UIView {
    var batteryLab =  UILabel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 注册通知监听器
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name(Constants.Notification_Battery), object: nil)
        setupView()
    }
    
    @objc func handleNotification(_ notification: Notification) {
            // 获取通知中传递的数据
            if let userInfo = notification.userInfo,
               let message = userInfo["message"] as? String {
                batteryLab.text = "\(message)%"
            }
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
       
        self.frame = CGRect(x: 658, y: 304 , width: 75 , height: 36)
       
        self.backgroundColor = UIColor(red: 19/255.0, green: 19/255.0, blue: 20/255.0, alpha: 0.8)
        self.layer.cornerRadius = 18
        
        let img = UIImageView(image: UIImage(named: "camera_battery"))
        img.frame = CGRect(x: 12, y: 10, width: 10, height: 15)
        addSubview(img)
        
        batteryLab = UILabel(frame: CGRect(x: 27, y: 0, width: 40, height: 36))
        batteryLab.textColor = .white
        batteryLab.text = "98%"
        addSubview(batteryLab)

    }

}
