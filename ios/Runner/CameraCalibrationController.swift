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

/// 相机校准界面
class CameraCalibrationController: UIViewController,CameraPickCanvasDelegate {
   
    
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
    
    // 关键点模型检测的四个点
  let quadrilateralPoints: [CGPoint] = [
    CGPoint(x: 320, y: 116),  // 左上
    CGPoint(x: 430, y: 105),  // 右上
    CGPoint(x: 670, y: 124),  // 右下
    CGPoint(x: 586, y: 146)   // 左下
  ]
    
    // 定义图像中的菱形四个顶点
    let srcPoints: [CGPoint] = [
        CGPoint(x: 100, y: 100),  // 左上
        CGPoint(x: 300, y: 100),  // 右上
        CGPoint(x: 200, y: 300),  // 右下
        CGPoint(x: 0, y: 300)     // 左下
    ]

    // 定义目标矩形的四个顶点
    let dstPoints: [CGPoint] = [
        CGPoint(x: 420, y: 126),       // 左上
        CGPoint(x: 515, y: 126),     // 右上
        CGPoint(x: 515, y: 285),   // 右下
        CGPoint(x: 420, y: 285)      // 左下
    ]
    
    var canvas: CameraPickCanvas!

    
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
    
    var transform = CGAffineTransform()

    func calculateAffineTransform(from virtualPoints: [CGPoint], to realPoints: [CGPoint]) -> CGAffineTransform {
        let A = [
            virtualPoints[0].x, virtualPoints[0].y, 1, 0, 0, 0,
            0, 0, 0, virtualPoints[0].x, virtualPoints[0].y, 1,
            virtualPoints[1].x, virtualPoints[1].y, 1, 0, 0, 0,
            0, 0, 0, virtualPoints[1].x, virtualPoints[1].y, 1,
            virtualPoints[2].x, virtualPoints[2].y, 1, 0, 0, 0,
            0, 0, 0, virtualPoints[2].x, virtualPoints[2].y, 1,
            virtualPoints[3].x, virtualPoints[3].y, 1, 0, 0, 0,
            0, 0, 0, virtualPoints[3].x, virtualPoints[3].y, 1
        ]
        let B = [
            realPoints[0].x, realPoints[0].y,
            realPoints[1].x, realPoints[1].y,
            realPoints[2].x, realPoints[2].y,
            realPoints[3].x, realPoints[3].y
        ]
        
        var AMatrix = [Double](repeating: 0, count: 8 * 6)
        var BMatrix = [Double](repeating: 0, count: 8 * 1)
        for i in 0..<8 {
            for j in 0..<6 {
                AMatrix[i * 6 + j] = A[i * 6 + j]
            }
            BMatrix[i] = B[i]
        }
        
      var ipiv = [__CLPK_integer](repeating: 0, count: 6)
       var info: __CLPK_integer = 0
       var lda = __CLPK_integer(8)
       var ldb = __CLPK_integer(8)
       var nrhs = __CLPK_integer(1)
       var n = __CLPK_integer(6)
       
        dgesv_(&n, &nrhs, &AMatrix, &lda, &ipiv, &BMatrix, &ldb, &info)
       
//        if info != 0 {
//          print("Error in dgesv: \(info)")
//          return nil
//        }
        
        let a = BMatrix[0]
        let b = BMatrix[1]
        let c = BMatrix[2]
        let d = BMatrix[3]
        let e = BMatrix[4]
        let f = BMatrix[5]
        
        return CGAffineTransform(a: a, b: b, c: d, d: e, tx: c, ty: f)
    }
    
    func pointsToImage(points: [CGPoint]) -> UIImage? {
        guard points.count == 4 else { return nil }
        
        // 创建矩形路径
        let path = UIBezierPath()
        path.move(to: points[0])
        path.addLine(to: points[1])
        path.addLine(to: points[2])
        path.addLine(to: points[3])

        path.close()
        
        // 创建基于路径的图像
        UIGraphicsBeginImageContext(CGSize(width: 100, height: 100)) // 根据需要调整大小
        UIColor.blue.set() // 设置填充颜色
        path.fill()
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext() // 结束图像上下文
            return image
        }
        UIGraphicsEndImageContext() // 结束图像上下文（即使没有创建图像）
        return nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        ///未矫正的图像上（也就是相机原始拍到的图上）的点A
        let srcpoint: CGPoint = CGPoint(x: 670, y: 124)
        let dstPoint = try! MHPerspectiveTransform.perspectiveTransform(points: [srcpoint,])
        
                                
    
        setUpBoundingBoxViews()
        setUpOrientationChangeNotification()

        setUpUi()
        loadModel()
        setModel()
        startVideo()
        
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    /// 检测屏幕横竖屏
    private func setUpOrientationChangeNotification() {
      NotificationCenter.default.addObserver(
        self, selector: #selector(orientationDidChange),
        name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func orientationDidChange() {
      videoCapture.updateVideoOrientation()
      //      frameSizeCaptured = false
    }
    
    func setUpUi() {
        videoPreview = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth))
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
        readybtn.frame = CGRect(x: screenWidth - 32 - 52, y: 32, width: 52, height: 52)
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
        
        
        
       
        let desLabel = UILabel(frame: CGRect(x: 100, y: screenHeight - 120, width: screenWidth - 100*2, height: 46))
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
    
    // MARK: - CameraPickCanvasDelegate
    func CameraPickCanvasDelegate(_ view: CameraPickCanvas, didSendData data: String) {
        self.dismiss(animated: false)
    }
    
    func ModeSwitchDelegate(_ view: CameraPickCanvas, didSendData data: Int) {
        
    }
    
    // MARK: - beginPickBallDelegate 点击开始捡球的代理方法
    func beginPickBallDelegate(_ view: CameraPickCanvas, didSendData data: Bool) {
        channel.invokeMethod("beginPickBall", arguments: true)
     }
    
    // MARK: - 按钮点击事件处理
       @objc func back(_ sender: UIButton) {
           print("返回了")
           self.dismiss(animated: true)
       }
    
      @objc func nextAction(_ sender: UIButton) {
          /// 切换机器人位置模型检测
          mlModel = try! robot(configuration: .init()).model
          setModel()
          
          
          // 移除上一个界面的按钮
          self.backBtn.removeFromSuperview()
          self.readyBtn.removeFromSuperview()
          self.desLab.removeFromSuperview()
          
          canvas = CameraPickCanvas(frame: self.view.bounds)
          canvas.delegate = self
          view.addSubview(canvas)
          
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
                
                print("监测的结果\(results)");
            } else {
              self.show(predictions: [])
            }
        }
     

        
    DispatchQueue.main.async {
        self.point1.removeFromSuperview()
        self.point2.removeFromSuperview()
        self.point3.removeFromSuperview()
        self.point4.removeFromSuperview()
        self.cavasView.removeFromSuperview()

        if let keyPoints = request.results as? [VNCoreMLFeatureValueObservation] {
            self.showKeyPoint(predictions: keyPoints)
        }
 
    // Measure FPS
    }
}
      
    var colors: [String: UIColor] = [:]
    let ultralyticsColorsolors: [UIColor] = [
      UIColor(red: 4 / 255, green: 42 / 255, blue: 255 / 255, alpha: 0.6),  // #042AFF
      UIColor(red: 11 / 255, green: 219 / 255, blue: 235 / 255, alpha: 0.6),  // #0BDBEB
      UIColor(red: 243 / 255, green: 243 / 255, blue: 243 / 255, alpha: 0.6),  // #F3F3F3
      UIColor(red: 0 / 255, green: 223 / 255, blue: 183 / 255, alpha: 0.6),  //
    ]
    
    func setUpBoundingBoxViews() {
      // Ensure all bounding box views are initialized up to the maximum allowed.
      while boundingBoxViews.count < 100 {
        boundingBoxViews.append(BoundingBoxView())
      }

      // Retrieve class labels directly from the CoreML model's class labels, if available.
      guard let classLabels = mlRobotModel.modelDescription.classLabels as? [String] else {
        fatalError("Class labels are missing from the model description")
      }

      // Assign random colors to the classes.
      var count = 0
      for label in classLabels {
        let color = ultralyticsColorsolors[count]
        count += 1
        if count > 19 {
          count = 0
        }
        colors[label] = color

      }
    }

    
    // MARK: - 关键点模型的检测结果
    func showKeyPoint(predictions: [VNCoreMLFeatureValueObservation]) {
    for observation in predictions {
        if let multiArrayValue = observation.featureValue.multiArrayValue {
            if multiArrayValue.shape == [1,8] {
                let values = (0..<8).map { multiArrayValue[$0] }
                //处理这些值
                let x1 = values[0]
                let y1 = values[1]
                let x2 = values[2]
                let y2 = values[3]
                let x3 = values[4]
                let y3 = values[5]
                let x4 = values[6]
                let y4 = values[7]

                // 根据需要处理其他值
                print("Bounding box: (\(x1), \(y1), \(x2), \(y2), \(x3), \(y3), \(x4), \(y4))")
                let screenWidth = UIScreen.main.bounds.width

                
                cavasView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height:screenWidth * 1080 / 1920 ))
                cavasView.isUserInteractionEnabled = false
                view.addSubview(cavasView)
                
                let x_scsle = 1920.0 / screenWidth
                let y_scsle = 1080.0 / (screenWidth * 1080 / 1920)

        
                point1 = UIView(frame: CGRect(x: CGFloat(x1) / (x_scsle), y: CGFloat(y1) / (y_scsle), width: keyPointSize, height: keyPointSize))
                //point1.backgroundColor = .red
                point1.backgroundColor = pointColor
                point1.layer.cornerRadius = keyPointSize / 2

                cavasView.addSubview(point1)
                
                point2 = UIView(frame: CGRect(x: CGFloat(x2) / (x_scsle), y: CGFloat(y2) / (y_scsle), width: keyPointSize, height: keyPointSize))
//                point2.backgroundColor = .orange
                point2.backgroundColor = pointColor
                point2.layer.cornerRadius = keyPointSize / 2

                cavasView.addSubview(point2)
                
                
                point3 = UIView(frame: CGRect(x: CGFloat(x3) / (x_scsle), y: CGFloat(y3) / (y_scsle), width: keyPointSize, height: keyPointSize))
              //  point3.backgroundColor = .white
                point3.backgroundColor = pointColor
                point3.layer.cornerRadius = keyPointSize / 2
                cavasView.addSubview(point3)
                
                
                point4 = UIView(frame: CGRect(x: CGFloat(x4) / (x_scsle), y: CGFloat(y4) / (y_scsle), width: keyPointSize, height: keyPointSize))
//                point4.backgroundColor = .black
                point4.backgroundColor = pointColor
                point4.layer.cornerRadius = keyPointSize / 2

                cavasView.addSubview(point4)
                
                CommonTool.tranferRectangle(point1: CGPoint(x: CGFloat(x1) / (x_scsle), y: CGFloat(y2) / (y_scsle)), point2: CGPoint(x: CGFloat(x2) / (x_scsle), y: CGFloat(y2) / (y_scsle)), point3: CGPoint(x: CGFloat(x3) / (x_scsle), y: CGFloat(y3) / (y_scsle)), point4: CGPoint(x: CGFloat(x4) / (x_scsle), y: CGFloat(y4) / (y_scsle)))
                
               let rectangleWIdth =  CommonTool.calculateDistance(point1: CGPoint(x: 320, y: 116), point2: CGPoint(x: 670, y: 124))
                
                let rectangleHeight =  CommonTool.calculateDistance(point1: CGPoint(x: 430, y: 105), point2: CGPoint(x: 586, y: 146))
                print("矩形的宽高为\(rectangleWIdth)---\(rectangleHeight)")
                
                /// finley 那边数据
                let rectangleWIdth1 =  CommonTool.calculateDistance(point1: CGPoint(x: 1525, y: 342), point2: CGPoint(x: 727, y: 325))
                
                let rectangleHeight1 =  CommonTool.calculateDistance(point1: CGPoint(x: 1336, y: 411), point2: CGPoint(x: 994, y: 300))
                
                print("真实的矩形的宽高为\(rectangleWIdth1)---\(rectangleHeight1)")

                
                
            }
        }
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

        // Invoke a VNRequestHandler with that image
        let handler = VNImageRequestHandler(
          cvPixelBuffer: pixelBuffer, orientation: imageOrientation, options: [:])
        if UIDevice.current.orientation != .faceUp {  // stop if placed down on a table
         // t0 = CACurrentMediaTime()  // inference start
          do {
            try handler.perform([visionRequest])
            let frameWidth = CGFloat(CVPixelBufferGetWidth(pixelBuffer))
            let frameHeight = CGFloat(CVPixelBufferGetHeight(pixelBuffer))
        
          } catch {
            print(error)
          }
         // t1 = CACurrentMediaTime() - t0  // inference dt
        }

        currentBuffer = nil
      }
    }
    
    /// 机器人位置
    func show(predictions: [VNRecognizedObjectObservation]) {
      var str = ""
      // date
      let date = Date()
      let calendar = Calendar.current
      let hour = calendar.component(.hour, from: date)
      let minutes = calendar.component(.minute, from: date)
      let seconds = calendar.component(.second, from: date)
      let nanoseconds = calendar.component(.nanosecond, from: date)
      let sec_day =
        Double(hour) * 3600.0 + Double(minutes) * 60.0 + Double(seconds) + Double(nanoseconds) / 1E9  // seconds in the day

     // self.labelSlider.text =
      //  String(predictions.count) + " items (max " + String(Int(slider.value)) + ")"
      let width = videoPreview.bounds.width  // 375 pix
      let height = videoPreview.bounds.height  // 812 pix

      if UIDevice.current.orientation == .portrait {

        // ratio = videoPreview AR divided by sessionPreset AR
        var ratio: CGFloat = 1.0
        if videoCapture.captureSession.sessionPreset == .photo {
          ratio = (height / width) / (4.0 / 3.0)  // .photo
        } else {
          ratio = (height / width) / (16.0 / 9.0)  // .hd4K3840x2160, .hd1920x1080, .hd1280x720 etc.
        }

        for i in 0..<boundingBoxViews.count {
          if i < predictions.count && i < 10 {
            let prediction = predictions[i]

            var rect = prediction.boundingBox  // normalized xywh, origin lower left
            switch UIDevice.current.orientation {
            case .portraitUpsideDown:
              rect = CGRect(
                x: 1.0 - rect.origin.x - rect.width,
                y: 1.0 - rect.origin.y - rect.height,
                width: rect.width,
                height: rect.height)
            case .landscapeLeft:
              rect = CGRect(
                x: rect.origin.x,
                y: rect.origin.y,
                width: rect.width,
                height: rect.height)
            case .landscapeRight:
              rect = CGRect(
                x: rect.origin.x,
                y: rect.origin.y,
                width: rect.width,
                height: rect.height)
            case .unknown:
              print("The device orientation is unknown, the predictions may be affected")
              fallthrough
            default: break
            }

            if ratio >= 1 {  // iPhone ratio = 1.218
              let offset = (1 - ratio) * (0.5 - rect.minX)
              let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: offset, y: -1)
              rect = rect.applying(transform)
              rect.size.width *= ratio
            } else {  // iPad ratio = 0.75
              let offset = (ratio - 1) * (0.5 - rect.maxY)
              let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: offset - 1)
              rect = rect.applying(transform)
              ratio = (height / width) / (3.0 / 4.0)
              rect.size.height /= ratio
            }

            // Scale normalized to pixels [375, 812] [width, height]
            rect = VNImageRectForNormalizedRect(rect, Int(width), Int(height))

            // The labels array is a list of VNClassificationObservation objects,
            // with the highest scoring class first in the list.
            let bestClass = prediction.labels[0].identifier
            let confidence = prediction.labels[0].confidence
            // print(confidence, rect)  // debug (confidence, xywh) with xywh origin top left (pixels)
            let label = String(format: "%@ %.1f", bestClass, confidence * 100)
            let alpha = CGFloat((confidence - 0.2) / (1.0 - 0.2) * 0.9)
            // Show the bounding box.
            boundingBoxViews[i].show(
              frame: rect,
              label: label,
              color: UIColor.white,
              alpha: alpha)  // alpha 0 (transparent) to 1 (opaque) for conf threshold 0.2 to 1.0)

          } else {
            boundingBoxViews[i].hide()
          }
        }
      } else {
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

            let label = String(format: "%@ %.1f", bestClass, confidence * 100)
            let alpha = CGFloat((confidence - 0.2) / (1.0 - 0.2) * 0.9)
              
              print("检测到的机器人的结果为\(rect)\(alpha)")
            let isKeyPoints =  CommonTool.isPointInsideQuadrilateral(point: CGPoint(x: rect.origin.x, y: rect.origin.y), quadrilateralPoints: quadrilateralPoints)
             
              let srcpoint: CGPoint = CGPoint(x: rect.origin.x, y: rect.origin.y)
              let dstPoints = try! MHPerspectiveTransform.perspectiveTransform(points: [srcpoint,])
              let dstPoint = dstPoints.first
              /// 更新机器人位置
              canvas.updateRobotLocation(x: Double(dstPoint!.x), y: Double(dstPoint!.y))
            // Show the bounding box.
            boundingBoxViews[i].show(
              frame: rect,
              label: label,
              color: isKeyPoints ? UIColor.red : UIColor.white,
              alpha: alpha)  // alpha 0 (transparent) to 1 (opaque) for conf threshold 0.2 to 1.0)
          } else {
            boundingBoxViews[i].hide()
          }
        }
      }
     
    }

}

extension CameraCalibrationController: VideoCaptureDelegate {
  func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame sampleBuffer: CMSampleBuffer) {
    predict(sampleBuffer: sampleBuffer)
  }
}
