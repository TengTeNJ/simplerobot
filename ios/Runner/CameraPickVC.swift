//
//  CameraPickVC.swift
//  Runner
//
//  Created by 孟恒 on 2025/3/5.
//

import UIKit

/// 相机捡球VC
import AVFoundation
import CoreML
import CoreMedia
import UIKit
import Vision
import Flutter
import Accelerate


var mlRobotModel = try! robot(configuration: mlRobotmodelConfig).model

var mlRobotmodelConfig: MLModelConfiguration = {
  let config = MLModelConfiguration()

  if #available(iOS 17.0, *) {
    config.setValue(1, forKey: "experimentalMLE5EngineUsage")
  }

  return config
}()

/// 鹰眼捡球界面的类别
extension CameraCalibrationController {
    
    /// 校准View
    func setUpUi() {

        
       // videoPreview = UIView(frame: CGRect(x: 0, y: 0, width: Constants.ScreenWidth, height: Constants.ScreenWidth))
        videoPreview = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        
        view.addSubview(videoPreview)
        view.addSubview(cameraMaskView)

        
        let backbtn = UIButton(frame: CGRect(x: 32, y: 32, width: 52, height: 52))
        backbtn.setImage(UIImage(named: "back_icon"), for: .normal)
        backbtn.backgroundColor = UIColor(red: 233/255.0, green: 100/255.0, blue: 21/255.0, alpha: 1.0)
        backbtn.contentEdgeInsets = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
        backbtn.imageView?.frame = CGRect(x: 0, y: 0, width: 10, height: 20)
        backbtn.layer.cornerRadius = 26
        backbtn.clipsToBounds = true
        backbtn.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        self.backBtn = backbtn
        view.addSubview(backbtn)
        
        let readybtn = UIButton(type: .custom)
        readybtn.frame = CGRect(x: Constants.ScreenWidth - 32 - 52, y: 32, width: 52, height: 52)
        readybtn.setImage(UIImage(named: "ready_icon.png"), for: .normal)
              
        readybtn.backgroundColor = UIColor(red: 156/255.0, green: 156/255.0, blue: 156/255.0, alpha: 0.85)
        readybtn.addTarget(self, action: #selector(nextAction(_:)), for: .touchUpInside)
        readybtn.contentEdgeInsets = UIEdgeInsets(top: 20, left: 17, bottom: 17, right: 14)
        readybtn.imageView?.contentMode = .scaleAspectFit
        readybtn.imageView?.frame = CGRect(x: 0, y: 0, width: 20, height: 15)
        readybtn.layer.cornerRadius = 26
        readybtn.clipsToBounds = true
        view.addSubview(readybtn)
        self.readyBtn = readybtn
        
        
        
       
        let desLabel = UILabel(frame: CGRect(x: 100, y: Constants.ScreenHeight - 120, width: Constants.ScreenWidth - 100*2, height: 46))
        desLabel.text = """
        Please position the key points of the court within the calibration
        circle to achieve field of view calibration.
        """
        desLabel.numberOfLines = 2
        desLabel.textColor = .white
        desLabel.textAlignment = .center
        view.addSubview(desLabel)
        self.desLab = desLabel
        
        
    }

    /// 四个关键点
    func createKeyPoint() {
        /// 固定坐标写死四个点
        let scale = 844.0/812.0;
        point1 = CommonTool.createVIew(CGRect(x: 376 * scale, y: 86 * scale, width: 5, height: 5))
        view.addSubview(point1)
        point2 = CommonTool.createVIew(CGRect(x: 471 * scale, y: 82 * scale, width: 5, height: 5))
        view.addSubview(point2)
        point3 = CommonTool.createVIew(CGRect(x: 698 * scale, y: 112 * scale, width: 5, height: 5))
        view.addSubview(point3)
        point4 = CommonTool.createVIew(CGRect(x: 607 * scale, y: 133 * scale, width: 5, height: 5))
        view.addSubview(point4)
    }
    
    
    func removeKeyPoint() {
        self.point1.removeFromSuperview()
        self.point2.removeFromSuperview()
        self.point3.removeFromSuperview()
        self.point4.removeFromSuperview()
    }
   
    
    // MARK: - 修改视频流宽高比(与训练YOLO模型保持一致 1920*1080)
    func resizePixelBuffer(_ pixelBuffer: CVPixelBuffer, toSize size: CGSize) -> CVPixelBuffer? {
        // Lock the base address of the pixel buffer
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        
        // Get information about the pixel buffer
        let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        
        // Create a new pixel buffer with the desired size
        var newPixelBuffer: CVPixelBuffer?
        let options = [kCVPixelBufferCGImageCompatibilityKey: true, kCVPixelBufferCGBitmapContextCompatibilityKey: true] as CFDictionary
        CVPixelBufferCreate(kCFAllocatorDefault, Int(size.width), Int(size.height), kCVPixelFormatType_32BGRA, options, &newPixelBuffer)
        
        // Lock the base address of the new pixel buffer
        CVPixelBufferLockBaseAddress(newPixelBuffer!, .readOnly)
        
        // Get the base address of the new pixel buffer
        let newBaseAddress = CVPixelBufferGetBaseAddress(newPixelBuffer!)
        
        // Perform the scaling using vImage
        var sourceBuffer = vImage_Buffer(data: baseAddress, height: vImagePixelCount(height), width: vImagePixelCount(width), rowBytes: bytesPerRow)
        var destinationBuffer = vImage_Buffer(data: newBaseAddress, height: vImagePixelCount(size.height), width: vImagePixelCount(size.width), rowBytes: CVPixelBufferGetBytesPerRow(newPixelBuffer!))
        
        let scaleError = vImageScale_ARGB8888(&sourceBuffer, &destinationBuffer, nil, 0)
        
        // Unlock the base addresses
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        CVPixelBufferUnlockBaseAddress(newPixelBuffer!, .readOnly)
        
        if scaleError != kvImageNoError {
            return nil
        }
        
        return newPixelBuffer
    }
    
}


class CameraPickVC: UIViewController, VideoCaptureDelegate{
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame: CMSampleBuffer) {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var channel: FlutterMethodChannel
    var binaryMessenger: FlutterBinaryMessenger

    init(binaryMessenger: FlutterBinaryMessenger) {
        self.channel = FlutterMethodChannel(name: "com.example/native", binaryMessenger: binaryMessenger)
        self.binaryMessenger = binaryMessenger
        super.init(nibName: nil, bundle: nil)
    }
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var videoPreview: UIView!

  let selection = UISelectionFeedbackGenerator()
  var session: AVCaptureSession!
  var videoCapture: VideoCapture!
  var currentBuffer: CVPixelBuffer?
  var framesDone = 0

  // var cameraOutput: AVCapturePhotoOutput!
  var longSide: CGFloat = 3
  var shortSide: CGFloat = 4
  var frameSizeCaptured = false

    
  var canvas: CameraPickCanvas!

    
    /// 校准界面的元素
    var readyBtn: UIButton!
    var backBtn: UIButton!
    var desLab: UILabel!
    
    var point1 = UIView()
    var point2 = UIView()
    var point3 = UIView()
    var point4 = UIView()

    // MARK: - 返回按钮点击事件处理
       @objc func back(_ sender: UIButton) {
           print("关键点检测界面返回了")
           self.dismiss(animated: true)
           /// 退出界面告诉机器人导航结束
           channel.invokeMethod("endNavigation", arguments: "2")
       }
    
    @objc func nextAction(_ sender: UIButton) {
        
        self.present(CameraCalibrationController(binaryMessenger: self.binaryMessenger), animated: false)

     }
  
    func setUpUi() {
        videoPreview = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        
        view.addSubview(videoPreview)
        
        let backbtn = UIButton(frame: CGRect(x: 32, y: 32, width: 52, height: 52))
        backbtn.setImage(UIImage(named: "back_icon"), for: .normal)
        backbtn.backgroundColor = UIColor(red: 233/255.0, green: 100/255.0, blue: 21/255.0, alpha: 1.0)
        backbtn.contentEdgeInsets = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
        backbtn.imageView?.frame = CGRect(x: 0, y: 0, width: 10, height: 20)
        backbtn.layer.cornerRadius = 26
        backbtn.clipsToBounds = true
        backbtn.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        self.backBtn = backbtn
        view.addSubview(backbtn)
        
        let readybtn = UIButton(type: .custom)
        readybtn.frame = CGRect(x: Constants.ScreenWidth - 32 - 52, y: 32, width: 52, height: 52)
        readybtn.setImage(UIImage(named: "ready_icon.png"), for: .normal)
              
        readybtn.backgroundColor = UIColor(red: 156/255.0, green: 156/255.0, blue: 156/255.0, alpha: 0.85)
        readybtn.addTarget(self, action: #selector(nextAction(_:)), for: .touchUpInside)
        readybtn.contentEdgeInsets = UIEdgeInsets(top: 20, left: 17, bottom: 17, right: 14)
        readybtn.imageView?.contentMode = .scaleAspectFit
        readybtn.imageView?.frame = CGRect(x: 0, y: 0, width: 20, height: 15)
        readybtn.layer.cornerRadius = 26
        readybtn.clipsToBounds = true
        view.addSubview(readybtn)
        self.readyBtn = readybtn
        
        
        
       
        let desLabel = UILabel(frame: CGRect(x: 100, y: Constants.ScreenHeight - 120, width: Constants.ScreenWidth - 100*2, height: 46))
        desLabel.text = """
        Please position the key points of the court within the calibration
        circle to achieve field of view calibration.
        """
        desLabel.numberOfLines = 2
        desLabel.textColor = .white
        desLabel.textAlignment = .center
        view.addSubview(desLabel)
        self.desLab = desLabel
        
    }
    
    // MARK: - 四个校准点

    func createKeyPoint() {
        /// 固定坐标写死四个点
        let scale = 844.0/812.0;
        point1 = CommonTool.createVIew(CGRect(x: 376 * scale, y: 86 * scale, width: 5, height: 5))
        view.addSubview(point1)
        point2 = CommonTool.createVIew(CGRect(x: 471 * scale, y: 82 * scale, width: 5, height: 5))
        view.addSubview(point2)
        point3 = CommonTool.createVIew(CGRect(x: 698 * scale, y: 112 * scale, width: 5, height: 5))
        view.addSubview(point3)
        point4 = CommonTool.createVIew(CGRect(x: 607 * scale, y: 133 * scale, width: 5, height: 5))
        view.addSubview(point4)
    }

  override func viewDidLoad() {
    super.viewDidLoad()
    
      
      videoPreview = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth))
      view.addSubview(videoPreview)
      
      self.setUpUi()
      self.createKeyPoint()
    setUpOrientationChangeNotification()
    startVideo()
    self.navigationController?.navigationBar.isHidden = true

  }
 
  private func setUpOrientationChangeNotification() {
    NotificationCenter.default.addObserver(
      self, selector: #selector(orientationDidChange),
      name: UIDevice.orientationDidChangeNotification, object: nil)
  }
    
    override func viewWillTransition(
      to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator
    ) {
      super.viewWillTransition(to: size, with: coordinator)

      self.videoCapture.previewLayer?.frame = CGRect(
        x: 0, y: 0, width: size.width, height: size.height)

    }

  @objc func orientationDidChange() {
    videoCapture.updateVideoOrientation()
  }
    
    // MARK: - CameraPickCanvasDelegate
    func CameraPickCanvasDelegate(_ view: CameraPickCanvas, didSendData data: String) {
        self.dismiss(animated: false)
    }
   
  /// Update thresholds from slider values

  let maxBoundingBoxViews = 100
  var boundingBoxViews = [BoundingBoxView]()
  var colors: [String: UIColor] = [:]


  func startVideo() {
    videoCapture = VideoCapture()
    videoCapture.delegate = self
    //videoCapture.captureDevice.videoZoomFactor = 0.5

    videoCapture.setUp(sessionPreset: .photo) { success in
      // .hd4K3840x2160 or .photo (4032x3024)  Warning: 4k may not work on all devices i.e. 2019 iPod
      if success {
        // Add the video preview into the UI.
        if let previewLayer = self.videoCapture.previewLayer {
          self.videoPreview.layer.addSublayer(previewLayer)
          self.videoCapture.previewLayer?.frame = self.videoPreview.bounds
            // resize preview layer

        }

        // Add the bounding box layers to the UI, on top of the video preview.
        for box in self.boundingBoxViews {
          box.addToLayer(self.videoPreview.layer)
        }

        // Once everything is set up, we can start capturing live video.
        self.videoCapture.start()
      }
    }
  }
}


