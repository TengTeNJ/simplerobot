//
//  SliderView.swift
//  Runner
//
//  Created by 孟恒 on 2025/5/30.
//

import UIKit

let sliderDefalutValue: Float = 1

class SliderView: UIView {
    
    var slider: TrackSlider!
    var textLabel: UILabel!
    
    var didMovedSliderd: ((Int) -> Void)?


    override init(frame: CGRect) {
        super.init(frame: frame)
        
        slider = TrackSlider.init(frame: .zero)
        self.addSubview(slider)
        slider.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(80)
//            make.right.equalToSuperview().offset(-80)
            make.left.right.equalToSuperview()
            make.height.equalTo(10)
            make.centerY.equalToSuperview()
        }
        
        textLabel = UILabel()
        self.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(slider.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        textLabel.font = .systemFont(ofSize: 14, weight: .bold)
        textLabel.textColor = .red
        textLabel.text = String(Int(sliderDefalutValue))
        
        sliderConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sliderConfig() {
        //  最小值
        slider.minimumValue = 1.0
        //  最大值
        slider.maximumValue = 2.0
        //  设置默认值
        slider.setValue(sliderDefalutValue, animated: true)
        //  滑动条有值部分颜色
        slider.minimumTrackTintColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1.0)
        //  滑动条没有值部分颜色
        slider.maximumTrackTintColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1.0)
        //  滑块滑动的值变化触发ValueChanged事件 如果设置为滑动停止才触发则设置为false
        slider.isContinuous = true
        //  响应事件
        slider.addTarget(self, action: #selector(sliderValueChange), for: .valueChanged)
        //  修改控制器图片
        slider.setThumbImage(UIImage(named: "diamond"), for: .normal)
    }
    
    //  MARK: - sliderValueChange
    @objc func sliderValueChange(slider: UISlider) {
        let value = Int(slider.value)
        self.didMovedSliderd?(value)
        textLabel.text = String(value)
    }
}
