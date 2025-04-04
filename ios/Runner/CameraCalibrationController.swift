//
//  CameraCalibrationController.swift
//  Runner
//
//  Created by mh on 2025/3/1.
//

import UIKit
import opencv2
import Accelerate

import CoreML
import Vision
import CoreMedia
import Flutter


var mlModel = try!key_point(configuration: mlmodelConfig).model
var mlmodelConfig: MLModelConfiguration = {
  let config = MLModelConfiguration()

  if #available(iOS 17.0, *) {
    config.setValue(1, forKey: "experimentalMLE5EngineUsage")
  }

  return config
}()

/// 鹰眼捡球界面
class CameraCalibrationController: UIViewController,CameraPickCanvasDelegate, CustomAlertViewDelegate {
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var channel: FlutterMethodChannel
    var binaryMessenger: FlutterBinaryMessenger

    init(binaryMessenger: FlutterBinaryMessenger) {
        self.binaryMessenger = binaryMessenger
        self.channel = FlutterMethodChannel(name: "com.example/native", binaryMessenger: binaryMessenger)
        super.init(nibName: nil, bundle: nil)

    }
  
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
      
    
    var videoPreview: UIView!

    let selection = UISelectionFeedbackGenerator()
    var detector = try! VNCoreMLModel(for: mlModel)
    var session: AVCaptureSession!
    var videoCapture: VideoCapture!
    var currentBuffer: CVPixelBuffer?
 
    var longSide: CGFloat = 3
    var shortSide: CGFloat = 4
    var frameSizeCaptured = false
    
    var boundingBoxViews = [BoundingBoxView]()

    
    /// 校准界面的元素
    var readyBtn: UIButton!
    var backBtn: UIButton!
    var desLab: UILabel!

    var point1 = UIView()
    var point2 = UIView()
    var point3 = UIView()
    var point4 = UIView()
    
    var cavasView = UIView()
    var keyPointSize = 15.0
    var pointColor = UIColor(red: 91/255.0, green: 204/255.0, blue: 106/255.0, alpha: 1.0)
    
    /// 当前机器人的模式（休息模式与训练模式）
    var currentRobotMode = Constants.CurrentRobotModel.rest// 默认休息模式
    /// 当前原点的坐标（原点导航用  机器人捡满50球回到的地方）
    var currebtOriginPoint: CGPoint = NavigationTool.getRightBottomOriginCoordinate()
    // 电子围栏导航的终点的坐标（电子围栏导航用  机器人出电子围栏回到的地方） 默认休息模式下的中心点
    var currebtElectronicfenceDesinationPoint: CGPoint = NavigationTool.getRestModelEletronicFenceCenterPoint()
   
    /// 当前原点的矩形框
    var currebtOriginRectangle: CGRect = NavigationTool.getRightBottomOriginRectangle()
    /// 当前机器人在虚拟地图上的位置
    var curentRobotPosition  = CGPoint(x: 0, y: 0)
    /// 当前的电子围栏区域（休息默认下默认电子围栏为整个） 训练模式为选中的矩形框
    var currentElectronicFenceArea = NavigationTool.getRestModelEletronicFenceRectangle()
    /// 是否开始原点导航（机器人捡满50球开始）
    var originNavigation: Bool = false
    /// 是否开始电子围栏导航（
    var electronicFenceNavigation: Bool = false
    
    /// 当前小矩形框矩形框判断
    var currentElectronicFenceDesinationSamllRectangle = NavigationTool.getRestModelEletronicFenceCenterRectangle()
    
    /// 拟合出来的前十次机器人的坐标
    var averagePoint = CGPoint(x: 0, y: 0)
    /// 上次给机器人导航的时间
    var lastNaviDate = Date()

    
    //var canvas: CameraPickCanvas!
    
    /// 上次机器人的位置
    var lastRobotPosition  = CGPoint(x: 0, y: 0)
    
    /// 上次检测到机器人的时间
    var lastTime = Date()

    /// 运动坐标合集
    var queue = NSMutableArray()
    
    /// 第一次计算出来的机器人的角度
    var firstRobotAngle: Double = 0
    
    lazy var realRobot : UIView = {
        let real = CommonTool.createVIew(CGRect(x: 0, y: 0, width: 5, height: 5))
        real.backgroundColor = .black
        view.addSubview(real)

        return real
    }()
    
    lazy var cameraMaskView : UIView = {
        let maskView = CommonTool.createVIew(CGRect(x: 0, y: 0, width: Constants.ScreenWidth, height: Constants.ScreenHeight))
        maskView.backgroundColor = Constants.maskColor
        return maskView
    }()
    
    lazy var visionRequest: VNCoreMLRequest = {
      let request = VNCoreMLRequest(
        model: detector,
        completionHandler: {
          [weak self] request, error in
          self?.processObservations(for: request, error: error)
        })
      request.imageCropAndScaleOption = .scaleFill  // .scaleFit, .scaleFill, .centerCrop
      return request
    }()
    
    /// 画布
    lazy var canvas: CameraPickCanvas = {
        canvas = CameraPickCanvas(frame: self.view.bounds)
       // canvas.alpha = 0.5
        canvas.delegate = self
        canvas.isUserInteractionEnabled = true
        view.addSubview(canvas)
        canvas.isHidden = true
        return canvas
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bridge = OpenCVBridgeFile()
        bridge.calculateHomegraphyMatsss()
        setUpBoundingBoxViews()
        setUpOrientationChangeNotification()

        setUpUi()
      
        mlModel = try! robot(configuration: .init()).model
        setModel()
        startVideo()
        
        ///  默认给机器人训练模式
        channel.invokeMethod("changeRobotMode", arguments: "training")
        // 默认休息模式
        currentElectronicFenceArea = NavigationTool.getRestModelEletronicFenceRectangle()
        currentElectronicFenceDesinationSamllRectangle = NavigationTool.getRestModelEletronicFenceCenterRectangle()

        createKeyPoint()
        self.navigationController?.navigationBar.isHidden = true
        // 注册通知监听器
        NotificationCenter.default.addObserver(self, selector: #selector(handleFullNotification(_:)), name: Notification.Name(Constants.Notification_Robot_Ball_Full), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleBeginNotification(_:)), name: Notification.Name(Constants.Notification_Robot_Begin_Navi), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEndNotification(_:)), name: Notification.Name(Constants.Notification_Robot_End_Navi), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAvoEndNotification(_:)), name: Notification.Name(Constants.Notification_Robot_Obstacle_Avoidance_End_Navi), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDisconnectNotification(_:)), name: Notification.Name(Constants.Notification_Robot_Bluetooth_Disconnect), object: nil)
      
     }

    /// 检测屏幕横竖屏
    private func setUpOrientationChangeNotification() {
      NotificationCenter.default.addObserver(
        self, selector: #selector(orientationDidChange),
        name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func orientationDidChange() {
      videoCapture.updateVideoOrientation()
      //frameSizeCaptured = false
    }
        
    // MARK: 鹰眼捡球界面返回按钮点击 - CameraPickCanvasDelegate
    func CameraPickCanvasDelegate(_ view: CameraPickCanvas, didSendData data: String) {
        if (data == "cali") {
            channel.invokeMethod("robotReset", arguments: "2")// 机器人重置
            self.dismiss(animated: false)
            self.canvas.robot.removeFromSuperview()
        } else {
            let alertVC = CustomAlertViewController(title: "Confirm Exit", message: "Are you sure You want to exit")
            alertVC.delegate  = self
            alertVC.modalPresentationStyle = .overFullScreen
            present(alertVC, animated: false, completion: nil)
        }
     }
    
    func CustomAlertViewConfirmDelegate(_ view: CustomAlertViewController, didSendData data: String) {
        print("鹰眼捡球界面点击返回按钮")
        channel.invokeMethod("robotReset", arguments: "2") // 机器人重置
        self.dismiss(animated: false)
        self.canvas.robot.removeFromSuperview()
                
    }
    
    // MARK: - 关键点校准界面返回按钮点击事件处理
       @objc func back(_ sender: UIButton) {
           print("关键点检测界面点击返回按钮")
           self.dismiss(animated: true)
           self.canvas.robot.removeFromSuperview()
           /// 退出界面告诉机器人导航结束
           channel.invokeMethod("endNavigation", arguments: "2")
    }
    
      @objc func nextAction(_ sender: UIButton) {
          /// 开始录制视频
         // videoCapture.startRecordVideo()
          // 移除上一个界面的按钮
          self.backBtn.removeFromSuperview()
          self.readyBtn.removeFromSuperview()
          self.desLab.removeFromSuperview()
          
          canvas.isHidden = false
          removeKeyPoint()
         /// 切换到另一个界面
         // self.present(CameraPickVC(binaryMessenger: self.binaryMessenger), animated: false)
    }
    
    // MARK: - 加载关键点mlmodel
    func loadModel() {
        // 加载关键点mlmodel
        mlModel = try! key_point(configuration: .init()).model
    }
    
    func setModel() {
       /// VNCoreMLModel
      detector = try! VNCoreMLModel(for: mlModel)
      detector.featureProvider = ThresholdProvider()
      /// 机器人的置信度修改为0.7，防止误识别
      detector.featureProvider = ThresholdProvider(iouThreshold: 0.45, confidenceThreshold: 0.6)

      /// VNCoreMLRequest
      let request = VNCoreMLRequest(
        model: detector,
        completionHandler: { [weak self] request, error in
          self?.processObservations(for: request, error: error)
        })
      request.imageCropAndScaleOption = .scaleFill  // .scaleFit, .scaleFill, .centerCrop
      visionRequest = request
    }
    
    // MARK: - 开启视频
    func startVideo() {
    videoCapture = VideoCapture()
    videoCapture.delegate = self

    videoCapture.setUp(sessionPreset: .photo) { success in
    // .hd4K3840x2160 or .photo (4032x3024)  Warning: 4k may not work on all devices i.e. 2019 iPod
    if success {
        // Add the video preview into the UI.
        if let previewLayer = self.videoCapture.previewLayer {
        self.videoPreview.layer.addSublayer(previewLayer)
        // self.videoCapture.previewLayer?.frame = self.videoPreview.bounds
            // resize preview layer
            self.videoCapture.previewLayer?.frame = self.videoPreview.bounds
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

    func processObservations(for request: VNRequest, error: Error?) {
    //print("关键点监测的结果\(request.results)")
        DispatchQueue.main.async {
            if let results = request.results as? [VNRecognizedObjectObservation] {
                DispatchQueue.main.async {
                    self.show(predictions: results)
                 }
            } else {
              self.show(predictions: [])
            }
        }
  }
      
    func setUpBoundingBoxViews() {
      // Ensure all bounding box views are initialized up to the maximum allowed.
      while boundingBoxViews.count < 100 {
        boundingBoxViews.append(BoundingBoxView())
      }

      // Retrieve class labels directly from the CoreML model's class labels, if available.
      guard let classLabels = mlRobotModel.modelDescription.classLabels as? [String] else {
        fatalError("Class labels are missing from the model description")
      }
   }

    func predict(sampleBuffer: CMSampleBuffer) {
      if currentBuffer == nil, let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
        currentBuffer = pixelBuffer
        if !frameSizeCaptured {
          let frameWidth = CGFloat(CVPixelBufferGetWidth(pixelBuffer))
          let frameHeight = CGFloat(CVPixelBufferGetHeight(pixelBuffer))
          longSide = max(frameWidth, frameHeight)
          shortSide = min(frameWidth, frameHeight)
          frameSizeCaptured = true
        }
        /// - Tag: MappingOrientation
        // The frame is always oriented based on the camera sensor,
        // so in most cases Vision needs to rotate it for the model to work as expected.
        let imageOrientation: CGImagePropertyOrientation
        switch UIDevice.current.orientation {
        case .portrait:
          imageOrientation = .up
        case .portraitUpsideDown:
          imageOrientation = .down
        case .landscapeLeft:
          imageOrientation = .up
        case .landscapeRight:
          imageOrientation = .up
        case .unknown:
          imageOrientation = .up
        default:
          imageOrientation = .up
        }

         let newSize = CGSize(width: 1920, height: 1080)

      // 使用 Accelerate 调整大小
         if let resizedPixelBuffer = resizePixelBuffer(pixelBuffer, toSize: newSize) {
             // 使用调整大小后的 pixelBuffer
             let handler = VNImageRequestHandler(
               cvPixelBuffer: resizedPixelBuffer, orientation: imageOrientation, options: [:])
             if UIDevice.current.orientation != .faceUp {  // stop if placed down on a table
              // t0 = CACurrentMediaTime()  // inference start
               do {
                 try handler.perform([visionRequest])
                 let frameWidth = CGFloat(CVPixelBufferGetWidth(resizedPixelBuffer))
                 let frameHeight = CGFloat(CVPixelBufferGetHeight(resizedPixelBuffer))
//                   print("视频流宽\(frameWidth) 高\(frameHeight)")
             
               } catch {
                 print(error)
               }
              // t1 = CACurrentMediaTime() - t0  // inference dt
             }
         }
          
          currentBuffer = nil
      }
    }
   
    // MARK: - 显示真实世界机器人的位置
    func show(predictions: [VNRecognizedObjectObservation]) {

      let width = videoPreview.bounds.width  // 375 pix
      let height = videoPreview.bounds.height  // 812 pix


        let frameAspectRatio = longSide / shortSide
        let viewAspectRatio = width / height
        var scaleX: CGFloat = 1.0
        var scaleY: CGFloat = 1.0
        var offsetX: CGFloat = 0.0
        var offsetY: CGFloat = 0.0

        if frameAspectRatio > viewAspectRatio {
          scaleY = height / shortSide
          scaleX = scaleY
          offsetX = (longSide * scaleX - width) / 2
        } else {
          scaleX = width / longSide
          scaleY = scaleX
          offsetY = (shortSide * scaleY - height) / 2
        }

        for i in 0..<boundingBoxViews.count {
          if i < predictions.count {
            let prediction = predictions[i]
            
            var rect = prediction.boundingBox

            rect.origin.x = rect.origin.x * longSide * scaleX - offsetX
            rect.origin.y =
              height
              - (rect.origin.y * shortSide * scaleY - offsetY + rect.size.height * shortSide * scaleY)
            rect.size.width *= longSide * scaleX
            rect.size.height *= shortSide * scaleY

            let bestClass = prediction.labels[0].identifier
            let confidence = prediction.labels[0].confidence
           // print("机器人的置信度\(confidence)")


            let label = String(format: "%@ %.1f", bestClass, confidence * 100)
            let alpha = CGFloat((confidence - 0.2) / (1.0 - 0.2) * 0.9)
              
             
              var srcpoint: CGPoint = CGPoint(x: rect.origin.x, y: rect.origin.y)
              
             /// 透视效果机器人的位置坐标以机器人的中心计算，不应该以机器人的左上角计算。
              srcpoint.x = rect.origin.x + rect.size.width / 2
             // srcpoint.y = rect.origin.y + rect.size.height / 2
              /// 对位置进行校正
              let center_y = rect.origin.y + rect.size.height / 2
              let center_percent = center_y / screenHeight
              let half_y_distance =  rect.size.height / 2
              let real_point_y = center_y + half_y_distance * (1-center_percent)
              srcpoint.y = real_point_y
//              
              realRobot.frame.origin = CGPoint(x: srcpoint.x, y: srcpoint.y)
              print("位置为\(realRobot.frame)")
             
              let dstPoints = try! MHPerspectiveTransform.perspectiveTransform(points: [srcpoint,])
              let dstPoint = dstPoints.first
              
              // 显示虚拟地图机器人的位置
              showVirtualRobotPosition(dstPoint: dstPoint ?? CGPoint(x: 0, y: 0))
            
              /// 电子围栏区域,超出显示红色
              var isInElectronicFence = true
              let rectangle = currentElectronicFenceArea
              if (rectangle.contains(dstPoint ?? CGPoint(x: 0, y: 0))) {
                  isInElectronicFence  = true
              } else {
                  isInElectronicFence  = false
              }
              
            // Show the bounding box.
            boundingBoxViews[i].show(
              frame: rect,
              label: label,
              color: isInElectronicFence ? UIColor.white : UIColor.red,
              alpha: alpha)  // alpha 0 (transparent) to 1 (opaque) for conf threshold 0.2 to 1.0)
          } else {
            boundingBoxViews[i].hide()
          }
        }
    }
    
}

extension CameraCalibrationController: VideoCaptureDelegate {
  func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame sampleBuffer: CMSampleBuffer) {
    predict(sampleBuffer: sampleBuffer)
  }
}
