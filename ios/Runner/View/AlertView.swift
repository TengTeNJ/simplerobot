//
//  CustomAlertViewController.swift
//  Runner
//
//  Created by 孟恒 on 2025/3/6.
//


import UIKit


protocol CustomAlertViewDelegate: AnyObject {
    func CustomAlertViewConfirmDelegate(_ view: CustomAlertViewController, didSendData data: String)
  
}
class CustomAlertViewController: UIViewController {
    // 弹窗的画布
    private let canvas = UIView()
    // 弹窗的标题
    private let titleLabel = UILabel()
    // 弹窗的内容
    private let messageLabel = UILabel()
    // 确认按钮
    private let confirmButton = UIButton(type: .custom)
    // 取消按钮
    private let cancelButton = UIButton(type: .custom)
    
    weak var delegate: CustomAlertViewDelegate?

    
    // 初始化方法
    init(title: String, message: String) {
        super.init(nibName: nil, bundle: nil)
        self.titleLabel.text = title
        self.messageLabel.text = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(spaceTap(_:)))

        
        view.backgroundColor = Constants.alertBGColor
        view.layer.cornerRadius = 10
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.clipsToBounds = true
        
        canvas.frame.size = CGSize(width: 279, height: 283)
        canvas.center = view.center
        canvas.backgroundColor = Constants.alertCanvasBGColor
        canvas.layer.cornerRadius = 10
        canvas.isUserInteractionEnabled = true
        view.addSubview(canvas)
        
        
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        canvas.addSubview(titleLabel)
        
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.textColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        canvas.addSubview(messageLabel)
        
        confirmButton.setTitle("Yes", for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        confirmButton.backgroundColor = UIColor(red: 233/255.0, green: 100/255.0, blue: 21/255.0, alpha: 1.0)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
//        confirmButton.frame.size = CGSize(width: 151, height: 40)
        confirmButton.layer.cornerRadius = 20
        confirmButton.clipsToBounds = true
        canvas.addSubview(confirmButton)
        
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        cancelButton.frame.size = CGSize(width: 15, height: 15)
        cancelButton.setImage(UIImage(named: "close_new_icon"), for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        canvas.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: canvas.topAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: canvas.trailingAnchor, constant: -16),
            cancelButton.widthAnchor.constraint(equalToConstant: 15), // 设置固定
            cancelButton.heightAnchor.constraint(equalToConstant: 15), // 设置固定

            
            
            titleLabel.topAnchor.constraint(equalTo: canvas.topAnchor, constant: 97),
            titleLabel.leadingAnchor.constraint(equalTo: canvas.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: canvas.trailingAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: canvas.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: canvas.trailingAnchor, constant: -20),
            
            confirmButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            confirmButton.leadingAnchor.constraint(equalTo: canvas.leadingAnchor, constant: 64),
            
            confirmButton.widthAnchor.constraint(equalToConstant: 151), // 设置固定宽度
            confirmButton.heightAnchor.constraint(equalToConstant: 40), // 设置固定宽度

          
        ])
    }
    
    @objc private func confirmAction() {
        print("Confirm button tapped")
        dismiss(animated: false, completion: nil)
        delegate?.CustomAlertViewConfirmDelegate(self, didSendData: "")
        
    }
    
    @objc private func cancelAction() {
        print("Cancel button tapped")
        dismiss(animated: false, completion: nil)
    }
    
    
    @objc func spaceTap(_ gesture: UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
   }
}
