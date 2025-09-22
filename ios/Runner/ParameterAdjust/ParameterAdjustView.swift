//
//  ParameterAdjustView.swift
//  Runner
//
//  Created by 孟恒 on 2025/5/30.
//

import UIKit
import SnapKit

class ParameterAdjustView: UIView {
    
    var viewDidChoosed: ((Int) -> Void)?
    

    var sliderDefalutValue: Float = 1 {
           didSet {
               sliderView.sliderDefalutValue = sliderDefalutValue
          }
    }
    
    var sliderView = SliderView()
    
    
    lazy var typeLabel: UILabel = {
        let typeLabel = UILabel()
        typeLabel.textColor = .white
        typeLabel.text = Strings.rollerSpeed
        typeLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return typeLabel
      }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textColor = Constants.hignBGColor
        numLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        numLabel.text = "0.4m/s"
        return numLabel
      }()
    
    lazy var imag: UIImageView = {
        let imag = UIImageView()
        imag.image = UIImage(named: "roller_icon")
        
        return imag
      }()
    
    private func setupView() {

        self.backgroundColor = UIColor(red: 39/255.0, green: 41/255.0, blue: 51/255.0, alpha: 1.0)
        addSubview(typeLabel)
        addSubview(numLabel)
        
        typeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
      
      
        sliderView = SliderView.init(frame: .zero)
        sliderView.sliderDefalutValue = sliderDefalutValue
        sliderView.didMovedSliderd = {[weak self] value in
            print("666\(value)")
            self?.viewDidChoosed?(value)
        }
        self.addSubview(sliderView)
        sliderView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(typeLabel.snp_rightMargin).offset(24)
            make.height.equalTo(30)
            make.width.equalTo(205)

        }
        
        self.addSubview(imag)
        imag.snp.makeConstraints { make in
            make.left.equalTo(sliderView.snp_rightMargin).offset(53)
            make.centerY.equalTo(sliderView)
            make.size.equalTo(CGSize(width: 28, height: 28))

        }
        
        numLabel.snp.makeConstraints { make in
            make.left.equalTo(imag.snp_rightMargin).offset(14)
            make.centerY.equalTo(sliderView)

         }
        
    }
    
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
   
}
